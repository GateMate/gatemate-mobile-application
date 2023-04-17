import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class AddFieldModel extends ChangeNotifier {
  List<Marker> markers = [];

  setMarkers(Marker m) {
    this.markers.add(m);
    notifyListeners();
    print('markers: ${this.markers}');
  }

  deleteField(String fieldID, String token) async {
    var response = await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/deleteField'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode(<String, String>{"fieldID": "${fieldID}"}));
    print(response.body);
  }

  addToFB(Marker m, String fieldID, String token) async {
    var response = await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/addGate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode(<String, String>{
          "gateLocation": "${m.point.latitude}" + "|" + "${m.point.longitude}",
          "fieldID": "${fieldID}"
        }));

    print(response.body);
  }
}
