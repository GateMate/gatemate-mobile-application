import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gatemate_mobile/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // If returns false, Android tries again automatically.
    // TODO: iOS needs to be scheduled manually.
    // TODO: Configure BackoffPolicy for Android
    // https://pub.dev/packages/workmanager#work-result

    try {
      // Used to keep notification ID's unique
      // TODO: Update value in shared preferences
      final sharedPreferences = await SharedPreferences.getInstance();
      final lastNotificationId = sharedPreferences.getInt('lastNotificationId');
      final notificationId =
          lastNotificationId == null ? 0 : lastNotificationId + 1;

      // Request weather info from server
      // TODO: Will likely have to pass lat/long in task parameters.
      //  Is this a privacy issue? Could alternatively provide field
      //  identifier and fetch coords remotely.
      const url = '${AppConstants.serverUrl}/weather_forecast/8.0/170.1';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonBody = jsonDecode(response.body);

        // Parse the list of precipitation amounts
        List rawPrecipitation = jsonBody['precipitation_hourly'];
        var hourlyPrecipitation = rawPrecipitation.cast<double>();

        // Parse the list of instances in time for which there's a forecast
        List rawTimes = jsonBody['timedate_hourly'];
        var forecastTimes = rawTimes.cast<String>();

        // Check data returned from server
        if (hourlyPrecipitation.length != forecastTimes.length) {
          throw Exception(
            'Invalid response from server! Returned ${forecastTimes.length} '
            'forecast times, but ${hourlyPrecipitation.length} rain amounts.',
          );
        }

        // Check for rain over threshold
        for (var i = 0; i < forecastTimes.length; i++) {
          Logger().d('Rainfall: ${hourlyPrecipitation[i]}');
          // TODO Potential preference change: rain threshold amount
          if (hourlyPrecipitation[i] >= AppConstants.rainAlertThreshold) {
            Logger().i('Threshold met!');

            const androidNotificationDetails = AndroidNotificationDetails(
              AppConstants.domain,
              'GateMate Weather Alert',
              importance: Importance.high,
              priority: Priority.high,
              ticker: 'GateMate Weather Alert',
            );

            // TODO: iOS support
            const notificationDetails = NotificationDetails(
              android: androidNotificationDetails,
            );

            FlutterLocalNotificationsPlugin().show(
              notificationId,
              'GateMate Weather Alert',
              // TODO: Include time of rain
              'Significant rainfall in forecast: ${hourlyPrecipitation[i]}',
              notificationDetails,
            );

            break;
          }
        }
      } else {
        throw Exception('Failed to fetch weather data!'
            'Response status code: ${response.statusCode}');
      }
    } catch (error) {
      Logger().e(error.toString());
      throw Exception(error);
    }

    return Future.value(true);
  });
}
