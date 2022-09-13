
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class EcgDetailResultPage extends StatelessWidget {
  const EcgDetailResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final EcgModel currentModel = checkmeProvider.currentEcg;
    final date = currentModel.dtcDate.split(' ');

    return Scaffold(
      appBar: AppBar(
        title: const Text( 'ECG Detail' ),
      ),

      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text( 'Date: ${date[1]}/${date[3].padLeft(2,'0')}/${date[5]} ${date[7]}:${date[9]}:${date[11]}'),
              trailing: const CircleAvatar( 
                child: Icon(Icons.emoji_emotions,),
                backgroundColor: Colors.white,
                foregroundColor: Colors.cyan,
              ),
            ),
          ),
          Expanded(
            child: checkmeProvider.isSync 
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Please wait')
                  ],
              )
            : listResults( context, currentModel )
          )
        ],
      )
    );
  }

  Widget listResults( context, EcgModel ecgModel ){

    final ecgDetails = Provider.of<CheckmeChannelProvider>(context).ecgDetailsList[ecgModel.dtcDate];

    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: cardResult( 
                value: ecgDetails?.hrValue, 
                title: 'HR', 
                unitMeasurement: "/min",
                icon: Icons.favorite
              ),
            ),
            Expanded(
              child: cardResult( 
                value: ecgDetails?.qrsValue, 
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
                value: ecgDetails?.qtValue, 
                title: 'QT', 
                unitMeasurement: "ms" 
              ),
            ),
            Expanded(
              child: cardResult( 
                value: ecgDetails?.qtcValue, 
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
                value: ecgDetails?.timeLength, 
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

        EcgGrap(graphData: ecgDetails?.arrEcgContent ?? [] ) ,

        Text( 'ARR_HEART_RATE:[${ecgDetails?.arrEcgHeartRate}]'),
        Text( 'ARR_ECG_CONTENT:[${ecgDetails?.arrEcgContent}]'),
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