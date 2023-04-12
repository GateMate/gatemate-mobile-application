import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

int markerId = 0;

class GateManagementViewModel extends ChangeNotifier {
  // int markerId = 0;

  List<Marker> markers = [
    Marker(
      point: LatLng(36.07, -94.174),
      builder: (_) =>
          // IconButton(
          //     onPressed: () {
          //       print('tapped');
          //     },
          //     icon: Icon(Icons.roller_shades_outlined, size: 25))
          const Icon(Icons.roller_shades_outlined, size: 25),
    ),
    Marker(
        point: LatLng(36.3, -94.3),
        builder: (_) => const Icon(Icons.roller_shades_outlined, size: 25)),
    Marker(
        point: LatLng(36.1, -94.2),
        builder: (_) => const Icon(Icons.roller_shades_outlined, size: 25))
  ];

  // String snippetMessage(LatLng latLng) {
  //   var elevation = fetchElevation(latLng);
  //   return 'Location: {$latLng}, Elevation: ${elevation}';
  // }

  // Future<http.Response> fetchElevation(LatLng latLng) {
  //   return http.get(Uri.parse(
  //       'https://api.open-elevation.com/api/v1/lookup?locations=$latLng'));
  // }
}
