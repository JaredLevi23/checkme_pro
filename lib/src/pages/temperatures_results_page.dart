import 'dart:io';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

class TemperaturesResultsPage extends StatelessWidget {
  const TemperaturesResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar( 
        title: const Text( 'Temperatures', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1)) ),
        actions: const[ ConnectionIndicator(), ],
      ),
      body: ListView.builder(
        itemCount: checkmeProvider.tmpList.length,
        itemBuilder: (context, index){

          // temperature model 
          final temp = checkmeProvider.tmpList[ index ];

          return Container(
            height: 100,
            margin: const EdgeInsets.symmetric( horizontal: 15, vertical: 5 ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular( 15 ),
              color: Colors.white
            ),

            // results 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon( Icons.thermostat, color: Colors.blueGrey, size: 30,),
                    Text( 
                      '${temp.tempValue} °C', 
                      style: const TextStyle( fontSize: 35 ), 
                    ),
                  ],
                ),

                // date time 
                Text( 
                  getMeasurementDateTime(measurementDate: temp.dtcDate ).toString().split('.')[0],
                  style: const TextStyle( fontSize: 17 ),
                ),
              ],
            )
          );

        }
      ),
    );
  }
}