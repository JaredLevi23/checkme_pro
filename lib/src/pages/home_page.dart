import 'package:checkme_pro_develop/src/models/device_model.dart';
import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:provider/provider.dart'
;
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
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

    checkPermissions();
    
    super.initState();
  }

  void checkPermissions()async{
    final checkProvider = Provider.of<CheckmeChannelProvider>(context, listen: false);
    checkProvider.startEvents();
    checkProvider.btIsEnabled();
    checkProvider.checkmeIsConnected();
  }

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkme PRO'),
        actions: const [
          ConnectionIndicator(),
          // IconButton(
          //   icon: const Icon(Icons.sync),
          //   onPressed: ()async{
          //     final res = await checkmeProvider.beginGetInfo();
          //     log( res );
          //   }, 
          // ),
        ],
      ),
      

      drawer: const CustomDrawer(),

      body: !checkmeProvider.btEnabled 
      ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text('Please turn on bluetooth', 
              textAlign: TextAlign.center, 
              style: TextStyle( fontSize: 20),
            )
          )
        ],
      )
      : checkmeProvider.isConnected 
      ? ListView(
        children: [

          CheckmeOption(
            titleOption: 'Get Info',
            iconData: Icons.info,
            onPressed: ()async{
              final res = await checkmeProvider.getInfoCheckmePRO();
              log( res );
              Navigator.pushNamed(context, 'checkme/info', arguments: { 'info': res } );
            },
          ),

          CheckmeOption(
            titleOption: 'Sync Time',
            iconData: Icons.sync_alt,
            onPressed: () async {
              final res = await checkmeProvider.beginSyncTime();

              showDialog(context: context, builder: ( _){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  content: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                    ),
                    child: Center(child: Text( res )),
                  ),
                );
              });
            },
          ),

          CheckmeOption(
            titleOption: 'Read User List',
            iconData: Icons.group,
            onPressed: ()async {
              if( checkmeProvider.userList.isEmpty ){
                final res = await checkmeProvider.beginReadFileList( indexTypeFile: 1 );
                log( res );
              }
              Navigator.pushNamed(context, 'checkme/users');
            },
          ),

          CheckmeOption(
            titleOption: 'Daily Check',
            iconData: Icons.how_to_reg_rounded,
            onPressed: ()async{
              if( checkmeProvider.userList.isEmpty ){
                final res = await checkmeProvider.beginReadFileList( indexTypeFile: 1 );
                log( res );
              }
              Navigator.pushNamed(context,'checkme/selectUser', arguments: {'title':'DLC'});
            },
          ),

          CheckmeOption(
            titleOption: 'Ecg Recorder',
            iconData: Icons.monitor_heart,
            onPressed: ()async{
              if( checkmeProvider.ecgList.isEmpty ){
                final res = await checkmeProvider.beginReadFileList( indexTypeFile:  3 );
                log( res );
              }
              Navigator.pushNamed(context, 'checkme/ecg');
            },
          ),

          CheckmeOption(
            titleOption: 'Pulse Oxymeter',
            iconData: Icons.invert_colors_on_sharp,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileList( indexTypeFile: 4 );
              log( res );
              Navigator.pushNamed(context, 'checkme/spo2');
            },
          ),

          CheckmeOption(
            titleOption: 'Thermometer',
            iconData: Icons.thermostat,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileList( indexTypeFile: 7 );
              Navigator.pushNamed(context, 'checkme/temp');
              log( res );
            },
          ),


           CheckmeOption(
            titleOption: 'Sleep Monitor',
            iconData: Icons.bed,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileList( indexTypeFile: 8 );
              log( res );
              Navigator.pushNamed(context, 'checkme/sml');
            },
          ),

          CheckmeOption(
            titleOption: 'Pedometer',
            iconData: Icons.directions_walk_outlined,
            onPressed: ()async{
              if( checkmeProvider.userList.isEmpty ){
                final res = await checkmeProvider.beginReadFileList( indexTypeFile: 1 );
                log( res );
              }
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
      ): Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text('Please connect your device', 
              textAlign: TextAlign.center, 
              style: TextStyle( fontSize: 20),
            )
          )
        ],
      )
    );
  }

}
