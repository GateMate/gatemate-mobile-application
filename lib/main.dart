import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gatemate_mobile/model/firebase/gatemate_auth.dart';
import 'package:gatemate_mobile/model/viewmodels/action_center_view_model.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:gatemate_mobile/model/viewmodels/gate_management_view_model.dart';
import 'package:gatemate_mobile/view/login/login.dart';
import 'package:get_it/get_it.dart';
import 'package:workmanager/workmanager.dart';

import 'model/weather_notifier.dart';
import 'model/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _initializeNotificationsPlugin();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register singleton classes using GetIt for entire application
  GetIt.I.registerSingleton(GateMateAuth());
  _registerViewmodels();

  // TODO: Setup for iOS use of Workmanager has not been accomplished
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  // TODO: Cancel tasks upon signout

  // Start app
  runApp(const GateMateApp());
}

class GateMateApp extends StatelessWidget {
  const GateMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.green[400] ?? Colors.green,
    );

    return MaterialApp(
      title: 'GateMate App',
      home: const LoginView(),
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

/// Should be called after sign out. Resets persistent data in viewmodels.
void resetAppData() {
  _resetViewmodels();
}

/// Registers business (non-authentication) viewmodels using GetIt.
/// Viewmodels registered here should be reset upon signing out.
void _registerViewmodels() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<ActionCenterViewModel>(
    () => ActionCenterViewModel(),
  );
  getIt.registerLazySingleton<FieldsViewModel>(
    () => FieldsViewModel(),
  );
  getIt.registerLazySingleton<GateManagementViewModel>(
    () => GateManagementViewModel(),
  );
}

/// Resets business (non-authentication) viewmodels using GetIt.
/// Should reset every viewmodel registered in `registerViewmodels`.
void _resetViewmodels() {
  final getIt = GetIt.instance;

  getIt.resetLazySingleton<ActionCenterViewModel>();
  getIt.resetLazySingleton<FieldsViewModel>();
  getIt.resetLazySingleton<GateManagementViewModel>();
}

/// Initializes the plugin used for push notifications.
/// Plugin: `flutter_local_notifications`
///
/// TODO: Set up iOS and macOS settings
void _initializeNotificationsPlugin() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // TODO: 'app_icon' needs to be added as a drawable
  // resource to the Android head project?

  const initializationSettingsAndroid = AndroidInitializationSettings(
    'gatemate_temp_app_icon',
  );

  // TODO: This may be necessary for iOS functionality
  // https://pub.dev/packages/flutter_local_notifications#initialisation
  // final initializeSettingsDarwin = DarwinInitializationSettings(
  //   onDidReceiveLocalNotification: ,
  // );

  const initializationSettingsLinux = LinuxInitializationSettings(
    defaultActionName: 'Open notification', // TODO: May want to change?
  );

  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: initializationSettingsDarwin,   // TODO
    // macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onDidReceiveBackgroundNotificationResponse: ,
  );

  // TODO: Request notification permissions (iOS)
}
