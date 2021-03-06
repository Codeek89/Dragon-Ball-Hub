import 'package:flutter/material.dart';

ThemeData myAppTheme = buildTheme();

ThemeData buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      primaryColor: const Color(0xFFFF7D45),
      primaryColorDark: Colors.orangeAccent,
      hintColor: Colors.grey,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white
      )
  );
}