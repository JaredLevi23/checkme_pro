import 'package:flutter/material.dart';

ThemeData themeData(){
  return ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
          color: Color.fromRGBO(50, 97, 148, 1),
          size: 30
        ),
    )
  );
}