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

          final temp = checkmeProvider.tmpList[ index ];

          return  Column(
            children: [
              ListTile(
                title: Text( '${getMeasurementDateTime(measurementDate: temp.dtcDate )}' ),
                subtitle: const Text('Date'),
                leading: const Icon( Icons.thermostat ),
                trailing: Text( '${temp.tempValue } °C', style: const TextStyle( fontSize: 19 ),),
              ),
              const Divider()
            ],
          );

        }
      ),
    );
  }
}