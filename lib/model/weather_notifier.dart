import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gatemate_mobile/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

/// Background process that monitors forecasted rainfall amounts by
/// querying the application server.
class WeatherNotifier {
  final double fieldLatitude;
  final double fieldLongitude;
  static const urlPrefix = '${AppConstants.serverUrl}/weather_forecast';

  const WeatherNotifier(
    this.fieldLatitude,
    this.fieldLongitude,
  );

  Future<bool> execute() async {
    // TODO: Just throw the exception in the method
    final fieldParamsException = _validateFieldParams();
    if (fieldParamsException != null) {
      throw fieldParamsException;
    }

    final response = await _fetchWeatherData();
    if (response.statusCode == 200) {
      // Deserialize server response
      final WeatherData weatherData;
      try {
        weatherData = WeatherData.fromJson(jsonDecode(response.body));
      } catch (error) {
        throw Exception('Invalid response from server (weather API)!\n$error');
      }
      final forecastTimes = weatherData.forecastTimes;
      final hourlyRainfall = weatherData.hourlyRainfall;

      // Check for rain over threshold
      for (var i = 0; i < forecastTimes.length; i++) {
        // TODO Potential preference change: rain threshold amount.
        //  Also, what about weak but sustained rain?
        if (hourlyRainfall[i] >= AppConstants.rainAlertThreshold) {
          _displayNotification(
            await _getNotificationId(),
            hourlyRainfall[i],
            _formatTime(forecastTimes[i]),
          );
          Logger().v('WeatherNotifer triggering amount: ${hourlyRainfall[i]}');
          break;
        }
      }
    } else {
      throw Exception(
        'Failed to fetch weather data!'
        'Response status code: ${response.statusCode}',
      );
    }

    return Future.value(true);
  }

  /// Checks field location validity. Returns an exception
  Exception? _validateFieldParams() {
    if (fieldLatitude < -90.0 || fieldLatitude > 90) {
      return Exception('Invalid field latitude! Value: $fieldLatitude');
    }
    if (fieldLongitude < -180 || fieldLongitude > 180) {
      return Exception('Invalid field longitude! Value: $fieldLongitude');
    }

    return null;
  }

  /// Gets unique notification id
  Future<int> _getNotificationId() async {
    const preferencesKey = 'lastNotificationId';
    final sharedPreferences = await SharedPreferences.getInstance();
    final lastNotificationId = sharedPreferences.getInt(preferencesKey);

    final notificationId =
        lastNotificationId == null ? 0 : lastNotificationId + 1;
    sharedPreferences.setInt(preferencesKey, notificationId);

    return notificationId;
  }

  /// Fetch weather data from application server
  Future<http.Response> _fetchWeatherData() async {
    return http.get(Uri.parse(
      '${WeatherNotifier.urlPrefix}/$fieldLatitude/$fieldLongitude',
    ));
  }

  /// Format datetime from server response for notification
  String _formatTime(String forecastTime) {
    final dateTime = DateTime.parse(forecastTime).toLocal();

    int hour;
    String modifier;
    if (dateTime.hour < 12) {
      modifier = 'AM';
      hour = (dateTime.hour == 0) ? 12 : dateTime.hour;
    } else {
      modifier = 'PM';
      hour = (dateTime.hour == 12) ? 12 : dateTime.hour % 12;
    }

    return '$hour $modifier, ${dateTime.month}/${dateTime.day}';
  }

  /// Display notification to user regarding significant forecasted rainfall
  void _displayNotification(
    int notificationId,
    double rainfall,
    String forecastTime,
  ) {
    // TODO: Include the relevant field's name
    final notificationMessage =
        'Significant rainfall in forecast! $rainfall inches at $forecastTime.';

    final androidNotificationDetails = AndroidNotificationDetails(
      AppConstants.domain,
      'GateMate Weather Alert',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'GateMate Weather Alert',
      styleInformation: BigTextStyleInformation(notificationMessage),
    );

    // TODO: iOS support
    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    FlutterLocalNotificationsPlugin().show(
      notificationId,
      'GateMate Weather Alert',
      // TODO: Include time of rain
      notificationMessage,
      notificationDetails,
    );
  }
}

/// Stores two lists:
///  - Hourly forecast times
///  - Hourly rainfall amaounts
/// Throws exception if the number of elements in each list are not equal
class WeatherData {
  final List<double> hourlyRainfall;
  List<String> forecastTimes;

  WeatherData(this.hourlyRainfall, this.forecastTimes) {
    if (hourlyRainfall.length != forecastTimes.length) {
      throw Exception(
        'Invalid weather data! Member list lengths must be equivalent. '
        'Given ${forecastTimes.length} forecast timestamps but '
        '${hourlyRainfall.length} rainfall values.',
      );
    }
  }

  /// Deserializes Map from decoded JSON and returns WeatherData instance
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final List rawRainfall = json['precipitation_hourly'];
    final hourlyRainfall = rawRainfall.cast<double>();

    final List rawTimes = json['timedate_hourly'];
    final forecastTimes = rawTimes.cast<String>();

    return WeatherData(hourlyRainfall, forecastTimes);
  }
}

/// Entry point for scheduled background tasks
/// Currently only used to check for weather updates
/// TODO: Check for gate malfunction updates
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // If returns false, Android tries again automatically.
    // TODO: iOS needs to be scheduled manually.
    // TODO: Configure BackoffPolicy for Android
    // https://pub.dev/packages/workmanager#work-result

    // TODO: Will likely have to pass lat/long in task parameters.
    //  Is this a privacy issue? Could alternatively provide field
    //  identifier and fetch coords remotely.
    const notifier = WeatherNotifier(8.0, 170.1);

    try {
      await notifier.execute();
    } catch (error) {
      Logger().e(error.toString());
      throw Exception(error);
    }

    return Future.value(true);
  });
}
