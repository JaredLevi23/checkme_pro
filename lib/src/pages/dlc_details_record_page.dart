import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import '../models/models.dart';

class DlcDetailsRecordPage extends StatefulWidget {
  const DlcDetailsRecordPage({Key? key}) : super(key: key);

  @override
  State<DlcDetailsRecordPage> createState() => _EcgRecordDetailsState();
}

class _EcgRecordDetailsState extends State<DlcDetailsRecordPage> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final currentModel = checkmeProvider.currentDlc;
    EcgDetailsModel? dlcDetails = checkmeProvider.currentEcgDetailsModel;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //backgroundColor: const Color.fromRGBO(203, 232, 250, 1),
          title: const Text( 'Daily Check', style: TextStyle( fontSize: 18),),
          actions: [

            // date time
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric( horizontal: 8 ),
                child: Text( 
                  getMeasurementDateTime(measurementDate: currentModel.dtcDate).toString().split('.')[0],
                  style: const TextStyle( fontSize: 18)
                ),
              ),
            )
          ],
        ),

        body: Column(
          children: [
            const SizedBox( height: 10 ),
            Expanded(
              child: ListView(
                children: [

                  // results 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon( Icons.favorite, color: Colors.pink, ),
                          Text( 'HR: ${dlcDetails?.hrValue}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor, color: Colors.pink, ),
                          Text( 'QT: ${dlcDetails?.qtValue}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor, color: Colors.pink, ),
                          Text( 'QTc: ${dlcDetails?.qtcValue}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor_rounded, color: Colors.pink, ),
                          Text( 'QRS: ${dlcDetails?.qrsValue}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
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

                  // graph 
                  EcgGrap(graphData: dlcDetails?.arrEcg ?? [] )
                ],
              )
            )

          ],
        ),
      ),
    );
  }
}