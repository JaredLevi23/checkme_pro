import 'package:flutter/material.dart';

class CheckmeOption extends StatelessWidget {
  const CheckmeOption({Key? key, required this.titleOption, required this.iconData, required this.onPressed}) : super(key: key);

  final String titleOption;
  final IconData iconData;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( left: 15, right: 15, top: 7, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        //border: Border.all( color: Colors.blue, width: 2 ),
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
              Icon( iconData, size: 50, color: const Color.fromRGBO(10, 72, 113, 1),),
              const SizedBox(width: 10,),
              Text( titleOption , style: const TextStyle( fontSize: 21, color: Colors.black, fontWeight: FontWeight.bold ),),
              const Spacer(),
              const Icon(
                Icons.add_box_rounded,
                color: Colors.green,
                size: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}