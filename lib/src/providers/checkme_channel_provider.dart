import 'package:checkme_pro_develop/src/models/user_model.dart';
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

  Future<String> beginReadFileListUser ()async{
      try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListUser');
        userList = [];
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileListXUser ()async{
      try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListXUser');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileListDLC()async{
    try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListDLC');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileListECG()async{
    try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListECG');
        ecgList = [];
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileListSPO()async{
    try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListSPO');
        spo2sList = [];
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileListBG()async{
    try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListBG');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileListBP()async{
    try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListBP');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileListTM()async{
    try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListTM');
        temperaturesList = [];
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileListSM()async{
    try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListSM');
        smlList = [];
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileListPED()async{
    try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListPED');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<String> beginReadFileListSPC()async{
    try{
        final String result = await platform.invokeMethod('checkmepro/beginReadFileListSPC');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      }
  }

  Future<void> detailsECG( { required int index } )async{
    try{
      final res = await platform.invokeMethod('checkmepro/beginReadFileListDetailsECG', { 'index': index });
      
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
      final detailECGTemp = EcgDetailsModel.fromRawJson( event.toString() );
      
      if( !ecgDetailsList.containsKey( currentEcg.dtcDate )){
        ecgDetailsList.addAll( {currentEcg.dtcDate : detailECGTemp} );
        isSync = false;
        notifyListeners();
      }

    }

    notifyListeners();
  }

  void _onError(Object error) {
    log('$error');
   notifyListeners();
  }


}
