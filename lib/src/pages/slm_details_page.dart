import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import '../widgets/widgets.dart';

class SlmDetailsPage extends StatelessWidget {
  const SlmDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final currentSlm = checkmeProvider.currentSlm;
    final currentDetailsSlm = checkmeProvider.currentSlmDetailsModel;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Sleep Monitor Details', style: TextStyle( color: Color.fromRGBO(50, 97, 148, 1))),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric( horizontal: 15 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              const SizedBox( height: 5, ),

              // date time 
              Center(
                child: Text( 
                  getMeasurementDateTime(measurementDate: currentSlm.dtcDate).toString().split('.')[0],
                  style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold ),
                ),
              ),

              const SizedBox( height: 5, ),

             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon( Icons.night_shelter, size: 60, color: Color.fromRGBO(50, 97, 148, 1),),
                const SizedBox(
                  width: 10,
                ),

                // results 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _description( 'Average: ', '${currentSlm.averageOx}%' ),
                    _description( 'Lowest: ', '${currentSlm.lowestOx}%' ),
                    _description( 'Time: ', getMeasureFormatTime( seconds: currentSlm.totalTime ) ),
                  ],
                )
              ],
             ),

              const SizedBox( height: 10, ),
        
              const Center(
                child: Text(
                  'PR/min', 
                  style: TextStyle( 
                    fontSize: 17, 
                    fontWeight: FontWeight.bold, 
                    color: Color.fromRGBO(50, 97, 148, 1)
                  ),
                )
              ),

              // pr graph 
              SizedBox(
                height:  250,
                child: PrGraph(prList: currentDetailsSlm?.arrPrValue ?? [])
              ),
      
              const SizedBox( height: 10, ),

              const Center(
                child: Text(
                  '% SPO2',
                  style: TextStyle( 
                    fontSize: 17, 
                    fontWeight: FontWeight.bold, 
                    color: Color.fromRGBO(50, 97, 148, 1) 
                  ),
                )
              ),

              // spo2 graph 
              SizedBox(
                height:  250,
                  child: Spo2Graph(spoList: currentDetailsSlm?.arrOxValue ?? [])
              ),
              
              const SizedBox( height: 15, )
        
            ],
          ),
        ),
      ),
    );
  }

  Widget _description( String title, String value ){
    return Row(
      children: [
        Text( title, style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 16 ), ),
        Text( value, style: const TextStyle( fontWeight: FontWeight.w500, fontSize: 16 ), ),
      ],
    );
  }
}