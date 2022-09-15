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
  List<SmlModel> smlList = [];
  List<UserModel> userList = [];

  late EcgModel currentEcg;
  EcgModel? currentSyncEcg;
  List<EcgModel> ecgList = [];
  Map<String, EcgDetailsModel> ecgDetailsList = {};

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

  Future<String> beginReadFileList ({ required int indexTypeFile } )async{
      try{
        
        final String result = await platform.invokeMethod(
          'checkmepro/beginReadFileList', 
          { 'indexTypeFile': indexTypeFile, 'idUser': 2 }
        );

        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }finally{
        cleanData(indexTypeFile: indexTypeFile);
      }
  }

  Future<void> detailsECG( { required EcgModel model } )async{
    try{
      final res = await platform.invokeMethod('checkmepro/beginReadFileListDetailsECG', { 'id': model.dtcDate });
      
      if( res == "isSync"){
        isSync = true;
      }

    }catch( err ){
      log( '$err' );
    }
  }

  cleanData( { required int indexTypeFile} ){
    switch( indexTypeFile ){
      case 1:
        userList = [];
      break;
      case 2:
        
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

  // events 

  void startEvents(){
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }
  
  void _onEvent(Object? event) {

    //log( 'EVENT_FLUTTER: $event' );

    if( event.toString() == "SyncTime: OK" ){
      // Todo: mostrar mensaje
    }

    if( event.toString() == "ONLINE: ON" ){
      isConnected = true;
      
    }

    if( event.toString() == "ONLINE: OFF" ){
      isConnected = false;
    }

    // TM
    if( event.toString().contains('tempValue')) {
      final tempTm = TemperatureModel.fromRawJson( event.toString());
      if(!temperaturesList.contains( tempTm )){
        temperaturesList.add(tempTm);
      }
    }

    //SPO2 
    if( event.toString().contains('spo2Value')){
      final spo2Temp = Spo2Model.fromRawJson( event.toString() );
      if( !spo2sList.contains( spo2Temp ) ){
        spo2sList.add(spo2Temp);
      }
    }

    // SLM 
    if( event.toString().contains('averageOx')){
      final smlTemp = SmlModel.fromRawJson( event.toString() );
      if( !smlList.contains( smlTemp ) ){
        smlList.add( smlTemp );
      }
    }

    // ECG 
    if( event.toString().contains('ECG') ){
      final ecgTemp = EcgModel.fromRawJson( event.toString() );
      if( !ecgList.contains( ecgTemp ) ){
        ecgList.add( ecgTemp );
      }
    }

    // USERS
    if( event.toString().contains('USERS') ){
      final userTemp = UserModel.fromRawJson( event.toString() );
      if( !userList.contains( userTemp )){
        userList.add( userTemp );
      }
    }    

    // DETAILS_EKG
    if( event.toString().contains('DETAILS_EKG') ){
      try{
        final detailECGTemp = EcgDetailsModel.fromRawJson( event.toString() );

        if( currentSyncEcg != null && !ecgDetailsList.containsKey( currentSyncEcg!.dtcDate )){
          ecgDetailsList.addAll( {currentSyncEcg!.dtcDate : detailECGTemp} );
        }

      }catch( err ){
        log('$err');
      } finally{
        currentSyncEcg = null;
        isSync = false;
      }
    }

    notifyListeners();

  }

  void _onError(Object error) {
    log('$error');
   notifyListeners();
  }
}