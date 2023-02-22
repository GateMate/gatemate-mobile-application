import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinInformation {
  LatLng location;
  String locationName;
  Color labelColor;

  PinInformation(
      {required this.location,
      required this.locationName,
      required this.labelColor});
}
