import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import '../utils/utils_date.dart';

class PedResultsPage extends StatelessWidget {
  const PedResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PED Results'),
      ),

      body: ListView.builder(
        itemCount: checkmeProvider.pedList.length,
        itemBuilder: (_, index){

          final ped = checkmeProvider.pedList[index];

          return Container(
            margin: const EdgeInsets.only( top: 10, bottom: 5, right: 15, left: 15 ),
            padding: const EdgeInsets.symmetric( vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all( color: Colors.cyan, width: 5 )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(
                  getMeasurementDateTime( measurementDate : ped.dctDate ).toString().split('.')[0],
                  style: const TextStyle( fontSize: 22, fontStyle: FontStyle.italic ),
                  ),

                const SizedBox(height: 10,),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _information(units: 'Time', value: getMeasureFormatTime(seconds: ped.totalTime), icondata: Icons.timer),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _information(units: 'km/h', value: '${ped.speed}', icondata: Icons.speed ),
                    const Icon( Icons.directions_run_rounded,  size: 70, color: Colors.cyan, ),
                    _information(units: 'Km', value: '${ped.distance }', icondata: Icons.mode_of_travel_outlined ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _information(units: 'KCal', value: '${ped.calorie}', icondata: Icons.local_fire_department_outlined),
                    _information(units: 'Steps', value: '${ped.steps }', icondata: Icons.terrain_rounded ),
                    _information(units: 'Fat', value: '${ped.fat}', icondata: Icons.circle_outlined),
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _information({ required String units, required String value, required IconData icondata }){
    return Row(
      children: [

        Icon( icondata , size: 40, color: Colors.cyan,),
        const SizedBox( width: 8, ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( value , style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal  )),
            Text( units , style: const TextStyle( fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic ))
          ], 
        ) 
      ],
    );
  }
}