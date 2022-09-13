import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SmlResultsPage extends StatelessWidget {
  const SmlResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SML Results'),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: checkmeProvider.smlList.length,
        itemBuilder: (_, index){

          final sml = checkmeProvider.smlList[ index ];
          final date = sml.dtcDate.split(' ');

          return Card(
            child: ListTile( 
              title: Text( 'Averange OX: ${sml.averageOx}\nLow Ox:${sml.lowOxTime}\nLowest Ox:${sml.lowestOx}\nLow Ox Number: ${sml.lowOxNumber}' ),
              subtitle: Text( 'Date: ${date[1]}/${date[3].padLeft(2,'0')}/${date[5]} ${date[7]}:${date[9]}:${date[11]}'),
              trailing: Text( 'Duration: ${sml.totalTime}', style: TextStyle( fontSize: 17),),
             ),
          );
        }
      ),
    );
  }
}