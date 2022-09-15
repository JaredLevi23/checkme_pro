import 'dart:developer';

import 'package:flutter/material.dart';


class EcgGrap extends StatelessWidget {

  const EcgGrap({Key? key, required this.graphData}) : super(key: key);
  final List<double> graphData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.indigo,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: CustomPaint(
          painter: PaintGraph( graph: graphData ),
          size: Size(200, 200 ),
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
    log( '${size.width}' );
    final paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height/2);

    double x = 0;

    for (var coord in graph) {
      path.lineTo(x, coord);
      x++;
    }

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}