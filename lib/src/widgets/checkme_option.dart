import 'package:flutter/material.dart';

class CheckmeOption extends StatelessWidget {
  const CheckmeOption({Key? key, required this.titleOption, required this.iconData, required this.onPressed}) : super(key: key);

  final String titleOption;
  final IconData iconData;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( left: 15, right: 15, top: 10, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all( color: Colors.cyan, width: 2 )
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 90,
                child: Icon( iconData , size: 70, color: Colors.cyan ,),
                decoration: BoxDecoration(
                  border: Border.all( color: Colors.cyan ),
                  borderRadius: BorderRadius.circular(15)
                ),
              ),
              const SizedBox( width: 10, ),
              Text( titleOption , style: const TextStyle( fontSize: 20, color: Colors.blueGrey ),)
            ],
          ),
        ),
      ),
    );
  }
}