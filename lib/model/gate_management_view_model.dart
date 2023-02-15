import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:http/http.dart' as http;

int markerId = 0;

class GateManagementViewModel extends ChangeNotifier {
  // int markerId = 0;

  Set<Marker> markers = {
    Marker(
        markerId: MarkerId('$markerId'),
        position: LatLng(36.07, -94.174),
        infoWindow: InfoWindow(
            title: 'Gate Information',
            snippet: 'Location: 36.07, -94.174 Elevation: 451')),
    Marker(
        markerId: MarkerId('$markerId'),
        position: LatLng(36.3, -94.3),
        infoWindow: InfoWindow(
            title: 'Gate Information',
            snippet: 'Location: 36.3, -94.3, Elevation: 379')),
    Marker(
        markerId: MarkerId('$markerId'),
        position: LatLng(36.1, -94.2),
        infoWindow: InfoWindow(
            title: 'Gate Information',
            snippet: 'Location: 36.1, -94.2, Elevation: 367')),
  };

  // String snippetMessage(LatLng latLng) {
  //   var elevation = fetchElevation(latLng);
  //   return 'Location: {$latLng}, Elevation: ${elevation}';
  // }

  // Future<http.Response> fetchElevation(LatLng latLng) {
  //   return http.get(Uri.parse(
  //       'https://api.open-elevation.com/api/v1/lookup?locations=$latLng'));
  // }
}
