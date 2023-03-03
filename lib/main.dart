import 'package:flutter/material.dart';
import 'package:gatemate_mobile/home/home.dart';

import 'login/login.dart';

void main() {
  runApp(const GateMateApp());
}

class GateMateApp extends StatelessWidget {
  const GateMateApp({super.key});
  static const appTitle = 'GateMate App';

  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.green[400] ?? Colors.green,
    );
    return MaterialApp(
      title: appTitle,
      home: const LoginPage(),
      // home: const HomePage(title: appTitle),
      theme: ThemeData(
        colorScheme: colorScheme,
        cardTheme: CardTheme(
          color: Colors.lightBlueAccent[100],
          elevation: 2,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.tertiary,
        ),
        backgroundColor: colorScheme.secondaryContainer,
        scaffoldBackgroundColor: colorScheme.secondaryContainer,
      ),
    );
  }
}
