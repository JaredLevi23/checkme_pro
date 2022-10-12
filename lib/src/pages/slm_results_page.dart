import 'dart:io';

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          final date = slm.dtcDate.split(' ');

          return Card(
            child: GestureDetector( 
              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: const Color.fromRGBO(50, 97, 148, 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon( Icons.night_shelter_outlined, size: 70, color: Colors.white,),
                        Text('Duration ${ slm.totalTime }', style: const TextStyle( color: Colors.white), textAlign: TextAlign.center,)
                      ],
                    )
                  ),
                  const SizedBox( width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( Platform.isIOS ? 'Date: ${date[1]}/${date[3].padLeft(2,'0')}/${date[5]} ${date[7]}:${date[9]}:${date[11]}' : 'Date: ${ slm.dtcDate }', style: const TextStyle(  fontWeight: FontWeight.bold ), ),
                      Text( 'Averange OX: ${slm.averageOx}\nLow Ox:${slm.lowOxTime}\nLowest Ox:${slm.lowestOx}\nLow Ox Number: ${slm.lowOxNumber}' ),
                      //Text( 'Duration: ${slm.totalTime}', style: const TextStyle( fontSize: 17),),
                    ],
                  )
                ],
              ),
              onTap: () async {
                checkmeProvider.currentSlm = slm;

                if( !checkmeProvider.slmDetailsList.containsKey( slm.dtcDate ) ){
                  if(checkmeProvider.isConnected){
                    if( !checkmeProvider.isSync ){
                      checkmeProvider.currentSyncSlm ??= slm;
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
                      }
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
                }
                Navigator.pushNamed(context, 'checkme/slm/details');
              },
             ),
          );
        }
      ),
    );
  }
}