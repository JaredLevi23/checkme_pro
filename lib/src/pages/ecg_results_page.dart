import 'package:checkme_pro_develop/src/models/ecg_details_model.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

class EcgResultsPage extends StatelessWidget {
  const EcgResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de ECG'),
        actions: const [
          ConnectionIndicator()
        ],
      ),
      body: ListView.builder(
        itemCount: checkmeProvider.ecgList.length,
        itemBuilder: (_, index){

          final ecg = checkmeProvider.ecgList[ index ];
          EcgDetailsModel? checkmeDetails = checkmeProvider.ecgDetailsList[ ecg.dtcDate ];

          return Card(
            child: ListTile(
              title: Row(
                children: [
                  const Icon( Icons.favorite, color: Colors.red ),
                  const SizedBox( width:  5,),
                  Text( 'HR: ${checkmeDetails?.hrValue ?? 'Unknown'}' ),
                  if( ecg.isSync == true )
                    //const Spacer(),
                    const SizedBox(
                    child: LinearProgressIndicator(),
                    width: 30,
                    height: 5,
                  ),
                ],
              ),
              subtitle: Text( '${getMeasurementDateTime( measurementDate: ecg.dtcDate )}' ),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                child: Text( '${index + 1}' ),
              ),
              onTap: ()async {

                checkmeProvider.currentEcg = ecg;

                if( !checkmeProvider.ecgDetailsList.containsKey( ecg.dtcDate ) ){

                  if(checkmeProvider.isConnected){

                    if( !checkmeProvider.isSync ){
                      //checkmeProvider.currentEcg.isSync = true;
                      checkmeProvider.currentSyncEcg ??= ecg;
                      await checkmeProvider.getMeasurementDetails( dtcDate: ecg.dtcDate, detail: 'ECG' );
                    }

                  }else{

                    showDialog(context: context, builder: (_){
                      return AlertDialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: Container(
                          width: 200,
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.bluetooth_audio ),
                                Text('Verifica la conexion del dispositivo', textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                    return;
                  }
                }

                Navigator.pushNamed(context, 'checkme/ecg/details');
              },
            ),
          );
        }
      )
    );
  }
}