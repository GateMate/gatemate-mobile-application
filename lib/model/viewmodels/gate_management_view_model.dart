import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/model/firebase/gatemate_auth.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int markerId = 0;

class GateManagementViewModel extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  List<Marker> markers = [];
  var gateHeight = 0.0;
  var idToUpdate = "";
  final _fieldsViewModel = GetIt.I<FieldsViewModel>();
  var gateDocId = "";

  void setGateHeight(
    String latitude,
    String longitude,
    String gateHeight,
    String token,
  ) async {
    getGateID(latitude, longitude, token)
        .then((value) => updateHeight(latitude, longitude, gateHeight, token),);
  }

  updateHeight(
    String latitude,
    String longitude,
    String gateHeight,
    String token,
  ) async {
    await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/setGateHeight'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode(
            <String, String>{"height": gateHeight, "gateID": gateDocId}));
  }

  void setPosition(
    String latitude,
    String longitude,
    String newLat,
    String newLong,
    String token,
  ) async {
    getGateID(latitude, longitude, token)
        .then((value) => updatePosition(newLat, newLong, token));
  }

  updatePosition(String latitude, String longitude, String token) async {
    await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/adjustGateLocation'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode(<String, String>{
          "gateID": gateDocId,
          "location": "${latitude}|${longitude}",
        }));
  }

  getGateID(String latitude, String longitude, String token) async {
    var gateData = await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getGates'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode(<String, String>{"gateID": gateDocId}));
    // var gateData = await http
    //     .get(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getGates'))
    //     .then((value) => (jsonDecode(value.body) as Map).map((key, value) =>
    //         MapEntry(key as String, value as Map<String, dynamic>)));

    var jsonDecodeGates = (jsonDecode(gateData.body) as Map).map(
        (key, value) => MapEntry(key as String, value as Map<String, dynamic>));

    for (var gateID in jsonDecodeGates.entries) {
      if (gateID.value['lat'].toString() == latitude &&
          gateID.value['long'].toString() == longitude) {
        gateDocId = gateID.key;
      }
    }
    // for (var gateID in gateData.entries) {
    //   if (gateID.value['lat'].toString() == latitude &&
    //       gateID.value['long'].toString() == longitude) {
    //     gateDocId = gateID.key;
    //   }
    // }
  }

  getGateHeight(String latitude, String longitude, String token) async {
    var height = "";

    var gateData = await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getGates'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode(<String, String>{"gateID": gateDocId}));
    var jsonDecodeGates = (jsonDecode(gateData.body) as Map).map(
        (key, value) => MapEntry(key as String, value as Map<String, dynamic>));

    for (var gateID in jsonDecodeGates.entries) {
      if (gateID.value['lat'].toString() == latitude &&
          gateID.value['long'].toString() == longitude) {
        print((gateID.value['height']).toString());
        height = (gateID.value['height']).toString();
        return height;
      }
    }
  }

  getGates(String token) async {
    // markers.clear();
    final currentField = _fieldsViewModel.currentFieldSelection;

    if (currentField == null) {
      // TODO: What to do if no field is currently selected?
      //  Could enforce choosing a field before leaving home screen.
      return;
    }

    // TODO: You can access the current field's list of gate id's using
    //  currentField.gateIds. Should be able to send those id's to app server

    // need to get the field so we can get gates from the given field
    // var fieldData = await http.post(
    //     Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getField'),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(<String, String>{
    //       "fieldID": "NrxKA24m0xQ4w5GptET2",
    //       "auth_token": token
    //     }));

    // var fields = (jsonDecode(fieldData.body) as Map)
    //     .map((key, value) => MapEntry(key as String, value as String));

    // print(fields);

    // var gateData = await http
    // .get(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getGates'));

    var gateData = await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getGates'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode(<String, String>{"gateID": gateDocId}));

    Map<String, dynamic> data = jsonDecode(gateData.body);

    // print(data);

    for (var g in data.entries) {
      // print(g.value['lat']);
      //put max so that it'd stop going to oblivion
      if (markers.length < 10) {
        print(g.value['lat']!);
        markers.add(Marker(
            point: LatLng(double.parse('${g.value['lat']!}'),
                double.parse('${g.value['long']!}')),
            builder: (_) =>
                const Icon(Icons.roller_shades_outlined, size: 25)));
      }
    }
    // print(markers.length);
    return markers;
  }
}
