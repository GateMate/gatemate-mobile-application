// ignore_for_file: prefer_const_constructors

import 'package:gatemate_mobile/model/weather_notifier.dart';
import 'package:test/test.dart';

void main() {
  group('WeatherNotifier', () {
    test(
      'execution should throw exceptions for invalid latitude',
      () {
        final notifier = WeatherNotifier(90.1, -43.56);
        expect(() => notifier.execute(), throwsException);
      },
    );

    test(
      'execution should throw exceptions for invalid longitude',
      () {
        final notifier = WeatherNotifier(34.1235, -181.9);
        expect(() => notifier.execute(), throwsException);
      },
    );

    // TODO: Use Mockito to thoroughly test
  });
}
