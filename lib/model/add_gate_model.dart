import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

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

  // void addGate() async {
  //   var field = await http.get(
  //     Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getField'),
  //   );

  //   var body = jsonDecode(field.body);

  //   var fieldID = body['success'];

  //   // print(fieldID);
  // }

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
