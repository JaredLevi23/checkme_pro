package com.example.check_developer_main.ble.worker

import android.bluetooth.BluetoothDevice
import android.content.Context
import android.util.Log
import com.example.check_developer_main.MainActivity
import com.example.check_developer_main.ble.format.CheckMeResponse
import com.example.check_developer_main.ble.format.DeviceInfo
import com.example.check_developer_main.ble.manager.BleDataManager
import com.example.check_developer_main.ble.pkg.EndReadPkg
import com.example.check_developer_main.ble.pkg.GetDeviceInfoPkg
import com.example.check_developer_main.ble.pkg.ReadContentPkg
import com.example.check_developer_main.ble.pkg.StartReadPkg
import com.example.check_developer_main.utils.CRCUtils
import com.example.check_developer_main.utils.Constant
import com.example.check_developer_main.utils.add
import com.example.check_developer_main.utils.toUInt
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import no.nordicsemi.android.ble.data.Data
import org.json.JSONException
import org.json.JSONObject
import java.io.File
import kotlin.experimental.inv

class BleDataWorker{
    private var pool: ByteArray? = null
    private val deviceChannel = Channel<DeviceInfo>(Channel.CONFLATED)
    private val fileChannel = Channel<Int>(Channel.CONFLATED)
    private val connectChannel = Channel<String>(Channel.CONFLATED)
    private  var myBleDataManager: BleDataManager?=null
    private val dataScope = CoroutineScope(Dispatchers.IO)
    private val mutex = Mutex()

    private var cmdState = 0;
    var pkgTotal = 0;
    var currentPkg = 0;
    var fileData: ByteArray? = null
    var currentFileName = ""
    var result = 1;
    var currentFileSize = 0


    companion object {
        val fileProgressChannel = Channel<FileProgress>(Channel.CONFLATED)
    }

    data class FileProgress(
        var name: String = "",
        var progress: Int = 0,
        var success: Boolean = false
    )

    private val comeData = object : BleDataManager.OnNotifyListener {
        override fun onNotify(device: BluetoothDevice?, data: Data?) {
            data?.value?.apply {
                pool = add(pool, this)
            }
            pool?.apply {
                pool = handleDataPool(pool)
            }
        }

    }


    private fun handleDataPool(bytes: ByteArray?): ByteArray? {
        Log.d("CMDSTATE", "$cmdState")
        val bytesLeft: ByteArray? = bytes

        if (bytes == null || bytes.size < 8) {
            return bytes
        }
        loop@ for (i in 0 until bytes.size - 7) {
            if (bytes[i] != 0x55.toByte() || bytes[i + 1] != bytes[i + 2].inv()) {
                continue@loop
            }

            // need content length
            val len = toUInt(bytes.copyOfRange(i + 5, i + 7))
            if (i + 8 + len > bytes.size) {
                continue@loop
            }

            val temp: ByteArray = bytes.copyOfRange(i, i + 8 + len)
            if (temp.last() == CRCUtils.calCRC8(temp)) {

                if (cmdState in 1..3) {
                    val bleResponse = CheckMeResponse(temp)
                    if (cmdState == 1) {
                        fileData = null
                        currentFileSize = toUInt(bleResponse.content)
                        pkgTotal = currentFileSize / 512
                        if (bleResponse.cmd == 1) {
                            result = 1
                            val pkg = EndReadPkg()
                            sendCmd(pkg.buf)
                            cmdState = 3
                        } else if (bleResponse.cmd == 0) {
                            val pkg =
                                ReadContentPkg(currentPkg)
                            sendCmd(pkg.buf)
                            currentPkg++
                            cmdState = 2;
                        }


                    } else if (cmdState == 2) {
                        bleResponse.content.apply {
                            fileData = add(fileData, this)
                            fileData?.let {
                                dataScope.launch {
                                    fileProgressChannel.send(
                                        FileProgress(
                                            currentFileName,
                                            100,//it.size * 100 / currentFileSize,
                                            true
                                        )
                                    )
                                }
                            }
                        }

                        if (currentPkg > pkgTotal) {
                            fileData?.apply {
                                try{
                                    result = 0
                                    Log.i("file", "receive  $currentFileName")
                                    File(Constant.getPathX(currentFileName)).writeBytes(this)
                                }catch (e:Exception){
                                    Log.i("ERROR", "error read file")
                                }
                            }
                            val pkg = EndReadPkg()
                            sendCmd(pkg.buf)
                            cmdState = 3
                        } else {
                            val pkg =
                                ReadContentPkg(currentPkg)
                            sendCmd(pkg.buf)
                            currentPkg++
                        }

                    } else if (cmdState == 3) {
                        fileData = null
                        currentPkg = 0
                        cmdState = 0
                        dataScope.launch {
                            fileProgressChannel.send(
                                FileProgress(
                                    currentFileName,
                                    100,
                                    result == 0
                                )
                            )
                            fileChannel.send(result)
                        }
                    }
                } else if (cmdState == 4) {
                    val deviceInfo = DeviceInfo(temp)
                    dataScope.launch {
                        deviceChannel.send(deviceInfo)
                    }
                }


                val tempBytes: ByteArray? =
                    if (i + 8 + len == bytes.size) null else bytes.copyOfRange(
                        i + 8 + len,
                        bytes.size
                    )

                return handleDataPool(tempBytes)
            }
        }

        return bytesLeft
    }

    private fun sendCmd(bs: ByteArray) {
        myBleDataManager?.sendCmd(bs)
    }


    fun initWorker(context: Context, bluetoothDevice: BluetoothDevice?) {
        myBleDataManager = BleDataManager(context)
        myBleDataManager!!.setNotifyListener(comeData)
        bluetoothDevice?.let {
            myBleDataManager!!.connect(it)
                .useAutoConnect(true)
                .timeout(10000)
                .retry(15, 100)
                .done {

                    var json = JSONObject()
                    json.put("type", "DEVICE-ONLINE")
                    MainActivity.eventSink?.success( json.toString() )
                    MainActivity.isConnected = true
                    dataScope.launch {
                        connectChannel.send("yes")
                    }

                }
                .enqueue()
        }
    }

    suspend fun waitConnect() {
        connectChannel.receive()
    }

    suspend fun getFile(name: String): Int {
        mutex.withLock {

            this.currentFileName = name
            cmdState = 1
            val pkg = StartReadPkg(name)
            sendCmd(pkg.buf)
            return fileChannel.receive()
        }
    }

    suspend fun getDeviceInfo(): DeviceInfo {
        mutex.withLock {
            cmdState = 4
            val pkg = GetDeviceInfoPkg()
            sendCmd(pkg.buf)
            return deviceChannel.receive()
        }
    }

    fun disconnect(){
        var json = JSONObject()
        json.put("type", "DEVICE-OFFLINE")
        MainActivity.eventSink?.success( json.toString() )
        MainActivity.isConnected = false
        myBleDataManager?.disconnect()?.enqueue();
    }

}