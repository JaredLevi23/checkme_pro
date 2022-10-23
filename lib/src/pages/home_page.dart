import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:checkme_pro_develop/src/models/models.dart';
import 'package:checkme_pro_develop/src/providers/providers.dart';
import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState(){

    final checkProvider = Provider.of<CheckmeChannelProvider>(context, listen: false);

    final devicePrefs = DevicePreferences();
    final uuid = devicePrefs.uuid;

    if( uuid != '' ){
      final modelTemp = DeviceModel(
        name: devicePrefs.deviceName, 
        type: 'btDevice', 
        uuid: uuid, 
        rssi: '', 
        advName: ''
      );
      checkProvider.currentDevice = modelTemp;
    }

    initBtServices();
    super.initState();
  }

  void initBtServices()async{
    final checkProvider = Provider.of<CheckmeChannelProvider>(context, listen: false);
    checkProvider.startEvents();
  }

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);    
    final btProvider = Provider.of<BluetoothProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: const [
          ConnectionIndicator(),
        ],
        title: Center(child: SvgPicture.asset('assets/svg/hoyrpm_logo.svg')),
      ),

      drawer: const CustomDrawer(),

      body: !btProvider.isEnabled
      ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Please turn on bluetooth', 
              textAlign: TextAlign.center, 
              style: TextStyle( fontSize: 20),
            )
          ),
          SizedBox(
            width: 300,
            child: CustomButton(
              title: 'Continue Offline',
              onPressed: (){
                checkmeProvider.offlineMode = true;
              }, 
              backgroundColor: Colors.red.shade300,
            ),
          )
        ],
      )
      : checkmeProvider.offlineMode || checkmeProvider.isConnected
      ? SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [

              // read user list 
              CheckmeOption(
                title: 'Read User List',
                assetSVG: 'assets/svg/person.svg',
                onPressed: ()async {
                  if( checkmeProvider.isConnected ){
                    await checkmeProvider.beginReadFileList( indexTypeFile: 1 );
                  }
                  await checkmeProvider.loadData(tableName: 'Users');
                  Navigator.pushNamed(context, 'checkme/users');
                },
              ),

              // daily check 
              CheckmeOption(
                title: 'Daily Check',
                assetSVG: 'assets/svg/morning.svg',
                onPressed: ()async{
                  if( checkmeProvider.isConnected ){
                    await checkmeProvider.beginReadFileList( indexTypeFile: 1 );
                  }
                  await checkmeProvider.loadData(tableName: 'Users');
                  Navigator.pushNamed(context,'checkme/selectUser', arguments: {'title':'DLC'});
                },
              ),
        
              // Ecg Recorder
              CheckmeOption(
                title: 'Ecg Recorder',
                assetSVG: 'assets/svg/blood_preasure.svg',
                onPressed: ()async{
                  if( checkmeProvider.isConnected ){
                    final res = await checkmeProvider.beginReadFileList( indexTypeFile:  3 );
                    log( 'ECG VALUE: $res' );
                  }
                  await checkmeProvider.loadData(tableName: 'Ecg');
                  Navigator.pushNamed(context, 'checkme/ecg');
                },
              ),
        
              // Pulse Oxymeter 
              CheckmeOption(
                title: 'Pulse Oxymeter',
                assetSVG: 'assets/svg/oxygenation.svg',
                onPressed: ()async{
                  if( checkmeProvider.isConnected ){
                    await checkmeProvider.beginReadFileList( indexTypeFile: 4 );
                  }
                  await checkmeProvider.loadData(tableName: 'Spo');
                  Navigator.pushNamed(context, 'checkme/spo2');
                },
              ),

              // Thermometer 
              CheckmeOption(
                title: 'Thermometer',
                assetSVG: 'assets/svg/temperature.svg',
                onPressed: ()async{
                  if( checkmeProvider.isConnected){
                    await checkmeProvider.beginReadFileList( indexTypeFile: 7 );
                  }
                  await checkmeProvider.loadData(tableName: 'Tmp');
                  Navigator.pushNamed(context, 'checkme/temp');
                },
              ),
        
              // Sleep Monitor 
              CheckmeOption(
                title: 'Sleep Monitor',
                assetSVG: 'assets/svg/night.svg',
                onPressed: ()async{
                  if( checkmeProvider.isConnected ){
                    await checkmeProvider.beginReadFileList( indexTypeFile: 8 );
                  }
                  await checkmeProvider.loadData(tableName: 'Slm');
                  Navigator.pushNamed(context, 'checkme/sml');
                },
              ),

              // Pedometer 
              CheckmeOption(
                title: 'Pedometer',
                assetSVG: 'assets/svg/spirometer.svg',
                onPressed: ()async{
                  if( checkmeProvider.isConnected ){
                    await checkmeProvider.beginReadFileList( indexTypeFile: 1 );
                  }
                  await checkmeProvider.loadData(tableName: 'Users');
                  Navigator.pushNamed(context,'checkme/selectUser', arguments: {'title':'PED'});
                },
              ),
        
              // CheckmeOption(
              //   title: 'X User List',
              //   assetSVG: 'assets/svg/blood_preasure.svg',
              //   onPressed: ()async{
              //     final res = await checkmeProvider.beginReadFileList( indexTypeFile: 10 );
              //     log( res );
              //   },
              // ),
        
              // CheckmeOption(
              //   title: 'Blood Preassure',
              //   assetSVG: 'assets/svg/blood_preasure.svg',
              //   onPressed: ()async{
              //     final res = await checkmeProvider.beginReadFileList( indexTypeFile: 5 );
              //     log( res );
              //   },
              // ),
        
              // CheckmeOption(
              //   title: 'Blood Glucose',
              //   assetSVG: 'assets/svg/blood_preasure.svg',
              //   onPressed: ()async{
              //     final res = await checkmeProvider.beginReadFileList( indexTypeFile: 6 );
              //     log( res );
              //   },
              // ),
        
              // CheckmeOption(
              //   title: 'Sync Time',
              //   assetSVG: 'assets/svg/blood_preasure.svg',
              //   onPressed: () async {
        
              //     await checkmeProvider.beginSyncTime();
        
              //     showDialog(context: context, builder: ( _){
              //       return AlertDialog(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15)
              //         ),
              //         content: Container(
              //           width: 200,
              //           height: 200,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(15),
              //             color: Colors.white
              //           ),
              //           child: const Center(child: Text( 'Sync Time' )),
              //         ),
              //       );
              //     });
              //   },
              // ),
        
            ],
          ),
        ),
      ): Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          const Center(
            child: Text('Please connect your device', 
              textAlign: TextAlign.center, 
              style: TextStyle( fontSize: 20),
            )
          ),
          SizedBox(
            width: 300,
            child: CustomButton(
              title: 'Search Device',
              onPressed: ()async{
                await checkmeProvider.startScan();
                showDialog(context: context, builder: ( _) {
                  return const DialogSelector();
                });
              }, 
              backgroundColor: Colors.blue,
            ),
          ),
          SizedBox(
            width: 300,
            child: CustomButton(
              title: 'Continue Offline',
              onPressed: (){
                checkmeProvider.offlineMode = true;
              }, 
              backgroundColor: Colors.red.shade300,
            ),
          )
        ],
      )
    );
  }
}
