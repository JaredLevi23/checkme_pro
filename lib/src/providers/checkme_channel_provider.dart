import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';

import 'package:checkme_pro_develop/src/models/models.dart';

class CheckmeChannelProvider with ChangeNotifier{

  static const platform = MethodChannel("checkmepro.connection");
  static const EventChannel eventChannel = EventChannel('checkmepro.listener');
  final _devicePrefs = DevicePreferences();

  bool _isSync = false;
  bool _isConnected = false;
  bool _btEnabled = false;

  List<DeviceModel> devices = [];
  DeviceModel? currentDevice;

  // Data List
  List<TemperatureModel> temperaturesList = [];
  List<Spo2Model> spo2sList = [];
  List<SlmModel> slmList = [];
  List<UserModel> userList = [];
  List<PedModel> pedList = [];
  List<DlcModel> dlcList = [];

  late EcgModel currentEcg;
  late DlcModel currentDlc;
  late SlmModel currentSlm;
  List<EcgModel> ecgList = [];

  EcgModel? currentSyncEcg;
  DlcModel? currentSyncDlc;
  SlmModel? currentSyncSlm;
  Map<String, EcgDetailsModel> ecgDetailsList = {};
  Map<String, EcgDetailsModel> dlcDetailsList = {};
  Map<String, SlmDetailsModel > slmDetailsList = {};

  bool get isSync => _isSync;

  set isSync(bool isSync) {
    _isSync = isSync;
    notifyListeners();
  }

  bool get isConnected => _isConnected;

  set isConnected(bool isConnected) {
    _isConnected = isConnected;
    notifyListeners();
  }

  bool get btEnabled => _btEnabled;

  set btEnabled(bool btEnabled) {
    _btEnabled = btEnabled;
    notifyListeners();
  }

  Future<String> checkmeIsConnected ()async{
      try{

        if( _devicePrefs.uuid != '' ){
          await startScan();
          await Future.delayed( const Duration( seconds: 3 ) );
          await stopScan();
          await connectToDevice(uuid: _devicePrefs.uuid);
        }

        final bool result = await platform.invokeMethod('checkmepro/isConnected');
        isConnected = result;
        
        return "IsConnected: $result";
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> btIsEnabled ()async{
      try{
        final bool result = await platform.invokeMethod('checkmepro/btEnabled');
        btEnabled = result;
        return "IsBTEnabled: $result";
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginGetInfo ()async{
      try{
        final String result = await platform.invokeMethod('checkmepro/beginGetInfo');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> getInfoCheckmePRO ()async{
      try{
        final String result = await platform.invokeMethod('checkmepro/getInfoCheckmePRO');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginSyncTime ()async{
      try{
        final String result = await platform.invokeMethod('checkmepro/beginSyncTime');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> startScan ()async{
      try{
        devices = [];
        final String result = await platform.invokeMethod('checkmepro/startScan');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> stopScan ()async{
      try{
        final String result = await platform.invokeMethod('checkmepro/stopScan');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> connectToDevice ({ required String uuid, String? deviceName } )async{
      try{
          final String result = await platform.invokeMethod('checkmepro/connectTo', { "uuid": uuid });
          _devicePrefs.uuid = uuid;

          if( _devicePrefs.deviceName == '' ){
            _devicePrefs.deviceName = deviceName ?? '';
          }

          return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> cancelConnect ()async{
      try{
          final bool result = await platform.invokeMethod('checkmepro/disconnect');
          return 'STATE: $result';
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileList ({ required int indexTypeFile, int? userId = 0 } )async{
      try{
        
        final String result = await platform.invokeMethod(
          'checkmepro/beginReadFileList', 
          { 'indexTypeFile': indexTypeFile, 'idUser': userId }
        );

        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }finally{
        cleanData(indexTypeFile: indexTypeFile);
      }
  }

  // get measurement details
  Future<void> getMeasurementDetails( { required String dtcDate, required String detail } )async{
    try{
      final res = await platform.invokeMethod('checkmepro/beginReadFileListDetailsECG', { 'id': dtcDate, 'detail': detail});
      
      if( res == "isSync"){
        isSync = true;
      }

    }catch( err ){
      log( '$err' );
    }
  }

  // events 

  void startEvents(){
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }
  
  void _onEvent(Object? event) {
    //log( 'EVENT_FLUTTER: $event' );

    // event
    final headerType = TypeFileModel.fromRawJson( event.toString() );

    // DISCOVER DEVICES
    if( headerType.type == 'DiscoverDevices' ){
      final deviceModel = DeviceModel.fromRawJson( event.toString() );
      if( !devices.contains( deviceModel )){
        devices.add( deviceModel );
      }
    }

    // SYNC TIME
    if( headerType.type == "SyncTime: OK" ){
      
    }

    // BT STATE
    if( headerType.type == "BluetoothState"){
      final btState = BtStateModel.fromRawJson( event.toString() );
      if( btState.value == "POWEREDON" ){
        btEnabled = true;
      }else{
        btEnabled = false;
        isConnected = false;
        isSync = false;
        currentSyncDlc = null;
        currentSyncEcg = null;
      }
    }

    // Connected
    if( headerType.type == "ONLINE: ON" ){
      isConnected = true;
      
    }

    // Disconnected
    if( headerType.type == "ONLINE: OFF" ){
      isConnected = false;
    }

    // DLC
    if( headerType.type == 'DLC'){
      final dlcTemp = DlcModel.fromRawJson( event.toString());
      dlcList.add( dlcTemp );
    }

    // TM
    if( headerType.type == 'TM') {
      final tempTm = TemperatureModel.fromRawJson( event.toString());
      if(!temperaturesList.contains( tempTm )){
        temperaturesList.add(tempTm);
      }
    }

    //SPO2 
    if( headerType.type == 'SPO2'){
      final spo2Temp = Spo2Model.fromRawJson( event.toString() );
      if( !spo2sList.contains( spo2Temp ) ){
        spo2sList.add(spo2Temp);
      }
    }

    // SLM 
    if( headerType.type == 'SLM'){
      final smlTemp = SlmModel.fromRawJson( event.toString() );
      if( !slmList.contains( smlTemp ) ){
        slmList.add( smlTemp );
      }
    }

    // PED
    if( headerType.type == 'PED'){
      final pedTemp = PedModel.fromRawJson( event.toString() );
      if( !pedList.contains( pedTemp ) ){
        pedList.add( pedTemp );
      }
    }

    // ECG 
    if( headerType.type == 'ECG' ){
      final ecgTemp = EcgModel.fromRawJson( event.toString() );
      if( !ecgList.contains( ecgTemp ) ){
        ecgList.add( ecgTemp );
      }
    }

    // USERS
    if( headerType.type == 'USER' ){
      final userTemp = UserModel.fromRawJson( event.toString() );
      if( !userList.contains( userTemp )){
        userList.add( userTemp );
      }
    }

    // DETAILS_EKG (ECG/DLC)
    if( headerType.type == 'DETAILS_EKG'){
      try{
        final detailECGTemp = EcgDetailsModel.fromRawJson( event.toString() );

        if( currentSyncEcg != null && !ecgDetailsList.containsKey( currentSyncEcg!.dtcDate ) && currentSyncDlc == null){
          ecgDetailsList.addAll( {currentSyncEcg!.dtcDate : detailECGTemp} );
        }else if(currentSyncDlc != null && !dlcDetailsList.containsKey( currentSyncDlc!.dtcDate ) && currentSyncEcg == null ){
          dlcDetailsList.addAll( {currentSyncDlc!.dtcDate : detailECGTemp } );
        }

      }catch( err ){
        log('$err');
      } finally{
        currentSyncEcg = null;
        currentSyncDlc = null;
        isSync = false;
      }
    }

    // Details Sleep Monitor
    if( headerType.type == 'DETAILS_SLM' ){
      try{
        final smlDetailTemp = SlmDetailsModel.fromRawJson( event.toString() );
        if( currentSyncSlm != null && !slmDetailsList.containsKey( currentSyncSlm!.dtcDate)){
          slmDetailsList.addAll({ currentSyncSlm!.dtcDate : smlDetailTemp });
        }

      }catch( err ){
        log( '$err' );
      }finally{
        currentSyncSlm = null;
        isSync = false;
      }
    }

    notifyListeners();

  }

  void _onError(Object error) {
    log('$error');
   notifyListeners();
  }

  // reset data 
  cleanData( { required int indexTypeFile} ){
    switch( indexTypeFile ){
      case 1:
        userList = [];
      break;
      case 2:
        dlcList = [];
      break;
      case 3:
        ecgList = [];
      break;
      case 4:
        spo2sList = [];
      break;
      case 5:
      break;
      case 6:
      break;
      case 7:
        temperaturesList = [];
      break;
      case 8:
        slmList = [];
      break;
      case 9:
        pedList = [];
      break;
      case 10:
      break;
      case 11:
      break;
      case 12:
      break;
    }
    notifyListeners();
  }
}