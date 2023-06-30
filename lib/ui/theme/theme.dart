import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData stagingTheme = ThemeData(
    primarySwatch: Colors.green,
    // Add flavor-specific theme properties for staging flavor
  );

  static final ThemeData productionTheme = ThemeData(
    primarySwatch: Colors.blue,
    // Add flavor-specific theme properties for production flavor
  );

  static final ThemeData developmentTheme = ThemeData(
    primarySwatch: Colors.red,
    // Add flavor-specific theme properties for production flavor
  );
}
