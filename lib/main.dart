import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gatemate_mobile/model/firebase/gatemate_auth.dart';
import 'package:gatemate_mobile/model/viewmodels/action_center_view_model.dart';
import 'package:gatemate_mobile/view/home/home.dart';
import 'package:get_it/get_it.dart';
import 'package:workmanager/workmanager.dart';

import 'model/alerts_fetcher.dart';
import 'model/firebase/firebase_options.dart';

void main() async {
  // Initialize Firebase settings
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register singleton classes for entire application
  final getIt = GetIt.instance;
  getIt.registerSingleton(GateMateAuth());
  getIt.registerLazySingleton<ActionCenterViewModel>(
    () => ActionCenterViewModel(),
  );

  // flutter_local_notifications initialization
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // TODO: 'app_icon' needs to be added as a drawable
  // resource to the Android head project?
  const initializationSettingsAndroid =
      AndroidInitializationSettings('gatemate_temp_app_icon');
  // TODO: This may be necessary for iOS functionality
  // https://pub.dev/packages/flutter_local_notifications#initialisation
  // final initializeSettingsDarwin = DarwinInitializationSettings(
  //   onDidReceiveLocalNotification: ,
  // )
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

  // TODO: Setup for iOS use of Workmanager has not been accomplished
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  
  // TODO: Move task registration to FieldViewModel initialization;
  //       register a task for EACH field.
  // TODO: Cancel tasks upon signout (or check for credentials?)

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
      home: const HomeView(),
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
