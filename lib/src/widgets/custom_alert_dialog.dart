import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({Key? key, required this.message, required this.iconData}) : super(key: key);

  final String message;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric( horizontal: 20 ),
        width: 200,
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon( iconData, size: 50, color: const Color.fromRGBO(50, 97, 148, 1),),
              const SizedBox(
                height: 10,
              ),
              Text( message , textAlign: TextAlign.center, style: const TextStyle( fontSize: 14 ),),
            ],
          ),
        ),
      ),
    );
  }
}