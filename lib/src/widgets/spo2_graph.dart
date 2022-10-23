// Spo2 Graph 

import 'package:flutter/material.dart';

class Spo2Graph extends StatelessWidget {
  const Spo2Graph({Key? key, required this.spoList}) : super(key: key);

  final List spoList;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all( color: const Color.fromRGBO(203, 232, 250, 1), width: 2 ),
                color: Colors.white
              ),
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                painter: _GraphGridSp(),
              )
            ),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomPaint(
                      painter: Spo2GraphPainter(spo2List: spoList ),
                      size: Size( spoList.length.toDouble() , double.infinity ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class Spo2GraphPainter extends CustomPainter{

  final List spo2List;
  Spo2GraphPainter( { required this.spo2List } );

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint();
    paint.color = Colors.red;
    paint.strokeWidth = 1.2;
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


class _GraphGridSp extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = const Color.fromRGBO(203, 232, 250, 1);
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