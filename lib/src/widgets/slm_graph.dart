import 'dart:developer';
import 'dart:io';

import 'package:checkme_pro_develop/src/models/models.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/utils/utils_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SlmGraph extends StatelessWidget {
  const SlmGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final checkmeProvider = Provider.of<CheckmeChannelProvider>(context);
    final currentSlm = checkmeProvider.currentSlm;
    //SlmDetailsModel? currentSlmDetails = checkmeProvider.slmDetailsList[ currentSlm.dtcDate ];

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric( horizontal: 15 ),
          width: double.infinity,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SPO2'),
              Platform.isIOS 
              ? Text( '${getMeasurementDateTime(measurementDate: currentSlm.dtcDate)}' )
              : Text( currentSlm.dtcDate)
            ],
          )
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric( horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all( color: Colors.red.shade300, width: 2 )
                ),
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: _GraphGridSp(),
                )
              ),
              Container(
                margin: const EdgeInsets.symmetric( horizontal: 15),
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // CustomPaint(
                      //   painter: Spo2Graph(spo2List:currentSlmDetails?.arrOxValue ?? []),
                      //   size: const Size( 1500, double.infinity ),
                      // ),
                    ],
                  ),
                )
              ),
            ],
          )
        ),
        const SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text('PR /min'),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric( horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all( color: Colors.red.shade300, width: 2 )
                ),
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: _GraphGridPr(),
                )
              ),
              Container(
                margin: const EdgeInsets.symmetric( horizontal: 15),
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // CustomPaint(
                      //   painter: PrGraph(prList:currentSlmDetails?.arrPrValue ?? []),
                      //   size: const Size( 1500, double.infinity ),
                      // ),
                    ],
                  ),
                )
              ),
            ],
          )
        ),
        Container(
          width: double.infinity,
          height: 50,
        ),
      ],
    );
  }
}

class _GraphGridPr extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.pink.shade100;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, 0);
    
    for (double i = 0; i< size.height; i+=10 ) {
       path.lineTo( size.width, i );
       path.moveTo( 0 , i + 10 );
    }

     path.moveTo(0, 0);

    for (double i = 0; i< size.width; i+=10) {
       path.lineTo( i , size.height);
       path.moveTo( i + 10 , 0 );
    }

    double val = 180;
    for (double i = 0; i < size.height; i+=20) {
      final textSpan = TextSpan(
        text: val.toStringAsFixed(0),
        style: const TextStyle(
          fontSize: 6,
          color: Colors.blue
        )
       );

       final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr
       );
       val -= 10;
       textPainter.layout();
       textPainter.paint(canvas, Offset( 0, i ));
    }    
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class _GraphGridSp extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.pink.shade100;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;

    final path = Path();
    
    
    for (double i = 0; i< size.height; i+=10 ) {
       path.lineTo( size.width, i );
       path.moveTo( 0 , i + 10 );
    }

     path.moveTo(0, 0);

    for (double i = 0; i< size.width; i+=10) {
       path.lineTo( i , size.height);
       path.moveTo( i + 10 , 0 );
    }

    double val = 100;
    for (double i = 0; i < size.height; i+=20) {
      final textSpan = TextSpan(
        text: '${val.toStringAsFixed(0)}%',
        style: const TextStyle(
          fontSize: 6,
          color: Colors.blue
        )
       );

       final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr
       );
       val -= 5;
       textPainter.layout();
       textPainter.paint(canvas, Offset( 0, i ));
    }    
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class Spo2Graph extends CustomPainter{

  final List<int> spo2List;
  Spo2Graph( { required this.spo2List } );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo( 20 , 20);

    double x = 20;

    for (var coord in spo2List ) {
      path.lineTo( x , (100.0 - coord) * 4 );
      x+= 0.5;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PrGraph extends CustomPainter{

  final List<int> prList;
  PrGraph({ required this.prList });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo( 20 , (180.0 - prList[0]) * 2 );

    double x = 20;

    for (var coord in prList ) {
      path.lineTo( x , (180 - coord) * 2 );
      x+= 1;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
