import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EcgResultsPage extends StatelessWidget {
  const EcgResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de ECG'),
      ),
      body: ListView.builder(
        itemCount: checkmeProvider.ecgList.length,
        itemBuilder: (_, index){

          final ecg = checkmeProvider.ecgList[ index ];
          final date = ecg.dtcDate.split(' ');

          return Card(
            child: ListTile(
              title: Text( ecg.type ),
              subtitle: Text( 'Date: ${date[1]}/${date[3].padLeft(2,'0')}/${date[5]} ${date[7]}:${date[9]}:${date[11]}'),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                child: Text( '${index + 1}' ),
              ),
            ),
          );
        }
      )
    );
  }
}