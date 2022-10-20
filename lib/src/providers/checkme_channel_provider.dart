import 'package:checkme_pro_develop/src/db/db_provider.dart';
import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';

import 'package:checkme_pro_develop/src/models/models.dart';

class CheckmeChannelProvider with ChangeNotifier{

  static const MethodChannel platform     = MethodChannel("checkmepro.connection");
  static const EventChannel  eventChannel = EventChannel('checkmepro.listener');

  final _devicePrefs = DevicePreferences();

  bool _isSync = false;
  bool _isConnected = false;
  bool _offlineMode = false;

  List<DeviceModel> devices = [];
  DeviceModel? currentDevice;

  // Data List
  DeviceInformationModel? informationModel;
  List<TemperatureModel> tmpList = [];
  List<Spo2Model> spo2sList = [];
  List<SlmModel> slmList = [];
  List<UserModel> userList = [];
  List<PedModel> pedList = [];
  List<DlcModel> dlcList = [];
  List<EcgModel> ecgList = [];

  late EcgModel currentEcg;
  late DlcModel currentDlc;
  late SlmModel currentSlm;
  late UserModel currentUser;

  EcgModel? currentSyncEcg;
  DlcModel? currentSyncDlc;
  SlmModel? currentSyncSlm;

  EcgDetailsModel? currentEcgDetailsModel;
  SlmDetailsModel? currentSlmDetailsModel;

  // SET/GET
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
  bool get offlineMode => _offlineMode;
  set offlineMode(bool offlineMode) {
    _offlineMode = offlineMode;
    notifyListeners();
  }
  
  // CONNECTIONS
  Future< bool >   autoConnection ()async{
      try{
        if( _devicePrefs.uuid != '' ){
          await startScan();
          await Future.delayed( const Duration( seconds: 6 ) );
          await stopScan();
          await connectToDevice(uuid: _devicePrefs.uuid);
        }
        final bool result = await platform.invokeMethod('checkmepro/isConnected');
        return result;
      }catch( err ){
        log( '$err' );
        return false;
      }
  }
  Future< void >   startScan ()async{
      try{
        devices = [];
        await platform.invokeMethod('checkmepro/startScan');
      }catch( err ){
        log( '$err' );
      }
  }
  Future< String > stopScan ()async{
      try{
        final String result = await platform.invokeMethod('checkmepro/stopScan');
        return result;
      }catch( err ){
        log( '$err' );
        return "$err";
      
      }
  }
  Future< bool >   connectToDevice ({ required String uuid, String? deviceName } )async{
    bool result = false;
      try{
          result = await platform.invokeMethod('checkmepro/connectTo', { "uuid": uuid });
          // bluetooth device info saved 
          _devicePrefs.uuid = uuid;
          _devicePrefs.deviceName = deviceName ?? '';
          return result;
      }catch( err ){
        //log( '$err' );
        return result;
      }
  }
  
  Future< void >   cancelConnect ()async{
      try{
          await platform.invokeMethod('checkmepro/disconnect');
      }catch( err ){
        //log( '$err' );
      }
  }

// INFORMATION MANAGE 
  Future<void> getInfoCheckmePRO ()async{
      try{
        final String result = await platform.invokeMethod('checkmepro/getInfoCheckmePRO');
        informationModel = DeviceInformationModel.fromRawJson( result );
        notifyListeners();
      }catch( err ){
        log( '$err' );
      }
  }
  Future<void> beginGetInfo ()async{
      try{
        await platform.invokeMethod('checkmepro/beginGetInfo');
      }catch( err ){
        log( '$err' );
      }
  }
  Future<void> beginSyncTime ()async{
      try{
        await platform.invokeMethod('checkmepro/beginSyncTime');
      }catch( err ){
        log( '$err' );
      }
  }
  Future<bool> beginReadFileList ({ required int indexTypeFile, int? userId } )async{
      try{
        // cleanData(indexTypeFile: indexTypeFile);
        final res = await platform.invokeMethod(
          'checkmepro/beginReadFileList',
          userId != null 
          ? { 'indexTypeFile': indexTypeFile, 'idUser': userId }
          : { 'indexTypeFile': indexTypeFile }
        );

        return res;
      }catch( err ){
        log( 'ERROR READ FILE: $err' );
        return false;
      }
  }
  Future<bool> getMeasurementDetails( { required String dtcDate, required String detail } )async{
    try{
      final bool res = await platform.invokeMethod('checkmepro/beginReadFileListDetailsECG', 
      { 'id': dtcDate, 'detail': detail});
      
      if( res ){
        isSync = true;
      }
      return res;
    }catch( err ){
      log( '$err' );
      return false;
    }
  }

  // events 
  void startEvents(){
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }
  void _onEvent(Object? event) async{
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

    // Connected
    if( headerType.type == "DEVICE-ONLINE" ){
      isConnected = true;
    }

    // Disconnected
    if( headerType.type == "DEVICE-OFFLINE" ){
      isConnected = false;
    }

    if( headerType.type == "GETALL" ){
      isSync = true;
      await Future.delayed( const Duration( milliseconds: 2000 ));
      beginReadFileList(indexTypeFile: 1);
      await Future.delayed( const Duration( milliseconds: 2000 ));
      beginReadFileList(indexTypeFile: 3);
      await Future.delayed( const Duration( milliseconds: 2000 ));
      beginReadFileList(indexTypeFile: 4);
      await Future.delayed( const Duration( milliseconds: 2000 ));
      beginReadFileList(indexTypeFile: 7);
      await Future.delayed( const Duration( milliseconds: 2000 ));
      beginReadFileList(indexTypeFile: 8);
      isSync = false;
    }

    // DLCLIST
    if( headerType.type == 'DLCLIST'){
      final dlcTemp = DlcListModel.fromRawJson( event.toString());
      for (DlcModel dlc in dlcTemp.dlcList) {
        final search = await DBProvider.db.getValue( tableName: 'Dlc', dtcDate: dlc.dtcDate );
        if( search.isEmpty ){
          await DBProvider.db.newValue('Dlc', dlc );
          dlcList.insert(0, dlc );
        }
      }

    }

    // TMLIST
    if( headerType.type == 'TMPLISTS') {
      final tempTm = TmpListModel.fromRawJson( event.toString());
      for (TemperatureModel tmp in tempTm.tmpList ) {
        final search = await DBProvider.db.getValue( tableName: 'Tmp', dtcDate: tmp.dtcDate );
        if( search.isEmpty ){
          await DBProvider.db.newValue('Tmp', tmp);
          tmpList.insert(0, tmp );
        }
      }

    }

    //SPO2 
    if( headerType.type == 'SPO2'){
      final spo2Temp = Spo2Model.fromRawJson( event.toString() );
      final search = await DBProvider.db.getValue( tableName: 'Spo', dtcDate: spo2Temp.dtcDate );
      if( search.isEmpty ){
        await DBProvider.db.newValue('Spo', spo2Temp );
        spo2sList.insert(0, spo2Temp );
      }
    }

    // SLMLIST
    if( headerType.type == 'SLMLIST'){
      final slmTemp = SlmListModel.fromRawJson( event.toString() );
      for (SlmModel slm in slmTemp.slmList) {  
        final search = await DBProvider.db.getValue( tableName: 'Slm', dtcDate: slm.dtcDate );
        if( search.isEmpty ){
          await DBProvider.db.newValue('Slm', slm );
          slmList.insert(0, slm);
        }
      }
    }

    // PED
    if( headerType.type == 'PED'){
      final pedTemp = PedModel.fromRawJson( event.toString() );
      final search = await DBProvider.db.getValue( tableName: 'Ped', dtcDate: pedTemp.dtcDate );
      if( search.isEmpty ){
        await DBProvider.db.newValue('Ped', pedTemp );
        pedList.insert(0, pedTemp) ;
      }
    }

    // ECGLIST
    if( headerType.type == 'ECGLIST' ){
      final ecgTemp = EcgListModel.fromRawJson( event.toString() );

      for ( EcgModel ecg in ecgTemp.ecgList ) {
        final search = await DBProvider.db.getValue( tableName: 'Ecg', dtcDate: ecg.dtcDate );
        if( search.isEmpty ){
          await DBProvider.db.newValue('Ecg', ecg );
          ecgList.insert(0, ecg );
        }
      }
    }

    // USERLIST
    if( headerType.type == 'USERLIST' ){
      final userListTemp = UserListModel.fromRawJson( event.toString() );

      for (UserModel user in userListTemp.userList) {
        final search = await DBProvider.db.getValue( tableName: 'Users', dtcDate: '${user.userId}' );
        if( search.isEmpty ){
          await DBProvider.db.newValue('Users', user );
        }else{
          final updateUser = user..id=search[0].id;
          await DBProvider.db.updateUserById( updateUser );
        }
        //userList.add( user );
      }
    }

    // DETAILS_EKG (ECG/DLC)
    if( headerType.type == 'DETAILS_EKG'){
      try{
        
        final detailECGTemp = EcgDetailsModel.fromRawJson( event.toString() );
        await Future.delayed( const Duration( milliseconds: 1500 ));
        final search = await DBProvider.db.getValue(tableName: 'EcgDetails', dtcDate: detailECGTemp.dtcDate );

        if( search.isEmpty ){
          await DBProvider.db.newValue('EcgDetails', detailECGTemp );
          currentEcgDetailsModel = detailECGTemp;
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
        final slmDetailTemp = SlmDetailsModel.fromRawJson( event.toString() );

        final search = await DBProvider.db.getValue(tableName: 'SlmDetails', dtcDate: slmDetailTemp.dtcDate );

        if( search.isEmpty ){
          await DBProvider.db.newValue('SlmDetails', slmDetailTemp );
          if( currentSlm.dtcDate == slmDetailTemp.dtcDate){
            currentSlmDetailsModel = slmDetailTemp;
          }else{
            final search = await DBProvider.db.getValue(tableName: 'SlmDetails', dtcDate: slmDetailTemp.dtcDate );
            if( search.isEmpty ){
              final res = await getMeasurementDetails(dtcDate:  currentSlm.dtcDate, detail: 'SLM');
              if( !res ){
                log('NO SE LOGRO :(');
              }
            }else{
              currentSlmDetailsModel = search[0];
            }
          }
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

  Future<void> loadData( { required String tableName } )async{
    final data = await DBProvider.db.getAllDb( tableName );

    if( data.isNotEmpty ){

      if( tableName == 'Users' ){  
        final res = data as List<UserModel>;
        userList = [ ...res ];
      }

      if( tableName == 'Ecg' ){
        final res = data as List<EcgModel>;
        ecgList = res.reversed.toList();;
      }

      if( tableName == 'Dlc' ){
        final res = data as List<DlcModel>;
        dlcList = res.reversed.toList();;
      }

      if( tableName == 'Tmp' ){
        final res = data as List<TemperatureModel>;
        tmpList = res.reversed.toList();
      }

      if( tableName == 'Spo' ){
        final res = data as List<Spo2Model>;
        spo2sList = res.reversed.toList() ;
      }

      if( tableName == 'Ped' ){
        final res = data as List<PedModel>;
        pedList = res.reversed.toList();
      }

      if( tableName == 'Slm' ){
        final res = data as List<SlmModel>;
        slmList = res.reversed.toList();;
      }

      notifyListeners();
    }
  }

  Future<void> loadDataById( { required String tableName, required int userId } )async{
    dlcList = [];
    pedList = [];
    final data = await DBProvider.db.getValueByUserId( tableName: tableName, userId: userId );

    if( data.isNotEmpty ){
      if( tableName == 'Dlc' ){
        final res = data as List<DlcModel>;
        dlcList = [ ...res ];
      }

      if( tableName == 'Ped' ){
        final res = data as List<PedModel>;
        pedList = [ ...res ];
      }
      notifyListeners();
    }
  }
  
}