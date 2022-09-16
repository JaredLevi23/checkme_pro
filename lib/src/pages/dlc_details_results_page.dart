import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import '../models/models.dart';
import '../utils/utils_date.dart';

class DlcDetailsResultsPage extends StatelessWidget {
  const DlcDetailsResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final DlcModel currentDlcModel = checkmeProvider.currentDlc;
    EcgDetailsModel? ecgDetails = checkmeProvider.dlcDetailsList[ currentDlcModel.dtcDate ];

    return Scaffold(
      appBar: AppBar(
        title: const Text( 'DLC Detail' ),
        actions: const [
          ConnectionIndicator()
        ],
      ),

      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text( '${ getMeasurementDateTime( measurementDate: currentDlcModel.dtcDate )}'),
              trailing: const CircleAvatar( 
                child: Icon(Icons.emoji_emotions,),
                backgroundColor: Colors.white,
                foregroundColor: Colors.cyan,
              ),
            ),
          ),
          Expanded(
            child: checkmeProvider.isSync && ecgDetails == null
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Please wait')
                  ],
              )
            : listResults( ecgDetails: ecgDetails!, dlcModel: currentDlcModel )
          )
        ],
      )
    );
  }

  Widget listResults( {required EcgDetailsModel ecgDetails, required DlcModel dlcModel } ){
    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: cardResult( 
                value: dlcModel.spo2Value, 
                title: 'SPO2', 
                unitMeasurement: "",
                icon: Icons.percent
              ),
            ),
            Expanded(
              child: cardResult( 
                value: dlcModel.pIndex, 
                title: 'PI', 
                unitMeasurement: "",
                icon: Icons.monitor
              ),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: cardResult( 
                value: ecgDetails.hrValue, 
                title: 'HR', 
                unitMeasurement: "/min",
                icon: Icons.favorite
              ),
            ),
            Expanded(
              child: cardResult( 
                value: ecgDetails.qrsValue, 
                title: 'QRS', 
                unitMeasurement: "ms",
                icon: Icons.monitor
              ),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: cardResult( 
                value: ecgDetails.qtValue, 
                title: 'QT', 
                unitMeasurement: "ms" 
              ),
            ),
            Expanded(
              child: cardResult( 
                value: ecgDetails.qtcValue, 
                title: 'QTc', 
                unitMeasurement: "ms" 
              ),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: cardResult( 
                value: ecgDetails.timeLength, 
                title: 'Duration', 
                unitMeasurement: "s", 
                icon: Icons.timer, 
                iconColor: Colors.blue 
              ),
            ),
            Expanded(
              child: Container(
                height: 160,
                padding: const EdgeInsets.all(6),
                child: MaterialButton(
                  color: Colors.white,
                  onPressed: (){},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text( 'Results', style:TextStyle( fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),),
                      Icon( Icons.monitor_heart, size: 120, color: Colors.cyan,)
                    ],
                  ),
                ),
              )
            )
          ],
        ),

        EcgGrap(graphData: ecgDetails.arrEcgContent ) ,

        Text( 'ARR_HEART_RATE:${ecgDetails.arrEcgHeartRate}'),
        Text( 'ARR_ECG_CONTENT:${ecgDetails.arrEcgContent}'),
    ]);
  }

  Card cardResult({ String? title, dynamic value, String? unitMeasurement, IconData? icon, Color? iconColor  }) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text( title ?? 'No title', style: const TextStyle( fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),),
                const SizedBox( width: 6, ),
                Icon( icon ?? Icons.monitor, size: 20, color: iconColor ?? Colors.red,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$value', style: const TextStyle( fontSize: 70),),
                Text( unitMeasurement ?? 'No units')
              ],
            )
          ],
        ),
      ),
    );
  }
}