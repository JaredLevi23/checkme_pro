import 'package:flutter/material.dart';

class SyncButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;

  const SyncButton({
    Key? key,
    required this.title,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 15, vertical: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: MaterialButton(
        height: 60,
        elevation: 0,
        color: const Color.fromRGBO(31, 202, 181, 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Text( title, style: TextStyle( fontSize: 18, color: Colors.white),),
        onPressed: onPressed
      ),
    );
  }
}