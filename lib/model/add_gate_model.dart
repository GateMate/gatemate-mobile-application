import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

int markerId = 0;

class AddGateModel extends ChangeNotifier {
  // int markerId = 0;
  Set<Marker> markers = {};

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
