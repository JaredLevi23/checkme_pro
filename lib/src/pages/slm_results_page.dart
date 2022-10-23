import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:checkme_pro_develop/src/db/db_provider.dart';
import 'package:checkme_pro_develop/src/providers/providers.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import '../widgets/widgets.dart';

class SlmResultsPage extends StatelessWidget {
  const SlmResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Monitor', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1))),
        actions: const [
          ConnectionIndicator(),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: checkmeProvider.slmList.length,
        itemBuilder: (_, index){

          final slm = checkmeProvider.slmList[ index ];

          return Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular( 15 )
            ),
            child: GestureDetector( 
              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(50, 97, 148, 1),
                      borderRadius: BorderRadius.only( topLeft: Radius.circular( 15 ), bottomLeft: Radius.circular( 15)  )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon( Icons.night_shelter_outlined, size: 70, color: Colors.white,),
                      ],
                    )
                  ),
                  const SizedBox( width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // date time 
                      Text( 
                        getMeasurementDateTime(measurementDate: slm.dtcDate ).toString().split('.')[0], 
                        style: const TextStyle(  fontWeight: FontWeight.bold, fontSize: 17 ), 
                      ),

                      // results 
                      _description( 'Duration: ' , getMeasureFormatTime( seconds: slm.totalTime ) ),
                      _description( 'Average: ' , '${slm.averageOx}' ),
                      _description( 'Lowest: ' , '${slm.lowestOx}' ),
                    ],
                  )
                ],
              ),
              onTap: () async {

                // change the current sleep monitor model 
                checkmeProvider.currentSlm = slm;
                // find current model details
                final search = await DBProvider.db.getValue(tableName: 'SlmDetails', dtcDate: slm.dtcDate );

                if( search.isEmpty ){
                  if( checkmeProvider.isConnected ){
                    // current sync 
                    checkmeProvider.currentSyncSlm ??= slm;
                    // get details by bluetooth
                    final res = await checkmeProvider.getMeasurementDetails(dtcDate: slm.dtcDate, detail: 'SLM');

                    if( !res ){
                      showDialog(
                          context: context, 
                          builder: (_){ 
                            return const CustomAlertDialog(
                              message: 'Please try again or check the connection with the device', 
                              iconData: Icons.info
                            );
                          }
                        );
                        return;
                    }
                  }else{
                    showDialog(
                          context: context, 
                          builder: (_){ 
                            return const CustomAlertDialog(
                              message: 'Please try again or check the connection with the device', 
                              iconData: Icons.info
                            );
                          }
                        );
                        return;
                  }
                }else{
                  // change the current sleep monitor details model 
                  checkmeProvider.currentSlmDetailsModel = search[0];
                }
                Navigator.pushNamed(context, 'checkme/slm/details');
              },
             ),
          );
        }
      ),
    );
  }

  Widget _description( String title, String value ){
    return Row(
      children: [
        Text( title, style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 15 ), ),
        Text( value, style: const TextStyle( fontWeight: FontWeight.w500, fontSize: 15 ), ),
      ],
    );
  }
}