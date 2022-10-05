import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import '../models/models.dart';
import '../utils/utils_date.dart';

class EcgDetailResultAndroidPage extends StatelessWidget {
  const EcgDetailResultAndroidPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final EcgModel currentEcgModel = checkmeProvider.currentEcg;
    EcgDetailsAndroidModel? ecgDetails = checkmeProvider.ecgDetailsAndroidList[ currentEcgModel.dtcDate ];

    return SafeArea(
      child: Scaffold(
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
                title: Text( 
                  currentEcgModel.dtcDate,
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
              child: checkmeProvider.isSync || checkmeProvider.ecgDetailsAndroidList[ currentEcgModel.dtcDate ] == null 
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text('Please wait')
                    ],
                )
              : listResults(ecgDetails!, context)
            )
          ],
        )
      ),
    );
  }

  Widget listResults( EcgDetailsAndroidModel ecgDetails, context ){
    return ListView(
      children: [
         Row(
          children: [
            Expanded(
              child: cardResult( 
                value: getMeasureFormatTime(seconds: ecgDetails.total ), 
                title: 'Duration', 
                unitMeasurement: "s", 
                icon: Icons.timer_outlined, 
                iconColor: Colors.blue,
                fontSize: 30
              ),
            ),
            

          Expanded(
              child: cardResult( 
                value: ecgDetails.hr, 
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
                value: ecgDetails.qtc, 
                title: 'QTc', 
                unitMeasurement: "ms" 
              ),
            ),
            Expanded(
              child: cardResult( 
                value: ecgDetails.qrs, 
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
                value: ecgDetails.qt, 
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
                  Navigator.pushNamed(context, 'checkme/ecg-android/record');
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

