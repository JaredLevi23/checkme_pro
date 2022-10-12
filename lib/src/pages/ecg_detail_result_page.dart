import 'dart:io';

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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text( 'ECG Detail', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1)) ),
          actions: const [
            ConnectionIndicator()
          ],
        ),
    
        body: Column(
          children: [
            Card(
              child: ListTile(
                title: Text( 
                  Platform.isIOS 
                  ? getMeasurementDateTime( measurementDate: currentEcgModel.dtcDate ).toString().split('.')[0]
                  : currentEcgModel.dtcDate,
                  style: const TextStyle( fontSize: 18 ),
                ),
                trailing: const CircleAvatar( 
                  child: Icon(Icons.emoji_emotions,),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.cyan,
                ),
              ),
            ),
            Expanded(
              child: checkmeProvider.isSync || checkmeProvider.ecgDetailsList[ currentEcgModel.dtcDate ] == null 
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text('Please wait')
                    ],
                )
              : listResults( ecgDetails!, context )
            )
          ],
        )
      ),
    );
  }

  Widget listResults( EcgDetailsModel ecgDetails, context ){
    return ListView(
      children: [
         Row(
          children: [
            Expanded(
              child: cardResult( 
                value: getMeasureFormatTime(seconds: ecgDetails.timeLength ), 
                title: 'Duration', 
                unitMeasurement: "s", 
                icon: Icons.timer_outlined, 
                iconColor: Colors.blue,
                fontSize: 30
              ),
            ),
            

          Expanded(
              child: cardResult( 
                value: ecgDetails.hrValue, 
                title: 'HR', 
                unitMeasurement: "/min",
                icon: Icons.favorite
              ),
            )
            
          ],
        ),
        Row(
          children: [

            Expanded(
              child: cardResult( 
                value: ecgDetails.qtcValue, 
                title: 'QTc', 
                unitMeasurement: "ms" 
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
                value: 'ECG',
                title: '', 
                unitMeasurement: "", 
                icon: Icons.graphic_eq, 
                iconColor: Colors.blue,
                onTap: (){
                  Navigator.pushNamed(context, 'checkme/ecg/record');
                }
              ),
            )
          ],
        ),
       

        //EcgGrap(graphData: ecgDetails.arrEcgContent, sizeY: 4500, ) ,

    ]);
  }

  Widget cardResult(
    { 
      String? title, 
      dynamic value, 
      String? unitMeasurement, 
      IconData? icon, 
      Color? iconColor, 
      double? fontSize,
      Function()? onTap
    }
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 190,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
    
                  Icon( icon ?? Icons.monitor, size: 45, color: iconColor ?? Colors.red,),
                  
                  Text( 
                    title ?? 'No title', 
                    style: const TextStyle( 
                      fontStyle: FontStyle.italic, 
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                    ),
                  ),
    
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$value', style: TextStyle( fontSize: fontSize ?? 45, fontWeight: FontWeight.bold),),
                  Text( unitMeasurement ?? 'No units', style: const TextStyle( fontStyle: FontStyle.italic ),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}