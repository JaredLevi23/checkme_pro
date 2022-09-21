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
                subtitle: Text( '${ getMeasurementDateTime( measurementDate: dlc.dtcDate ) }' ),
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

                    Navigator.pushNamed(context, 'checkme/dlc/details');
                },
              ),
              const Divider()
            ],
          );
        }
      ),
    );
  }

   Widget _information({ required String units, required String value, required IconData icondata, Color? iconColor }){
    return Row(
      children: [

        Icon( icondata , size: 40, color: iconColor ?? Colors.black ,),
        const SizedBox( width: 8, ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( value , style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal  )),
            Text( units , style: const TextStyle( fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic))
          ], 
        ) 
      ],
    );
  }
}