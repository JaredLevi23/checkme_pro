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
  void initState() {
    final checkProvider = Provider.of<CheckmeChannelProvider>(context, listen: false);
    checkProvider.startEvents();
    checkProvider.checkmeIsConnected();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkme PRO'),
        actions: [
          Icon(
            Icons.circle,
            color: checkmeProvider.isConnected ? Colors.greenAccent : Colors.red,
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: ()async{
              final res = await checkmeProvider.beginGetInfo();
              log( res );
            }, 
          ),
        ],
      ),
      

      drawer: const CustomDrawer(),

      body: ListView(
        children: [

          CheckmeOption(
            titleOption: 'Ver informacion',
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
            titleOption: 'User List',
            iconData: Icons.group,
            onPressed: ()async {
              final res = await checkmeProvider.beginReadFileListUser();
              log( res );
              Navigator.pushNamed(context, 'checkme/users');
            },
          ),

          CheckmeOption(
            titleOption: 'X User List',
            iconData: Icons.group_rounded,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileListXUser();
              log( res );
            },
          ),

          CheckmeOption(
            titleOption: 'Temperature',
            iconData: Icons.thermostat,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileListTM();
              Navigator.pushNamed(context, 'checkme/temp');
              log( res );
            },
          ),

          CheckmeOption(
            titleOption: 'SPO2',
            iconData: Icons.air,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileListSPO();
              log( res );
              Navigator.pushNamed(context, 'checkme/spo2');
            },
          ),

           CheckmeOption(
            titleOption: 'Sleep Monitor',
            iconData: Icons.bed,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileListSM();
              log( res );
              Navigator.pushNamed(context, 'checkme/sml');
            },
          ),

          CheckmeOption(
            titleOption: 'ECG',
            iconData: Icons.monitor_heart,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileListECG();
              log( res );
              Navigator.pushNamed(context, 'checkme/ecg');
            },
          ),

          CheckmeOption(
            titleOption: 'PET',
            iconData: Icons.air,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileListPED();
              log( res );
            },
          ),

          CheckmeOption(
            titleOption: 'DLC',
            iconData: Icons.monitor_heart,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileListDLC();
              log( res );
            },
          ),

          CheckmeOption(
            titleOption: 'BP',
            iconData: Icons.air,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileListBP();
              log( res );
            },
          ),

          CheckmeOption(
            titleOption: 'BG',
            iconData: Icons.air,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileListBG();
              log( res );
            },
          ),

          CheckmeOption(
            titleOption: 'SPC',
            iconData: Icons.air,
            onPressed: ()async{
              final res = await checkmeProvider.beginReadFileListSPC();
              log( res );
            },
          ),

        ],
      )
    );
  }

}
