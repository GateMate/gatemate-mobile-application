import 'package:gatemate_mobile/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

// TODO: Figure out where this should go
/// Background process that periodically requests weather data from the server
/// and displays a notification if rain amount reaches threshold.

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // If returns false, Android tries again automatically.
    // TODO: iOS needs to be scheduled manually.
    // TODO: Configure BackoffPolicy for Android
    // https://pub.dev/packages/workmanager#work-result

    try {
      // Used to keep notification ID's unique
      final sharedPreferences = await SharedPreferences.getInstance();
      final lastNotificationId = sharedPreferences.getInt('lastNotificationId');
      final notificationId =
          lastNotificationId == null ? 0 : lastNotificationId + 1;

      // Request weather info from server
      const url = '${AppConstants.serverUrl}/weather_forecast/38.94/-14.86';
      final response = await http.get(Uri.parse(url));
      Logger().d(response.body);
    } catch (error) {
      Logger().e(error.toString());
      throw Exception(error);
    }

    return Future.value(true);
  });
}
