
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'
;
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import '../models/models.dart';

class EcgDetailsRecordPage extends StatefulWidget {
  const EcgDetailsRecordPage({Key? key}) : super(key: key);

  @override
  State<EcgDetailsRecordPage> createState() => _EcgRecordDetailsState();
}

class _EcgRecordDetailsState extends State<EcgDetailsRecordPage> {

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
    final currentModel = checkmeProvider.currentEcg;
    EcgDetailsModel? ecgDetails = checkmeProvider.currentEcgDetailsModel;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          // date time 
          title: Text( 
            getMeasurementDateTime(
              measurementDate: currentModel.dtcDate ).toString().split('.')[0] , 
              style: const TextStyle( color: Color.fromRGBO(50, 97, 148, 1))
          ),
        ),

        // results 
        body: Column(
          children: [
            const SizedBox( height: 10, ),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon( Icons.favorite, color: Colors.pink, ),
                          Text( 'HR: ${ecgDetails?.hrValue}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor, color: Colors.pink, ),
                          Text( 'QT: ${ecgDetails?.qtValue}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor, color: Colors.pink, ),
                          Text( 'QTc: ${ecgDetails?.qtcValue}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                      Column(
                        children: [
                          const Icon( Icons.monitor_rounded, color: Colors.pink, ),
                          Text( 'QRS: ${ecgDetails?.qrsValue}', style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ), )
                        ],
                      ),
                    ],
                  ),
                  EcgGrap(graphData: ecgDetails?.arrEcg ?? [] )
                ],
              )
            )

          ],
        ),
      ),
    );
  }
}