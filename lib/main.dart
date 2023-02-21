import 'package:flutter/material.dart';
import 'package:gatemate_mobile/home/home.dart';
import 'package:gatemate_mobile/login/login.dart';
import 'package:gatemate_mobile/model/fields_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'action_center/action_center_view.dart' show ActionCenterRoute;
import 'add_gate/add_gate_view.dart' show AddGateRoute;
import 'gate_management/gate_management.dart' show GateManagementRoute;
import 'settings/settings_view.dart' show SettingsRoute;

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
