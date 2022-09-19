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
              title: Text( 
                getMeasurementDateTime( measurementDate: currentDlcModel.dtcDate ).toString().split('.')[0],
                style: const TextStyle( 
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),
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
            : listResults( ecgDetails: ecgDetails!, dlcModel: currentDlcModel, context: context )
          )
        ],
      )
    );
  }

  Widget listResults( {required EcgDetailsModel ecgDetails, required DlcModel dlcModel, required BuildContext context } ){
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
              child: cardResult( 
                value: 'ECG',
                title: '', 
                unitMeasurement: "", 
                icon: Icons.graphic_eq, 
                iconColor: Colors.blue,
                onTap: (){
                  Navigator.pushNamed(context, 'checkme/dlc/record');
                }
              ),
            )
          ],
        ),

        //EcgGrap(graphData: ecgDetails.arrEcgContent ) ,

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
          height: 145,
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