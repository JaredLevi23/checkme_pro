package com.example.check_developer_main

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import kotlin.math.round
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
import kotlin.math.roundToInt

class MainActivity: FlutterActivity(), BleScanManager.Scan{

    companion object {
        var loading = true
        val bleWorker = BleDataWorker()
        val scan = BleScanManager()
        val dataScope = CoroutineScope(Dispatchers.IO)
        val uiScope = CoroutineScope(Dispatchers.Main)
        var eventSink: EventChannel.EventSink? = null
        var isConnected : Boolean = false
    }

    private val userChannel = Channel<Int>(Channel.CONFLATED)
    private val listenerCheckmePro = "checkmepro.listener";
    private val connectioncheckmePro  = "checkmepro.connection";
    lateinit var userInfo: UserInfo
    private val bleList: MutableList<BleBean> = ArrayList()

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
                    isConnected = false
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
                    GlobalScope.launch( Dispatchers.Main ) {
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
                                GlobalScope.launch( Dispatchers.Main ) {
                                    bleWorker.getFile( fileName )
                                }
                                readFile( fileName, "" );
                                result.success( true );
                            }else{
                                result.success(false );
                            }
                        }else{
                            // LEER CON USUARIO
                            val idUser = args["idUser"]
                            if( fileName != null){
                                readFile( fileName, "$idUser" );
                                result.success( true );
                            }else{
                                result.success(false );
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
                        GlobalScope.launch( Dispatchers.Main ) {
                            getFileDetails( timeString,type )
                        }
                        result.success(true );
                    }else{
                        result.success(false  );
                    }
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
            try {
                userInfo = UserInfo(this)
                var tIndex = 1
                var userList: MutableList<JSONObject>  = ArrayList()
                var userJson = JSONObject()
                for (user in userInfo.user) {
                    for (f in userFileName) {
                        bleWorker.getFile(user.id + f )
                        tIndex++
                    }
                    //userAdapter.addUser(user)
                    var json = JSONObject()
                    try {
                        //json.put("type", "USER");
                        json.put("userId", user.id.toInt() );
                        json.put("gender", "${user.sex}");
                        json.put("birthDay", "${user.birthday}");
                        json.put("height", "${user.height}");
                        json.put("iconID", "${user.ico}");
                        json.put("userName", "${user.name}");
                        json.put("weight", "${user.weight}");
                        json.put("age", "${user.pacemakeflag}");

                        userList.add( json )
                    }catch ( e: JSONException){
                        println("ERROR USER JSON: $e")
                    }
                }

                userJson.put("type", "USERLIST")
                userJson.put( "userList", userList )
                eventSink?.success( userJson.toString() );

                for (f in userFileName) {
                    bleWorker.getFile( f )
                    tIndex++
                }
            }catch (e: Exception){
                println("ERROR: $e")
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
                var dlcJsonList : MutableList< JSONObject > = ArrayList()

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
                            json.put("pIndex"       , dlcArray.pi.toDouble()/10 );
                            json.put("bpValue"      , dlcArray.pr)
                            json.put("prFlag"       , dlcArray.prFlag)
                            json.put("dtcDate"      , dlcArray.timeString);
                            json.put("userId"       , if(userId == "") 0 else userId.toInt() );
                            json.put("haveVoice"    , dlcArray.voice );

                            dlcJsonList.add( json )

                        }catch (e: JSONException){
                            println("ERROR JSON DLC: $e");
                        }
                    }

                var dlcJson = JSONObject()
                dlcJson.put("type", "DLCLIST")
                dlcJson.put( "dlcList", dlcJsonList )
                eventSink?.success( dlcJson.toString() );

            }
            "spc.dat"->{}
            "hrv.dat"->{}
            "ecg.dat"->{
                var ecgInfo = EcgInfo( fileValue )
                var ecgJsonList : MutableList< JSONObject > = ArrayList()

                for ( ecgArray in ecgInfo.ecg ){
                    var json = JSONObject()
                    try {
                        //json.put("date"     ,"${ecgArray.date}");
                        json.put("type"         , "ECG");
                        json.put("enPassKind"   , ecgArray.face);
                        json.put("dtcDate"      , ecgArray.timeString)
                        json.put("userId"       , if(userId == "") 0 else userId.toInt() );
                        json.put("haveVoice"    , ecgArray.voice );
                        json.put("enLeadKind"   , ecgArray.way );
                        ecgJsonList.add( json )

                    }catch (e: JSONException){
                        println("ERROR JSON DLC: $e");
                    }
                }

                var ecgJson = JSONObject()
                ecgJson.put("type", "ECGLIST")
                ecgJson.put( "ecgList", ecgJsonList)
                eventSink?.success( ecgJson.toString() );
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
                        json.put("userId"       , if(userId == "") 0 else userId.toInt() )

                        eventSink?.success( json.toString() );
                    }catch (e: JSONException){
                        println("ERROR JSON DLC: $e");
                    }
                }

            }
            "tmp.dat"->{
                var tmpInfo = TmpInfo( fileValue )
                var tmpJsonList : MutableList< JSONObject > = ArrayList()

                for ( tmpArray in tmpInfo.Tmp ){
                    var json = JSONObject()
                    try {
                        //json.put("date"        , tmpArray.date)
                        json.put("type", "TM")
                        json.put("enPassKind"  , tmpArray.face )
                        json.put("dtcDate"     , tmpArray.timeString )
                        json.put("tempValue"   , tmpArray.tmp)
                        json.put("measureMode" , tmpArray.way )
                        json.put("userId"      , if(userId == "") 0 else userId.toInt() )

                        tmpJsonList.add( json )

                    }catch (e: JSONException){
                        println("ERROR JSON DLC: $e");
                    }
                }

                var tmpJson = JSONObject()
                tmpJson.put("type", "TMPLISTS")
                tmpJson.put( "tmpList", tmpJsonList )

                eventSink?.success( tmpJson.toString() );

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
                var slmJsonList : MutableList<JSONObject> = ArrayList()

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
                        json.put("userId"       , if(userId == "") 0 else userId.toInt() )

                        slmJsonList.add( json )

                    }catch (e: JSONException){
                        println("ERROR SLM: $e")
                    }
                }
                var slmJson = JSONObject()
                slmJson.put("type", "SLMLIST")
                slmJson.put( "slmList", slmJsonList )
                eventSink?.success( slmJson.toString() )
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
                        json.put("userId"   , if(userId == "") 0 else userId.toInt() )
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
            if( isConnected  ){
                bleWorker.getFile( timeString )
                file = File( Constant.getPathX( timeString ) )
            }
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

                json.put("type"     , "DETAILS_EKG" )
                json.put("dtcDate"  , timeString)
                json.put("hrValue"  , info.hr )
                json.put("stValue"  , info.st )
                json.put("qrsValue" , info.qrs )
                json.put("qtValue"  , info.qt )
                json.put("qtcValue" , info.qtc )
                json.put("pvcsValue", info.pvcs )
                json.put("timeLength", (info.waveSize.toDouble() / 500).roundToInt() )

                json.put("hrSize"   , info.hrSize )
                json.put("total"    , info.total )
                json.put("waveSize" , info.waveSize )
                json.put("bytes"    , info.bytes.toList() )

                var waveList : MutableList< Int > = ArrayList()
                var waveHrList: MutableList< Int > = ArrayList()

                for ( k in info.hrList ){
                    waveHrList.add( k )
                }

                for ( j in info.waveList ){
                    waveList.add( j )
                }

                json.put("arrEcg" , waveList )
                json.put("arrHR"   , waveHrList )

                eventSink?.success( json.toString() )


            }catch ( e: JSONException ){
                println("ERROR DETAILS : $e")
            }
        } else if ( type == "SLM" ){
            val info = SlmInfo( fileValue )
            var json = JSONObject()

            try {
                json.put( "type", "DETAILS_SLM" )
                json.put( "dtcDate", timeString )


                var oxList : MutableList< Byte > = ArrayList()
                var hrList: MutableList< Byte > = ArrayList()

                for ( k in info.arrOX ){
                    oxList.add( k )
                    println("ENTRE EN OX")
                }

                for ( j in info.arrHR ){
                    hrList.add( j )
                    println("ENTRE EN HR")
                }

                json.put( "arrOxValue", oxList.toString() )
                json.put( "arrPrValue", hrList.toString() )

                eventSink?.success( json.toString() )
            }catch ( e: JSONException ){
                println("ERROR SLM DETAILS: $e")
            }
        }
    }

    private fun onScanItemClick(bluetoothDevice: BluetoothDevice?) {
        scan.stop()
        bleWorker.initWorker(this, bluetoothDevice)

        dataScope.launch {
            val a = withTimeoutOrNull(10000) {
                bleWorker.waitConnect()
            }

            a?.let {
                val b = withTimeoutOrNull(10000) {
                    bleWorker.getFile("usr.dat")
                }
                b?.let {
                    userChannel.send(1)
                }
            }
        }
        uiScope.launch {
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
