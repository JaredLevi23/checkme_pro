import 'dart:io';

import 'package:flutter/material.dart';


class EcgGrap extends StatelessWidget {

  const EcgGrap({Key? key, required this.graphData, this.sizeY}) : super(key: key);
  final List graphData;
  final double? sizeY;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all( 4 ),
      //height: MediaQuery.of(context).size.height * 0.63,
      height: 240,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.circular(15),
        border: Border.all( width: 2, color: const Color.fromRGBO(203, 232, 250, 1) )
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            CustomPaint(
              painter: PaintGraph( graph: graphData ),
              size: Size( sizeY ?? 3000 , 220 ),
            ),
          ],
        ),
      ),
    );
  }
}


class PaintGraph extends CustomPainter{

  PaintGraph( {required this.graph} );

  final List graph;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.red;
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height/2);

    double x = 0;

    for (var coord in graph) {
      Platform.isIOS
      ? path.lineTo(x, ((coord * 90) - ( 2* (coord*90) )) + size.height/2 )
      : path.lineTo(x, size.height/2 + ((coord/8) * -1 ) );
      x = x + 0.3;
    }

    final paint2 = Paint();
    paint2.color = const Color.fromRGBO(203, 232, 250, 1);
    paint2.strokeWidth = 0.5; 
    paint2.style = PaintingStyle.stroke;

    final path2 = Path();
    path2.moveTo(0, 0);

    for (double i = 0; i< size.height; i+=9 ) {
       path2.lineTo( size.width , i );
       path2.moveTo( 0, i + 9 );
    }

    path2.moveTo(0, 0);

    for (double i = 0; i< size.width; i+=9 ) {
       path2.lineTo( i , size.height );
       path2.moveTo( i + 9 , 0 );
    }

    canvas.drawPath(path2, paint2);
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}