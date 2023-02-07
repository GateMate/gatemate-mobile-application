import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

int markerId = 0;

class GateManagementViewModel extends ChangeNotifier {
  // int markerId = 0;
  Set<Marker> markers = {
    Marker(
        markerId: MarkerId('$markerId'),
        position: LatLng(36.07, -94.174),
        infoWindow: InfoWindow(
            title: 'Gate Information', snippet: 'Location: 36.07, -94.174')),
    Marker(
        markerId: MarkerId('$markerId'),
        position: LatLng(36.3, -94.3),
        infoWindow: InfoWindow(
            title: 'Gate Information', snippet: 'Location: 36.3, -94.3')),
    Marker(
        markerId: MarkerId('$markerId'),
        position: LatLng(36.1, -94.2),
        infoWindow: InfoWindow(
          title: 'Gate Information',
          snippet: 'Location: 36.1, -94.2',
        ))
  };
}
