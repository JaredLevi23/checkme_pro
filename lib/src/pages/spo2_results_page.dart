import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:checkme_pro_develop/src/widgets/widgets.dart';

class Spo2ResultsPage extends StatelessWidget {
  const Spo2ResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    const subtitleStyle = TextStyle( fontSize: 20, fontWeight: FontWeight.bold );
    const titleStyle = TextStyle( fontSize: 35, fontWeight: FontWeight.bold, color: Colors.blue );

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

          // spo2 model 
          final spo2 = checkmeProvider.spo2sList[index];

          return Container(
            margin: const EdgeInsets.symmetric( horizontal: 8, vertical: 5 ),
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular( 15 ),
              color: Colors.white
            ),
            // results 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('SPO2', style: subtitleStyle ,),
                        Text( '${spo2.spo2Value}', style: titleStyle )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('PR', style: subtitleStyle,),
                        Text( '${spo2.prValue}', style: titleStyle, )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('PI', style: subtitleStyle ,),
                        Text( '${spo2.pIndex }', style: titleStyle, )
                      ],
                    ),
                  ],
                ),
                const SizedBox( height: 5, ),

                // date time 
                Text( 
                  getMeasurementDateTime( measurementDate: spo2.dtcDate ).toString().split('.')[0],
                  style: subtitleStyle,
                ),
              ],
            ),
          );
      }),
    );
  }
}