// Checkme Pro Option 

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckmeOption extends StatelessWidget {
  const CheckmeOption({Key? key, required this.title, required this.assetSVG, required this.onPressed}) : super(key: key);

  final String title;
  final String assetSVG;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( left: 15, right: 15, top: 10, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          height: 85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 60,
                child: SvgPicture.asset( 
                  assetSVG,
                  width: 50,
                  height: 50,
                ),
              ),
              const SizedBox(width: 10,),
              Text( title , style: const TextStyle( fontSize: 21, color: Colors.black87, fontWeight: FontWeight.bold ),),
              const Spacer(),
              Container(
                width: 45,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green,
                ),
                child: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                  size: 28,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}