import 'dart:developer';

import 'package:flutter/material.dart';


class EcgGrap extends StatelessWidget {

  const EcgGrap({Key? key, required this.graphData, this.sizeY}) : super(key: key);
  final List<double> graphData;
  final double? sizeY;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            CustomPaint(
              painter: PaintGraph( graph: graphData ),
              size: Size( sizeY ?? 3000 , 200 ),
            ),
          ],
        ),
      ),
    );
  }
}


class PaintGraph extends CustomPainter{

  PaintGraph( {required this.graph} );

  final List<double> graph;

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
      path.lineTo(x, ((coord * 90)- ( 2* (coord*90) )) + size.height/2 );
      x = x + 0.3;
    }

    final paint2 = Paint();
    paint2.color = Colors.pink.shade100;
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