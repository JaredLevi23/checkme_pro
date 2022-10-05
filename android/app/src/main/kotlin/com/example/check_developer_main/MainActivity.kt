package com.example.check_developer_main

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import com.example.check_developer_main.bean.BleBean
import com.example.check_developer_main.ble.format.*
import com.example.check_developer_main.ble.manager.BleScanManager
import com.example.check_developer_main.ble.worker.BleDataWorker
import com.example.check_developer_main.utils.Constant
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import org.json.JSONException
import org.json.JSONObject
import java.io.File

class MainActivity: FlutterActivity(), BleScanManager.Scan{

    companion object {
        var loading = true
        val bleWorker = BleDataWorker()
        val scan = BleScanManager()
        val dataScope = CoroutineScope(Dispatchers.IO)
        val uiScope = CoroutineScope(Dispatchers.Main)
        var eventSink: EventChannel.EventSink? = null
    }

    private val userChannel = Channel<Int>(Channel.CONFLATED)
    private val listenerCheckmePro = "checkmepro.listener";
    private val connectioncheckmePro  = "checkmepro.connection";
    lateinit var userInfo: UserInfo
    private val bleList: MutableList<BleBean> = ArrayList()

    private val receiver = object: BroadcastReceiver(){
        override fun onReceive(context: Context?, intent: Intent?) {
            when(intent?.getIntExtra( BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR )){
                BluetoothAdapter.STATE_ON ->{
                    println("CONECTADO")
                }
                BluetoothAdapter.STATE_OFF ->{
                    println("DESCONECTADO")
                }
            }
        }
    }

    private var userFileName = arrayOf(
        "dlc.dat",
        "spc.dat",
        "hrv.dat",
        "ecg.dat",
        "oxi.dat",
        "tmp.dat",
        "bpi.dat",
        "slm.dat",
        "ped.dat",
        "nibp.dat"
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel( flutterEngine.dartExecutor.binaryMessenger, connectioncheckmePro ).setMethodCallHandler{
            call, result ->

            when (call.method) {

                "checkmepro/startScan" -> {
                    // MARK: StartScan
                    bleList.clear()
                    initScan();
                    result.success("SCAN START!");
                }
                "checkmepro/stopScan" -> {
                    // MARK: StopScan
                    scan.stop();
                    result.success("STOP SCAN!");

                }
                "checkmepro/connectTo" -> {
                    // MARK: Connect to
                    scan.stop();
                    var args = call.arguments as HashMap<String, String>
                    var filter: BleBean = bleList.single { d -> d.bluetoothDevice.address == args["uuid"] }
                    onScanItemClick( filter.bluetoothDevice );
                    result.success(true );
                }
                "checkmepro/disconnect" -> {
                    // MARK: status<
                    bleWorker.disconnect();
                    var json = JSONObject()
                    json.put("type", "DEVICE-OFFLINE")
                    eventSink?.success( json.toString() )
                    result.success("DISCONNECTED");
                }
                "checkmepro/isConnected" -> {

                }
                "checkmepro/beginGetInfo" -> {
                    // MARK: begin get info device
                }
                "checkmepro/getInfoCheckmePRO" -> {
                    // MARK: set info
                    dataScope.launch {
                        var info = bleWorker.getDeviceInfo()
                        var json = info.json
                        var deviceInfo = JSONObject()
                        try {
                            deviceInfo.put("model", json["Model"])
                            deviceInfo.put("spcPVer", json["SPCPVer"])
                            deviceInfo.put("software", json["SoftwareVer"])
                            deviceInfo.put("application", json["Application"])
                            deviceInfo.put("theCurLanguage", json["CurLanguage"])
                            deviceInfo.put("sn", json["SN"])
                            deviceInfo.put("region", json["Region"])
                            deviceInfo.put("hardware", json["HardwareVer"])
                            deviceInfo.put("fileVer", json["FileVer"])
                            deviceInfo.put("branchCode", json["BranchCode"])
                            deviceInfo.put("language", json["LanguageVer"])
                            result.success( deviceInfo.toString() )

                        }catch ( e: JSONException){
                            println("ERROR INFO: $e")
                            result.success("NO-INFO")
                        }
                    }
                }
                "checkmepro/beginSyncTime" -> {
                    // MARK: sync Time
                }
                "checkmepro/beginReadFileList" -> {
                    // MARK: begin read File
                    /// @param int indexTypeFile
                    var args = call.arguments as HashMap<String, Int>
                    val indexTypeFile:Int? = args["indexTypeFile"]
                    if( indexTypeFile != null ){
                        val fileName = getFileType( indexTypeFile )
                        if( indexTypeFile == 1 || indexTypeFile == 3 || indexTypeFile == 4 || indexTypeFile == 7 || indexTypeFile == 8){
                            // LEER SIN USUARIO
                            if( fileName != null){
                                readFile( fileName, "" );
                                result.success("isSync");
                            }else{
                                result.success(true );
                            }
                        }else{
                            // LEER CON USUARIO
                            val idUser = args["idUser"]
                            if( fileName != null){
                                readFile( fileName, "$idUser" );
                                result.success("isSync");
                            }else{
                                result.success(true);
                            }
                        }
                    }else{
                        result.success("ARCHIVO NO ENCONTRADO   ");
                    }
                }
                "checkmepro/beginReadFileListDetailsECG" -> {
                    // MARK: begin read details ECG
                    /// @params id as Datetime
                    var args = call.arguments as HashMap<String, String>
                    val timeString = args["id"]
                    val type = args["detail"]

                    if( timeString != null && type != null ){
                        //GlobalScope.launch ( Dispatchers.Main ){
                        GlobalScope.launch( Dispatchers.Main ) {
                            getFileDetails( timeString,type )
                        }
                        //}
                    }

                    result.success("isSync");
                }
                else -> {
                    // not implemented
                }
            }

        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, listenerCheckmePro ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, events: EventChannel.EventSink?) {
                eventSink = events;
            }
            override fun onCancel(args: Any?) {
                eventSink = null;
            }
        })
    }

    private fun initVar() {
        Constant.initVar(this)
    }


    private fun initScan(){
        initVar();
        scan.initScan( this);
        scan.setCallBack( this );
    }

    @SuppressLint("MissingPermission")
    override fun scanReturn(name: String, bluetoothDevice: BluetoothDevice) {
        if (!(name.contains("Checkme"))) return;
        var z: Int = 0;
        for (ble in bleList) run {
            if (ble.name == bluetoothDevice.name) {
                z = 1
            }
        }
        if (z == 0) {
            bleList.add(BleBean(name, bluetoothDevice))
            // SEND DEVICE
            val json = JSONObject()
            try {
                json.put("type", "DiscoverDevices");
                json.put("advName", bluetoothDevice.name);
                json.put("name", bluetoothDevice.name);
                json.put("UUID", "${bluetoothDevice.address}");
                json.put("RSSI", "33");
                eventSink?.success(json.toString());
            }catch (e: JSONException){
                println("Error JSON: $e")
            }
        }
    }

    private suspend fun readUser() {
        userChannel.receive()
        val userTemp = File(Constant.getPathX("usr.dat")).readBytes()
        userTemp.apply {
            userInfo = UserInfo(this)
            var tIndex = 1
            for (user in userInfo.user) {
                for (f in userFileName) {
                    bleWorker.getFile(user.id + f)
                    tIndex++
                }
                //userAdapter.addUser(user)
                var json = JSONObject()
                try {
                    json.put("type", "USER");
                    json.put("userID", "${user.id}");
                    json.put("gender", "${user.sex}");
                    json.put("birthday", "${user.birthday}");
                    json.put("height", "${user.height}");
                    json.put("iconID", "${user.ico}");
                    json.put("userName", "${user.name}");
                    json.put("weight", "${user.weight}");
                    json.put("age", "${user.pacemakeflag}");

                    eventSink?.success( json.toString() );
                }catch ( e: JSONException){
                    println("ERROR USER JSON: $e")
                }
            }

            for (f in userFileName) {
                bleWorker.getFile( f )
                tIndex++
            }

            delay(300)
            loading = false
        }
    }

    private fun readFile( fileName: String, userId: String = "" ){
        val fileTemp = File(Constant.getPathX( userId + fileName ));

        if( !fileTemp.exists() ){
            //TODO: AGREGAR MENSAJE QUE INDICA QUE NO EXISTE EL ARCHIVO
            return;
        }

        val fileValue = fileTemp.readBytes()

        when( fileName ){
            "dlc.dat"->{
                val dlcInfo = DlcInfo( fileValue );
                for ( dlcArray in dlcInfo.dlc ){
                        var json = JSONObject()
                        try {
                            //json.put("date"         , dlcArray.date);
                            json.put("type"         ,"DLC");
                            json.put("bpFlag"       , dlcArray.bpiFace);
                            json.put("hrResult"     , dlcArray.eface);
                            json.put("hrValue"      , dlcArray.hr);
                            json.put("spo2Result"   , dlcArray.oface)
                            json.put("spo2Value"    , dlcArray.oxy);
                            json.put("pIndex"       , dlcArray.pi);
                            json.put("bpValue"      , dlcArray.pr)
                            json.put("prFlag"       , dlcArray.prFlag)
                            json.put("dtcDate"      , dlcArray.timeString);
                            json.put("userID"       , userId);
                            json.put("haveVoice"    , dlcArray.voice != 0 );

                            eventSink?.success( json.toString() );
                        }catch (e: JSONException){
                            println("ERROR JSON DLC: $e");
                        }
                    }

            }
            "spc.dat"->{

            }
            "hrv.dat"->{

            }
            "ecg.dat"->{
                var ecgInfo = EcgInfo( fileValue )
                for ( ecgArray in ecgInfo.ecg ){
                    var json = JSONObject()
                    try {
                        //json.put("date"     ,"${ecgArray.date}");
                        json.put("type"         , "ECG");
                        json.put("enPassKind"   , ecgArray.face);
                        json.put("dtcDate"      , ecgArray.timeString)
                        json.put("userID"       , userId );
                        json.put("haveVoice"    , ecgArray.voice != 0 );
                        json.put("enLeadKind"   , ecgArray.way);

                        eventSink?.success( json.toString() );
                    }catch (e: JSONException){
                        println("ERROR JSON DLC: $e");
                    }
                }
            }
            "oxi.dat"->{

                var oxyInfo = OxyInfo( fileValue )
                for ( oxyArray in oxyInfo.Oxy ){
                    var json = JSONObject()
                    try {
                        //json.put("date"         , oxyArray.date)
                        json.put("type"         , "SPO2")
                        json.put("dtcDate"      , oxyArray.timeString)
                        json.put("enPassKind"   , oxyArray.face)
                        json.put("pIndex"       , oxyArray.pi)
                        json.put("prValue"      , oxyArray.pr)
                        json.put("spo2Value"    , oxyArray.oxy)
                        json.put("way"          , oxyArray.way)
                        json.put("userID"       , userId )

                        eventSink?.success( json.toString() );
                    }catch (e: JSONException){
                        println("ERROR JSON DLC: $e");
                    }
                }

            }
            "tmp.dat"->{
                var tmpInfo = TmpInfo( fileValue )
                for ( tmpArray in tmpInfo.Tmp ){
                    var json = JSONObject()
                    try {
                        //json.put("date"        , tmpArray.date)
                        json.put("type", "TM")
                        json.put("enPassKind"  , tmpArray.face )
                        json.put("dtcDate"     , tmpArray.timeString )
                        json.put("tempValue"   , tmpArray.tmp)
                        json.put("measureMode" , tmpArray.way )
                        json.put("userID"      , userId )

                        eventSink?.success( json.toString() );
                    }catch (e: JSONException){
                        println("ERROR JSON DLC: $e");
                    }
                }

            }
            "bpi.dat"->{
                var bpInfo = BpInfo( fileValue )
                for ( bpArray in bpInfo.Bp ){
                    var json = JSONObject()
                    // TODO: AUN NO TENEMOS ESTE DISPOSITIVO
                    try {
                        json.put("type"         , "BP-ANDROID")
                        json.put("date"         , bpArray.date)
                        json.put("dia"          , bpArray.dia)
                        json.put("pr"           , bpArray.pr)
                        json.put("sys"          , bpArray.sys)
                        json.put("timeString"   , bpArray.timeString)

                        eventSink?.success( json.toString() );
                    }catch (e: JSONException){
                        println("ERROR JSON DLC: $e");
                    }
                }
            }
            "slm.dat"->{
                var slmInfo = SlpInfo( fileValue )

                for ( smlArray in slmInfo.Slp ){
                    var json = JSONObject()
                    try {
                        //json.put("date"         , smlArray.date)
                        json.put("type"         , "SLM")
                        json.put("enPassKind"   , smlArray.face)
                        json.put("lowOxNumber"  , smlArray.lowCount)
                        json.put("lowOxTime"    , smlArray.lowTime)
                        json.put("averageOx"   , smlArray.meanO2)
                        json.put("lowestOx"     , smlArray.minO2)
                        json.put("totalTime"    , smlArray.time)
                        json.put("dtcDate"      , smlArray.timeString)
                        json.put("userID"       , userId )

                        eventSink?.success( json.toString() )

                    }catch (e: JSONException){
                        println("ERROR SLM: $e")
                    }
                }
            }
            "ped.dat"->{
                var pedInfo = PedInfo( fileValue )
                for ( pedArray in pedInfo.Ped ){
                    var json = JSONObject()
                    try {
                        json.put("type"     , "PED")
                        json.put("calorie"  , pedArray.cal)
                        json.put("distance" , pedArray.dis)
                        json.put("dtcDate"  , pedArray.timeString)
                        json.put("fat"      , pedArray.fat)
                        json.put("speed"    , pedArray.speed)
                        json.put("steps"    , pedArray.step)
                        json.put("totalTime", pedArray.time)
                        json.put("userID", userId )
                        //json.put("date"         , pedArray.date)

                        eventSink?.success( json.toString() );
                    }catch (e: JSONException){
                        println("ERROR JSON DLC: $e");
                    }
                }
            }
            "nibp.dat"->{

            }
        }
    }

    private suspend fun getFileDetails( timeString :String, type: String ){
        var file = File( Constant.getPathX( timeString ) )

        if( !file.exists() ){
            bleWorker.getFile( timeString )
            file = File( Constant.getPathX( timeString ) )
        }

        val fileValue = file.readBytes();

        if( fileValue.isEmpty() ){
            println("NO HAY VALORES GETFILEDETAILS")
            return;
        }

        if( type == "ECG" || type == "DLC"){
            val info = EcgWaveInfo( fileValue )
            val json = JSONObject()
            try {

                json.put("type"     , "DETAILS_EKG_ANDROID" )
                json.put("bytes"    , info.bytes.indices )
                json.put("hr"       , info.hr )
                json.put("hrList"   , info.hrList )
                json.put("hrSize"   , info.hrSize )
                json.put("pvcs"     , info.pvcs )
                json.put("qrs"      , info.qrs )
                json.put("qt"       , info.qt )
                json.put("qtc"      , info.qtc )
                json.put("st"       , info.st )
                json.put("total"    , info.total )
                json.put("waveList" , info.waveList )
                json.put("waveSize" , info.waveSize )

                val waveSize: Int = (info.waveIntSize/1000) - 1
                var waveViewList: MutableList< Int > = mutableListOf()

                for ( k in 0 until waveSize ){
                    var value = info.getWave( k )
                    for ( k in value ){
                        //println( "VALUE: $k" )
                        waveViewList.add( k )
                    }
                }

                json.put("waveViewList", waveViewList )

                eventSink?.success( json.toString() )


            }catch ( e: JSONException ){
                println("ERROR DETAILS : $e")
            }
        } else if ( type == "OXY" ){
            val info = OxyWaveInfo( fileValue )
            val json = JSONObject()
            try {

            }catch ( e: JSONException ){
                println("ERROR DETAILS : $e")
            }
        }
    }

    private fun onScanItemClick(bluetoothDevice: BluetoothDevice?) {
        scan.stop()
        bleWorker.initWorker(this, bluetoothDevice)

        dataScope.launch {
            val a = withTimeoutOrNull(10000) {
                bleWorker.waitConnect()
                println("WAIT CONNECT!!!")
            }

            a?.let {
                val b = withTimeoutOrNull(10000) {
                    bleWorker.getFile("usr.dat")
                    println("GET FILE USER.DAT EN ONSCANITEMCLICK")
                }
                b?.let {
                    userChannel.send(1)
                }
            }
        }
        uiScope.launch {
            println("LAUNCH UISCOPE")
            readUser()
        }
    }

    private fun getFileType( type:Int ): String {
        when( type ){
            1 ->{ return "usr.dat"; }
            2 ->{ return "dlc.dat"; }
            3 ->{ return "ecg.dat"; }
            4 ->{ return "oxi.dat"; }
            5 ->{}
            6 ->{}
            7 ->{ return "tmp.dat"; }
            8 ->{ return "slm.dat"; }
            9 ->{ return "ped.dat"; }
        }
        return "";
    }

}
