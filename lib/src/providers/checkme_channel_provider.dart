import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';

import 'package:checkme_pro_develop/src/models/models.dart';

class CheckmeChannelProvider with ChangeNotifier{

  static const platform = MethodChannel("checkmepro.connection");
  static const EventChannel eventChannel = EventChannel('checkmepro.listener');

  bool _isSync = false;
  bool _isConnected = false;

  // Data List
  List<TemperatureModel> temperaturesList = [];
  List<Spo2Model> spo2sList = [];
  List<SlmModel> smlList = [];
  List<UserModel> userList = [];
  List<PedModel> pedList = [];
  List<DlcModel> dlcList = [];

  late EcgModel currentEcg;
  late DlcModel currentDlc;
  List<EcgModel> ecgList = [];

  EcgModel? currentSyncEcg;
  DlcModel? currentSyncDlc;
  Map<String, EcgDetailsModel> ecgDetailsList = {};
  Map<String, EcgDetailsModel> dlcDetailsList = {};

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

  Future<String> checkmeIsConnected ()async{
      try{
        final bool result = await platform.invokeMethod('checkmepro/isConnected');
        isConnected = result;
        return "IsConnected: $result";
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
    final headerType = TypeFileModel.fromRawJson( event.toString() );

    if( headerType.type == 'DLC'){
      final dlcTemp = DlcModel.fromRawJson( event.toString());
      dlcList.add( dlcTemp );
    }

    if( headerType.type == "SyncTime: OK" ){
      
    }

    // Connected
    if( headerType.type == "ONLINE: ON" ){
      isConnected = true;
      
    }

    // Disconnected
    if( headerType.type == "ONLINE: OFF" ){
      isConnected = false;
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
      if( !smlList.contains( smlTemp ) ){
        smlList.add( smlTemp );
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

    notifyListeners();

  }

  void _onError(Object error) {
    log('$error');
   notifyListeners();
  }

  // reset data 
  cleanData( { required int indexTypeFile} ){
    log('LIMPIANDO DATOS');
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
        smlList = [];
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