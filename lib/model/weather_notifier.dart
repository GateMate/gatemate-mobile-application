import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gatemate_mobile/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

// TODO: There is currently an open issue with the http package that is
//  causing issues in the below (commented out) WeatherNotifier class.
//  Reverting to a much less clean implementation as a work around.

/// Background process that monitors forecasted rainfall amounts by
/// querying the application server.
/*
class WeatherNotifier {
  final double fieldLatitude;
  final double fieldLongitude;
  static const urlPrefix = '${AppConstants.serverUrl}/weather_forecast';

  const WeatherNotifier({
    required this.fieldLatitude,
    required this.fieldLongitude,
  });

  void execute() async {
    final fieldParamsException = _validateFieldParams();
    if (fieldParamsException != null) {
      throw fieldParamsException;
    }

    final notificationId = await _getNotificationId();
    Logger().d('Notification ID is $notificationId.');

    final response = await _fetchWeatherData();
    Logger().d('Response code: ${response.statusCode}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = jsonDecode(response.body);

      // Parse the list of precipitation amounts
      List rawPrecipitation = jsonBody['precipitation_hourly'];
      var hourlyPrecipitation = rawPrecipitation.cast<double>();

      // Parse the list of instances in time for which there's a forecast
      List rawTimes = jsonBody['timedate_hourly'];
      var forecastTimes = rawTimes.cast<String>();

      Logger().i('Checking data returned from server...');

      // Check data returned from server
      if (hourlyPrecipitation.length != forecastTimes.length) {
        throw Exception(
          'Invalid response from server! Returned ${forecastTimes.length} '
          'forecast times, but ${hourlyPrecipitation.length} rain amounts.',
        );
      }

      Logger().i('Checking for rain over threshold...');

      // Check for rain over threshold
      for (var i = 0; i < forecastTimes.length; i++) {
        // TODO Potential preference change: rain threshold amount
        if (hourlyPrecipitation[i] >= AppConstants.rainAlertThreshold) {
          Logger().i(
            'Severe weather! Rain: ${hourlyPrecipitation[i]}',
          );
        } else {
          Logger().d('It's ok: ${hourlyPrecipitation[i]}');
        }
      }
    } else {
      throw Exception(
        'Failed to fetch weather data!'
        'Response status code: ${response.statusCode}',
      );
    }
  }

  /// Checks field location validity.
  Exception? _validateFieldParams() {
    Logger().i('Validating params...');
    if (fieldLatitude < -90.0 || fieldLatitude > 90) {
      return Exception('Invalid field latitude! Value: $fieldLatitude');
    }
    if (fieldLongitude < -180 || fieldLongitude > 180) {
      return Exception('Invalid field longitude! Value: $fieldLongitude');
    }

    Logger().i('Params validated!');

    return null;
  }

  /// Gets unique notification id
  Future<int> _getNotificationId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final lastNotificationId = sharedPreferences.getInt('lastNotificationId');
    // TODO: Update shared preferences instance
    return lastNotificationId == null ? 0 : lastNotificationId + 1;
  }

  /// Fetch weather data from application server
  Future<http.Response> _fetchWeatherData() async {
    var uri = '${WeatherNotifier.urlPrefix}/$fieldLatitude/$fieldLongitude';
    Logger().i('URL: $uri');

    try {
      var response = http.get(Uri.parse(
        uri,
      ));

      // Logger().d('Response code: ${response.statusCode}');
      // Logger().d('Response body: ${response.body}');
      Logger().i('http.get has supposedly happened...');

      return response;
    } catch (error) {
      Logger().e(error.toString());
      throw Exception(error);
    }
  }
}
*/

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

    // TODO: Will likely have to pass lat/long in task parameters.
    //  Is this a privacy issue? Could alternatively provide field
    //  identifier and fetch coords remotely.
    // TODO: This is the driver portion of the code that is affected
    //  by the http package issue.
    // const notifier = WeatherNotifier(
    //   fieldLatitude: 84.1,
    //   fieldLongitude: 172.45,
    // );

    // try {
    //   Logger().i('Executing notifier...');
    //   notifier.execute();
    //   Logger().i('Notifier executed!');
    // } catch (error) {
    //   Logger().e(error.toString());
    //   throw Exception(error);
    // }

    return Future.value(true);
  });
}
