import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    // Define light theme settings
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      primaryColor: Color(0xFF9C27B0), // Light Purple
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Roboto', // Example font
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: Color(0xFF9C27B0), // Light Purple
      ),
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 22.0, color: Color(0xFF9C27B0)),
        bodyText1: TextStyle(fontSize: 14.0, color: Colors.black),
      ),
      // Any other custom theme settings
    );
  }

  // Optionally, define dark theme settings as well
  static ThemeData get darkTheme {
    // Define dark theme settings (if necessary for your app)
    return ThemeData(
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.black,
      // Add other customizations for the dark theme
    );
  }
}
