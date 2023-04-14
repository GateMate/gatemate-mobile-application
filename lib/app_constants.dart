import 'package:latlong2/latlong.dart';

class AppConstants {
  // App prefix/domain (helpful for creating unique task names)
  static const domain = 'edu.uark.csce.gatemate';

  static const mapBoxAccessToken =
      'pk.eyJ1IjoiY3BhdHRvbiIsImEiOiJjbGRodG1pZ3kweWFyM3ZvM2trcjY5d3liIn0.Th1u92jVxkdhJp1-pcJpdA';

  // static const mapBoxStyleId = 'cldievrq0000301o10nbx1zvu';
  static const mapBoxStyleId = 'cldievrq0000301o10nbx1zvu';

  static final myLocation = LatLng(36.0831986, -94.2166087);

  // URL of web server
  static const serverUrl = 'https://todo-proukhgi3a-uc.a.run.app';
  // TODO: Remove this (for debugging only)
  // static const serverUrl = 'http://10.55.161.169:8080';

  // Rain alert threshold (in inches)
  // TODO: Maybe not the best place for this?
  static const rainAlertThreshold = 0.5;
}
