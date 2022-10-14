import 'dart:io';
import 'package:checkme_pro_develop/src/db/db_provider.dart';
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
        title: const Text('ECG Results', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1))),
        actions: const [
          ConnectionIndicator()
        ],
      ),
      body: ListView.builder(
        itemCount: checkmeProvider.ecgList.length,
        itemBuilder: (_, index){

          final ecg = checkmeProvider.ecgList[ index ];

          return Card(
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
                          return Text('HR: ${ res.hrValue }');
                        }
                      }
                      return const Text('Need Sync');

                    } 
                  )
                ],
              ),
              subtitle: Text( '${getMeasurementDateTime( measurementDate: ecg.dtcDate )}'),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                child: Text( '${index + 1}' ),
              ),
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