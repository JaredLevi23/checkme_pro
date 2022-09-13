import 'package:flutter/material.dart';

ThemeData themeData(){
  return ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.cyan,
      elevation: 0
    )
  );
}