import 'package:flutter/material.dart';

ThemeData themeData(){
  return ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      elevation: 0
    )
  );
}