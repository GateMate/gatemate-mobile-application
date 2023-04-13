import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int markerId = 0;

class GateManagementViewModel extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  List<Marker> markers = [];
  var gateHeight = 0.0;
  var idToUpdate = "";
  FieldsViewModel _fieldsViewModel = FieldsViewModel();
  var field = "";
  var gateDocId = "";

  void setGateHeight(
      String latitude, String longitude, String gateHeight) async {
    getGateID(latitude, longitude);
    await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/setGateHeight'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{"height": gateHeight, "gateID": gateDocId}));
  }

  updatePosition(String latitude, String longitude) async {
    getGateID(latitude, longitude);
    await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/adjustGateLocation'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "gateID": gateDocId,
          "location": "${latitude}|${longitude}"
        }));
  }

  getGateID(String latitude, String longitude) async {
    var gateData = await http
        .get(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getGates'))
        .then((value) => (jsonDecode(value.body) as Map).map((key, value) =>
            MapEntry(key as String, value as Map<String, dynamic>)));
    for (var gateID in gateData.entries) {
      if (gateID.value['lat'].toString() == latitude &&
          gateID.value['long'].toString() == longitude) {
        gateDocId = gateID.key;
      }
    }
  }

  getGateHeight(String latitude, String longitude) async {
    var height = "";
    var gateData = await http
        .get(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getGates'))
        .then((value) => (jsonDecode(value.body) as Map).map((key, value) =>
            MapEntry(key as String, value as Map<String, dynamic>)));

    for (var gateID in gateData.entries) {
      if (gateID.value['lat'].toString() == latitude &&
          gateID.value['long'].toString() == longitude) {
        print((gateID.value['height']).toString());
        return ((gateID.value['height']).toString());
      }
    }

    return height;
  }

  updateHeight() async {
    var gateData = await http
        .get(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getGates'));

    var jsonDecoder = (jsonDecode(gateData.body) as Map).map(
        (key, value) => MapEntry(key as String, value as Map<String, dynamic>));
    // print(jsonDecoder);
  }

  getGates() async {
    // markers.clear();
    field = _fieldsViewModel.currentFieldSelection;

    //need to get the field so we can get gates from the given field
    // var fieldData = await http.post(
    //     Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getField'),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(<String, String>{"fieldID": "NrxKA24m0xQ4w5GptET2"}));

    // var fields = (jsonDecode(fieldData.body) as Map)
    //     .map((key, value) => MapEntry(key as String, value as List<dynamic>));

    // print(fields);

    var gateData = await http
        .get(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getGates'));

    Map<String, dynamic> data = jsonDecode(gateData.body);
    // print(data);

    for (var g in data.entries) {
      // print(g.value['lat']);
      //put max so that it'd stop going to oblivion
      if (markers.length < 10) {
        markers.add(Marker(
            point: LatLng(
                double.parse(g.value['lat']!), double.parse(g.value['long']!)),
            builder: (_) =>
                const Icon(Icons.roller_shades_outlined, size: 25)));
      }
    }
    // print(markers.length);
    return markers;
  }
}
