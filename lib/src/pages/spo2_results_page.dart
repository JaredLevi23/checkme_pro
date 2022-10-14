import 'dart:io';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Spo2ResultsPage extends StatelessWidget {
  const Spo2ResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SPO2 Results', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1))),
        actions: const [
          ConnectionIndicator()
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: checkmeProvider.spo2sList.length,
        itemBuilder: (context, index){

          final spo2 = checkmeProvider.spo2sList[index];
          final date = spo2.dtcDate.split(' ');

          return Card(
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( 'SPO2: ${spo2.spo2Value}' ),
                  Text( 'PR: ${spo2.prValue}' ),
                ],
              ),
              subtitle: Text( '${ getMeasurementDateTime( measurementDate: spo2.dtcDate ) }'),
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                child: Icon( Icons.air_rounded, size: 25,),
              ),
            ),
          );
      }),
    );
  }
}