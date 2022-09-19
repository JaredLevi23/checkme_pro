import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
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
        title: const Text( 'Temperatures' ),
        actions: const[ ConnectionIndicator(), ],
      ),
      body: ListView.builder(
        itemCount: checkmeProvider.temperaturesList.length,
        itemBuilder: (context, index){

          final temp = checkmeProvider.temperaturesList[ index ];
          final date = temp.dtcDate.split(' ');

          return  Column(
            children: [
              ListTile(
                title: Text( '${date[1]}/${date[3].padLeft(2,'0')}/${date[5]} ${date[7]}:${date[9]}:${date[11]}'),
                subtitle: const Text('Date'),
                leading: const Icon( Icons.thermostat ),
                trailing: Text( temp.tempValue + ' °C', style: const TextStyle( fontSize: 19 ),),
              ),
              const Divider()
            ],
          );

        }
      ),
    );
  }
}