import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/db/db_provider.dart';
import 'package:checkme_pro_develop/src/models/ecg_details_model.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import '../widgets/widgets.dart';

class EcgResultsPage extends StatelessWidget {
  const EcgResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('ECG Results', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1))),
        actions: const [
          ConnectionIndicator()
        ],
      ),
      body: ListView.builder(
        itemCount: checkmeProvider.ecgList.length,
        itemBuilder: (_, index){

          final ecg = checkmeProvider.ecgList[ index ];

          return Container(
            margin: const EdgeInsets.symmetric( horizontal: 15, vertical: 5 ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all( width: 1, color: Colors.blueGrey )
            ),
            child: ListTile(
              title: Row(
                children: [
                  const Icon( Icons.favorite, color: Colors.red ),
                  const SizedBox( width:  5,),
                  FutureBuilder(
                    future: DBProvider.db.getValue(tableName: 'EcgDetails', dtcDate: ecg.dtcDate ),
                    builder: (_, AsyncSnapshot<List<dynamic>> snapshot){
          
                      if( snapshot.data != null ){
                        if( snapshot.data!.isNotEmpty ){
                          final res = snapshot.data![0] as EcgDetailsModel;
                          return Text(
                            'HR: ${ res.hrValue }', 
                            style: const TextStyle( fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black87 ),
                          );
                        }
                      }

                      return const Text('Unknow', style: TextStyle( fontSize: 20 ));
          
                    } 
                  )
                ],
              ),
              subtitle: Text( 
                getMeasurementDateTime( measurementDate: ecg.dtcDate ).toString().split('.')[0], 
                style: const TextStyle( fontSize: 17 ),
              ),
              // leading: CircleAvatar(
              //   radius: 30,
              //   backgroundColor: Colors.cyan,
              //   foregroundColor: Colors.white,
              //   child: Text( '${index + 1}' ),
              // ),
              trailing: const Icon( Icons.remove_red_eye ),
              onTap: ()async {
          
                checkmeProvider.currentEcg = ecg;
          
                final search = await DBProvider.db.getValue(tableName: 'EcgDetails', dtcDate: ecg.dtcDate );
          
                if( search.isEmpty ){
          
                  if(checkmeProvider.isConnected){
          
                    if( !checkmeProvider.isSync ){
                      checkmeProvider.currentSyncEcg ??= ecg;
                      final res = await checkmeProvider.getMeasurementDetails( dtcDate: ecg.dtcDate, detail: 'ECG' );
                      if( !res ){
                        return;
                      }
                    }else{
                    showDialog(context: context, builder: (_){
                      return const CustomAlertDialog(
                        message: 'Check the connection with the device.',
                        iconData: Icons.bluetooth_disabled,
                      );
                    }); 
                    return;
                  }
          
                  }else{
                    showDialog(context: context, builder: (_){
                      return const CustomAlertDialog(
                        message: 'Check the connection with the device.',
                        iconData: Icons.bluetooth_disabled,
                      );
                    });
                    return;
                  }
                }else{
                  checkmeProvider.currentEcgDetailsModel = search[0];
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