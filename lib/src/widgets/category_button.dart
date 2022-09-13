import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {

  final IconData iconData;
  final Function()? onPressed;
  final String title;

  const CategoryButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( top: 10, bottom: 5),
      child: MaterialButton(
        height: 145,
        minWidth: 145,
        elevation: 0,
        onPressed: onPressed,
        shape: const CircleBorder(),
        color: Colors.cyan,
        child: Column(
          children: [
            Icon( iconData , color: Colors.white, size: 40,),
            Text( title, style: TextStyle( fontSize: 15, color: Colors.white),)
          ],
        ),
      ),
    );
  }
}