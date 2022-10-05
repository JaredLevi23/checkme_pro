
import 'dart:io';

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class EcgDetailsRecordAndroidPage extends StatefulWidget {
  const EcgDetailsRecordAndroidPage({Key? key}) : super(key: key);

  @override
  State<EcgDetailsRecordAndroidPage> createState() => _EcgRecordDetailsState();
}

class _EcgRecordDetailsState extends State<EcgDetailsRecordAndroidPage> {

  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  // }

  // @override
  // void dispose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //   ]);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) { 

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final currentModel = checkmeProvider.currentEcg;
    EcgDetailsAndroidModel? ecgDetails = checkmeProvider.ecgDetailsAndroidList[ currentModel.dtcDate ];

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.cyan,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text( 'Record ECG', style: TextStyle( fontSize: 18, color: Colors.white),),
                          Text( 
                            Platform.isIOS ? getMeasurementDateTime(measurementDate: currentModel.dtcDate).toString().split('.')[0] : currentModel.dtcDate,
                            style: const TextStyle( fontSize: 18, color: Colors.white)
                          )
                        ],
                      )
                    ],
                  ),

                  IconButton(
                    icon: const Icon( Icons.arrow_back_ios_rounded, size: 30, color: Colors.white),
                    onPressed: ()=> Navigator.pop(context), 
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon( Icons.favorite, color: Colors.pink, ),
                          Text( 'HR: ${ecgDetails?.hr}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor, color: Colors.pink, ),
                          Text( 'QT: ${ecgDetails?.qt}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor, color: Colors.pink, ),
                          Text( 'QTc: ${ecgDetails?.qtc}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor_rounded, color: Colors.pink, ),
                          Text( 'QRS: ${ecgDetails?.qrs}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                    ],
                  ),

                  EcgGrapAndroid(graphData: ecgDetails?.waveViewList ?? [] )
                ],
              )
            )

          ],
        ),
      ),
    );
  }
}