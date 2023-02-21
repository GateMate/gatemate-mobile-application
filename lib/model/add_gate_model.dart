import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

int markerId = 0;

class AddGateModel extends ChangeNotifier {
  // int markerId = 0;
  List<Marker> markers = [
    Marker(
        point: LatLng(36.07, -94.174),
        builder: (_) => const Icon(Icons.roller_shades_outlined, size: 25)),
    Marker(
        point: LatLng(36.3, -94.3),
        builder: (_) => const Icon(Icons.roller_shades_outlined, size: 25)),
    Marker(
        point: LatLng(36.1, -94.2),
        builder: (_) => const Icon(Icons.roller_shades_outlined, size: 25))
  ];

  setMarkers(Marker m) {
    this.markers.add(m);
    notifyListeners();
    print('markers: ${this.markers}');
  }

  getMarkers() {
    print('markers: ${this.markers}');
    return this.markers;
  }

  // Marker(
  //   markerId: MarkerId('$markerId'),
  //   position:
  //
  // var fieldNamesPlaceholder = {'Field 1', 'Field B', 'Field of Real Numbers'};
  // void addField(String fieldName) {
  //   fieldNamesPlaceholder.add(fieldName);
  //   notifyListeners();
  // }

  // var currentFieldSelection = 'Field 1';
  // void selectField(String fieldName) {
  //   if (fieldNamesPlaceholder.contains(fieldName)) {
  //     currentFieldSelection = fieldName;
  //     notifyListeners();
  //   }
  // }
}
