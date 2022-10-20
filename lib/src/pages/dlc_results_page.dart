import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/db/db_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import '../utils/utils_date.dart';
import '../widgets/widgets.dart';


class DlcResultsPage extends StatelessWidget {
  const DlcResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DLC Results', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1))),
        actions: const [ 
          ConnectionIndicator(),
         ],
      ),

      body: ListView.builder(
        //itemCount: checkmeProvider.dlcList.length,
        itemCount: checkmeProvider.dlcList.length,
        itemBuilder: (_, index){

          final dlc = checkmeProvider.dlcList[index];

          return Container(
            margin: const EdgeInsets.symmetric( horizontal: 10, vertical: 5 ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular( 15 ),
              // border: Border.all( width: 2, color: Color.fromRGBO(50, 97, 148, 1) ),
              color: Colors.white
            ),
            child: MaterialButton(
              padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  
                  Text( 
                    getMeasurementDateTime( measurementDate: dlc.dtcDate ).toString().split('.')[0],
                    style: const TextStyle( fontSize: 19, fontWeight: FontWeight.bold ),
                  ),

                  //const SizedBox( height: 5,),
                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _description('SPO2: ', '${dlc.spo2Value}%' ),
                          const SizedBox(height: 5,),
                          _description('HR: ', '${dlc.hrValue}/min' ),
                        ],
                      ),
                      Column(
                        children: const [
                          Icon( Icons.remove_red_eye, color: Colors.blue,)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              onPressed: ()async {
                checkmeProvider.currentDlc = dlc;

                final search = await DBProvider.db.getValue(tableName: 'EcgDetails', dtcDate: dlc.dtcDate );

                if( search.isEmpty ){
                  if( checkmeProvider.isConnected ){
                   final res = await checkmeProvider.getMeasurementDetails( dtcDate: dlc.dtcDate, detail: 'DLC' );
                    if( !res ){
                      showDialog(
                        context: context, 
                        builder: (_){
                          return const CustomAlertDialog(
                            message: 'Please try again or check the connection with the device', 
                            iconData: Icons.error
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
                            iconData: Icons.error
                          );
                        }
                      );
                      return;
                  }
                }else{
                  checkmeProvider.currentEcgDetailsModel = search[0];
                }

                Navigator.pushNamed(context, 'checkme/dlc/details');  
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
        Text(
          title, 
          textAlign: TextAlign.start, 
          style: const TextStyle( fontSize: 22, color: Colors.blue ), 
        ),
        Text(
          value, 
          textAlign: TextAlign.start, 
          style: const TextStyle( fontSize: 22 ), 
        ),
      ],
    );
  }
}