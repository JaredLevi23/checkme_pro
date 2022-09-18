import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import '../models/models.dart';
import '../utils/utils_date.dart';

class EcgDetailResultPage extends StatelessWidget {
  const EcgDetailResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final EcgModel currentEcgModel = checkmeProvider.currentEcg;
    EcgDetailsModel? ecgDetails = checkmeProvider.ecgDetailsList[ currentEcgModel.dtcDate ];

    return Scaffold(
      appBar: AppBar(
        title: const Text( 'ECG Detail' ),
        actions: const [
          ConnectionIndicator()
        ],
      ),

      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text( '${ getMeasurementDateTime( measurementDate: currentEcgModel.dtcDate )}'),
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
            : listResults( ecgDetails! )
          )
        ],
      )
    );
  }

  Widget listResults( EcgDetailsModel ecgDetails ){
    return ListView(
      children: [
         Row(
          children: [
            Expanded(
              child: cardResult( 
                value: getMeasureFormatTime(seconds: ecgDetails.timeLength ), 
                title: 'Duration', 
                unitMeasurement: "s", 
                icon: Icons.timer, 
                iconColor: Colors.blue 
              ),
            ),
            
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
       

        Stack(
          children: [

            EcgGrap(graphData: ecgDetails.arrEcgContent, sizeY: 4500, ),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: const CircleBorder()
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ) ,

    ]);
  }

  Card cardResult({ String? title, dynamic value, String? unitMeasurement, IconData? icon, Color? iconColor  }) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text( title ?? 'No title', style: const TextStyle( fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),),
                const SizedBox( width: 6, ),
                Icon( icon ?? Icons.monitor, size: 35, color: iconColor ?? Colors.red,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$value', style: const TextStyle( fontSize: 45),),
                Text( unitMeasurement ?? 'No units')
              ],
            )
          ],
        ),
      ),
    );
  }
}