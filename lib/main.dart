import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/action_center_view_model.dart';
import 'package:gatemate_mobile/view/home/home.dart';
import 'package:get_it/get_it.dart';

void main() {
  // Register singleton classes for entire application
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<ActionCenterViewModel>(
    () => ActionCenterViewModel(),
  );

  // Start app
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
      // home: const LoginPage(),
      home: const HomePage(title: appTitle),
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
