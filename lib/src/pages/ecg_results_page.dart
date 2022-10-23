import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/db/db_provider.dart';
import 'package:checkme_pro_develop/src/models/models.dart';
import 'package:checkme_pro_develop/src/providers/providers.dart';
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

          // ecg model 
          final ecg = checkmeProvider.ecgList[ index ];

          return Container(
            margin: const EdgeInsets.symmetric( horizontal: 15, vertical: 5 ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white
            ),
            child: ListTile(
              title: Row(
                children: [
                  const Icon( Icons.favorite, color: Colors.red ),
                  const SizedBox( width:  5,),

                  // result 
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

                      return const Text(' - ', style: TextStyle( fontSize: 20 ));
          
                    } 
                  )
                ],
              ),

              // date time 
              subtitle: Text( 
                getMeasurementDateTime( measurementDate: ecg.dtcDate ).toString().split('.')[0], 
                style: const TextStyle( fontSize: 17 ),
              ),
              
              // download or display icon
              trailing: FutureBuilder(
                future: DBProvider.db.getValue(tableName: 'EcgDetails', dtcDate: ecg.dtcDate ),
                builder: (_, AsyncSnapshot<List<dynamic>> snapshot){
                  if( snapshot.data != null ){
                    if( snapshot.data!.isNotEmpty ){
                      return const Icon( Icons.remove_red_eye, color: Colors.grey,);
                    }
                  }
                  return Icon( Icons.download, color: checkmeProvider.isConnected ? Colors.greenAccent : Colors.pink );
                } 
              ),
              onTap: ()async {

                // change the current ecg model 
                checkmeProvider.currentEcg = ecg;

                // find current model details
                final search = await DBProvider.db.getValue(tableName: 'EcgDetails', dtcDate: ecg.dtcDate );
          
                if( search.isEmpty ){
          
                  if(checkmeProvider.isConnected){
          
                    if( !checkmeProvider.isSync ){
                      // current sync
                      checkmeProvider.currentSyncEcg ??= ecg;
                      // get details by bluetooth
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
                  // change the current ecg details model 
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