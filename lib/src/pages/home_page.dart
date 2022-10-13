import 'dart:developer';

import 'package:checkme_pro_develop/src/db/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:checkme_pro_develop/src/models/device_model.dart';
import 'package:checkme_pro_develop/src/providers/bluetooht_provider.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
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
        actions: [
          const ConnectionIndicator(),
          //checkmeProvider.isSync ? const SizedBox( width: 10, height: 10, ) : const Center(child: SizedBox( width: 20, height: 20, child: CircularProgressIndicator(  ))),
          checkmeProvider.isSync ? const Center(child: Icon( Icons.bluetooth_audio_sharp, )) : const Center(child: Icon( Icons.bluetooth, color: Colors.grey, )),
          const SizedBox( width: 15,),
        ],
        title: const Text('HOYRPM', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1) , fontWeight: FontWeight.bold),),
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
            child: SyncButton(
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
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(203, 232, 250, 1)
            ),
            child: Column(
              children: [
                // CheckmeOption(
                //   titleOption: 'Get Info',
                //   iconData: Icons.info,
                //   onPressed: ()async{
                //     if( checkmeProvider.informationModel == null ){
                //       await checkmeProvider.getInfoCheckmePRO();
                //     }
                //     Navigator.pushNamed(context, 'checkme/info');
                //   },
                // ),
        
                // CheckmeOption(
                //   titleOption: 'Sync Time',
                //   iconData: Icons.sync_alt,
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
        
                CheckmeOption(
                  titleOption: 'Read User List',
                  iconData: Icons.group,
                  onPressed: ()async {
                    if( checkmeProvider.isConnected ){
                      await checkmeProvider.beginReadFileList( indexTypeFile: 1 );
                    }
                    await checkmeProvider.loadData(tableName: 'Users');
                    Navigator.pushNamed(context, 'checkme/users');
                  },
                ),
        
                CheckmeOption(
                  titleOption: 'Daily Check',
                  iconData: Icons.how_to_reg_rounded,
                  onPressed: ()async{
                    if( checkmeProvider.isConnected ){
                      await checkmeProvider.beginReadFileList( indexTypeFile: 1 );
                    }
                    await checkmeProvider.loadData(tableName: 'Users');
                    Navigator.pushNamed(context,'checkme/selectUser', arguments: {'title':'DLC'});
                  },
                ),
        
                CheckmeOption(
                  titleOption: 'Ecg Recorder',
                  iconData: Icons.monitor_heart,
                  onPressed: ()async{

                    if( checkmeProvider.isConnected ){
                      final res = await checkmeProvider.beginReadFileList( indexTypeFile:  3 );
                      log( 'ECG VALUE: $res' );
                    }

                    await checkmeProvider.loadData(tableName: 'Ecg');
                    Navigator.pushNamed(context, 'checkme/ecg');
                  },
                ),
        
                CheckmeOption(
                  titleOption: 'Pulse Oxymeter',
                  iconData: Icons.invert_colors_on_sharp,
                  onPressed: ()async{
                    if( checkmeProvider.isConnected ){
                      await checkmeProvider.beginReadFileList( indexTypeFile: 4 );
                    }
                    await checkmeProvider.loadData(tableName: 'Spo');
                    Navigator.pushNamed(context, 'checkme/spo2');
                  },
                ),
        
                CheckmeOption(
                  titleOption: 'Thermometer',
                  iconData: Icons.thermostat,
                  onPressed: ()async{
                    if( checkmeProvider.isConnected){
                      await checkmeProvider.beginReadFileList( indexTypeFile: 7 );
                    }
                    await checkmeProvider.loadData(tableName: 'Tmp');
                    Navigator.pushNamed(context, 'checkme/temp');
                  },
                ),
        
        
                 CheckmeOption(
                  titleOption: 'Sleep Monitor',
                  iconData: Icons.bed,
                  onPressed: ()async{
                    if( checkmeProvider.isConnected ){
                      await checkmeProvider.beginReadFileList( indexTypeFile: 8 );
                    }
                    await checkmeProvider.loadData(tableName: 'Slm');
                    Navigator.pushNamed(context, 'checkme/sml');
                  },
                ),
        
                CheckmeOption(
                  titleOption: 'Pedometer',
                  iconData: Icons.directions_walk_outlined,
                  onPressed: ()async{
                    if( checkmeProvider.isConnected ){
                      await checkmeProvider.beginReadFileList( indexTypeFile: 1 );
                    }
                    await checkmeProvider.loadData(tableName: 'Users');
                    Navigator.pushNamed(context,'checkme/selectUser', arguments: {'title':'PED'});
                  },
                ),
        
                // CheckmeOption(
                //   titleOption: 'X User List',
                //   iconData: Icons.group_rounded,
                //   onPressed: ()async{
                //     final res = await checkmeProvider.beginReadFileList( indexTypeFile: 10 );
                //     log( res );
                //   },
                // ),
        
                // CheckmeOption(
                //   titleOption: 'Blood Preassure',
                //   iconData: Icons.air,
                //   onPressed: ()async{
                //     final res = await checkmeProvider.beginReadFileList( indexTypeFile: 5 );
                //     log( res );
                //   },
                // ),
        
                // CheckmeOption(
                //   titleOption: 'Blood Glucose',
                //   iconData: Icons.air,
                //   onPressed: ()async{
                //     final res = await checkmeProvider.beginReadFileList( indexTypeFile: 6 );
                //     log( res );
                //   },
                // ),
        
              ],
            ),
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
            child: SyncButton(
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
            child: SyncButton(
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
