import 'dart:developer';
import 'dart:io';

import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import '../utils/utils_date.dart';
import '../widgets/widgets.dart';


class DlcResultsPage extends StatelessWidget {
  const DlcResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DLC Results'),
        actions: [ 
          TextButton(onPressed: (){
            log( '${checkmeProvider.dlcList.length}' );
          }, child: const Text('AQUI'))
         ],
      ),

      body: ListView.builder(
        itemCount: checkmeProvider.dlcList.length,
        itemBuilder: (_, index){

          final dlc = checkmeProvider.dlcList[index];

          return Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.cyan,
                  child: Icon( Icons.monitor_heart_outlined, color: Colors.white, size: 40,)
                ),
                trailing: const Icon( Icons.arrow_right ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HR: ${ dlc.hrValue } ', textAlign: TextAlign.center,),
                    Text('SPO2: ${ dlc.spo2Value }%', textAlign: TextAlign.center,),
                  ],
                ),
                subtitle: Text( Platform.isIOS ? '${ getMeasurementDateTime( measurementDate: dlc.dtcDate ) }' : dlc.dtcDate ),
                onTap: ()async {
                  checkmeProvider.currentDlc = dlc;

                    if( !checkmeProvider.dlcDetailsList.containsKey( dlc.dtcDate ) ){

                      if(checkmeProvider.isConnected){

                        if( !checkmeProvider.isSync ){
                          //checkmeProvider.currentEcg.isSync = true;
                          checkmeProvider.currentSyncDlc ??= dlc;
                          await checkmeProvider.getMeasurementDetails( dtcDate: dlc.dtcDate, detail: 'DLC' );
                        }

                      }else{
                        showDialog(context: context, builder: (_){
                          return const CustomAlertDialog();
                        });
                        return;
                      }
                    }
                    Platform.isIOS 
                    ? Navigator.pushNamed(context, 'checkme/dlc/details')
                    : Navigator.pushNamed(context, 'checkme/dlc-android/details');
                },
              ),
              const Divider()
            ],
          );
        }
      ),
    );
  }
}