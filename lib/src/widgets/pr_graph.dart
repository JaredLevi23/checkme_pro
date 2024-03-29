// PR Graph 

import 'package:flutter/material.dart';

class PrGraph extends StatelessWidget {
  const PrGraph({Key? key, required this.prList }) : super(key: key);

  final List prList;

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
                painter: _GraphGridPr(),
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
                      painter: PrGraphPainter(prList: prList ),
                      size: Size( prList.length.toDouble(), double.infinity ),
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


class _GraphGridPr extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = const Color.fromRGBO(203, 232, 250, 1);
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




class PrGraphPainter extends CustomPainter{

  final List prList;
  PrGraphPainter ({ required this.prList });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.red;
    paint.strokeWidth = 1.2;
    paint.style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo( 20 , size.height/2 );

    double x = 20;

    for (var coord in prList ) {
      path.lineTo( x , (180 - coord) * 2 );
      x+= 0.5;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
