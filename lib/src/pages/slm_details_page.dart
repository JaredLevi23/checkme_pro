import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        body: Column(
          children: [

            // Detalles
            Text( getMeasurementDateTime(measurementDate: currentSlm.dtcDate).toString().split('.')[0] ) ,

            const Text('PR/min'),
            SizedBox(
              height:  MediaQuery.of(context).size.height * 0.3,
              child: PrGraph(prList: currentDetailsSlm?.arrPrValue ?? [])
            ),

            const Text('Spo2/min'),
            SizedBox(
              height:  MediaQuery.of(context).size.height * 0.3,
                child: Spo2Graph(spoList: currentDetailsSlm?.arrOxValue ?? [])
            )
            

          ],
        ),
      ),
    );
  }
}