import 'package:flutter/material.dart';

class PrGraph extends StatelessWidget {
  const PrGraph({Key? key, required this.prList }) : super(key: key);

  final List prList;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                CustomPaint(
                  painter: PrGraphPainter(prList: prList ),
                  size: const Size( 1500, double.infinity ),
                ),
              ],
            ),
          )
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




class PrGraphPainter extends CustomPainter{

  final List prList;
  PrGraphPainter ({ required this.prList });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 1;
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
