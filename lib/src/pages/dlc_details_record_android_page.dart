import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import '../models/models.dart';

class DlcDetailsRecordAndroidPage extends StatefulWidget {
  const DlcDetailsRecordAndroidPage({Key? key}) : super(key: key);

  @override
  State<DlcDetailsRecordAndroidPage> createState() => _EcgRecordDetailsAndroidState();
}

class _EcgRecordDetailsAndroidState extends State<DlcDetailsRecordAndroidPage> {

  @override
  Widget build(BuildContext context) { 

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final currentModel = checkmeProvider.currentDlc;
    EcgDetailsAndroidModel? dlcDetails = checkmeProvider.dlcDetailsAndroidList[ currentModel.dtcDate ];

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
                          const Text( 'Daily Check', style: TextStyle( fontSize: 18, color: Colors.white),),
                          Text( 
                            Platform.isIOS
                            ? getMeasurementDateTime(measurementDate: currentModel.dtcDate).toString().split('.')[0]
                            : currentModel.dtcDate,
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
                          Text( 'HR: ${dlcDetails?.hr}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor, color: Colors.pink, ),
                          Text( 'QT: ${dlcDetails?.qt}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon( Icons.monitor, color: Colors.pink, ),
                          Text( 'QTc: ${dlcDetails?.qtc}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor_rounded, color: Colors.pink, ),
                          Text( 'QRS: ${dlcDetails?.qrs}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon( Icons.monitor, color: Colors.pink, ),
                          Text( 'SPO: ${currentModel.spo2Value}%', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor_rounded, color: Colors.pink, ),
                          Text( 'PI: ${currentModel.pIndex}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                    ],
                  ),
                  EcgGrapAndroid(graphData: dlcDetails?.waveViewList ?? [])
                ],
              )
            )

          ],
        ),
      ),
    );
  }
}