import 'package:flutter/material.dart';

class AppTheme {
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMediumSmall = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingHuge = 32.0;

  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
  );
  
  static TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w100, color: Colors.black),
    labelLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
    labelMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
    labelSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
    
  ); 
}
