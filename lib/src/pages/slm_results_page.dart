import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

class SlmResultsPage extends StatelessWidget {
  const SlmResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Monitor'),
        actions: const [
          ConnectionIndicator(),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: checkmeProvider.slmList.length,
        itemBuilder: (_, index){

          final slm = checkmeProvider.slmList[ index ];
          final date = slm.dtcDate.split(' ');

          return Card(
            child: ListTile( 
              title: Text( 'Averange OX: ${slm.averageOx}\nLow Ox:${slm.lowOxTime}\nLowest Ox:${slm.lowestOx}\nLow Ox Number: ${slm.lowOxNumber}' ),
              subtitle: Text( 'Date: ${date[1]}/${date[3].padLeft(2,'0')}/${date[5]} ${date[7]}:${date[9]}:${date[11]}'),
              trailing: Text( 'Duration: ${slm.totalTime}', style: const TextStyle( fontSize: 17),),
              onTap: () async {
                checkmeProvider.currentSlm = slm;

                if( !checkmeProvider.ecgDetailsList.containsKey( slm.dtcDate ) ){

                  if(checkmeProvider.isConnected){

                    if( !checkmeProvider.isSync ){
                      checkmeProvider.currentSyncSlm ??= slm;
                      await checkmeProvider.getMeasurementDetails(dtcDate: slm.dtcDate, detail: 'SLM');
                    }

                  }else{
                    showDialog(context: context, builder: (_){
                      return const CustomAlertDialog();
                    });
                    return;
                  }
                }
                
                Navigator.pushNamed(context, 'checkme/slm/details');
              },
             ),
          );
        }
      ),
    );
  }
}