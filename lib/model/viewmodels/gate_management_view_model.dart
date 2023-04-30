import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

int markerId = 0;

class GateManagementViewModel extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  List<Marker> markers = [];
  var gateHeight = 0.0;
  var idToUpdate = "";
  final _fieldsViewModel = GetIt.I<FieldsViewModel>();
  var gateDocId = "";

  void setGateHeight(String latitude, String longitude, String gateHeight,
      String token) async {
    getGateID(latitude, longitude, token).then(
      (value) => updateHeight(latitude, longitude, gateHeight, token),
    );
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

    // print(jsonDecodeGates[1]!.entries.toString());

    for (var gates in jsonDecodeGates.entries) {
      if (gates.value['lat'].toString() == latitude &&
          gates.value['long'].toString() == longitude) {
        print((gates.value['height']).toString());
        height = (gates.value['height']).toString();
        return height;
      }
    }

    // var i = 0;
    // for (var i; i < jsonDecodeGates.entries.length; i++) {
    //   // if (i < 10) {
    //   //   jsonDecodeGates[i]!
    //   //       .entries
    //   //       .forEach((element) => print(element.value['lat']));
    //   // }

    //   if (i < 10) {
    //     if (i.value['lat'].toString() == latitude &&
    //         i.value['long'].toString() == longitude) {
    //       print((i.value['height']).toString());
    //       height = (i.value['height']).toString();
    //       return height;
    //     }
    //   }
    // }
  }

  void deleteGates(String token, String latitude, String longitude) async {
    // final currentField = _fieldsViewModel.currentFieldSelection;
    getGateID(latitude, longitude, token)
        .then((value) => {print(gateDocId), deleteGate(gateDocId, token)});
  }

  deleteGate(String gateID, String token) async {
    var deletedGate = http.get(
      Uri.parse(
          'https://todo-proukhgi3a-uc.a.run.app/deleteGate?gateID=${gateID}'),
      headers: <String, String>{
        'Authorization': token,
      },
    );
  }

  getGates(String token) async {
    // markers.clear();
    final currentField = _fieldsViewModel.currentFieldSelection;

    if (currentField == null) {
      // TODO: What to do if no field is currently selected?
      //  Could enforce choosing a field before leaving home screen.
      return;
    }

    // print(currentField.gateIds);

    // TODO: You can access the current field's list of gate id's using
    //  currentField.gateIds. Should be able to send those id's to app server

    var gateData;
    if (currentField.gateIds.isNotEmpty) {
      for (var g in currentField.gateIds) {
        gateData = await http.get(
          Uri.parse(
              'https://todo-proukhgi3a-uc.a.run.app/getGates?fieldID=${currentField.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
          },
        );

        Map<String, dynamic> data = jsonDecode(gateData.body);
        // print(data);

        for (var d in data.entries) {
          markers.add(Marker(
              point: LatLng(double.parse('${d.value['lat']!}'),
                  double.parse('${d.value['long']!}')),
              builder: (_) =>
                  const Icon(Icons.roller_shades_outlined, size: 25)));
        }
      }
    }

    // print(data);

    // for (var g in data.entries) {
    //   // print(g.value['lat']);

    //   print(g.value['lat']!);
    //   markers.add(Marker(
    //       point: LatLng(double.parse('${g.value['lat']!}'),
    //           double.parse('${g.value['long']!}')),
    //       builder: (_) => const Icon(Icons.roller_shades_outlined, size: 25)));
    // }
    // print(markers.length);
    return markers;
  }

  getGateID(String latitude, String longitude, String token) async {
    final currentField = _fieldsViewModel.currentFieldSelection;

    if (currentField == null) {
      // TODO: What to do if no field is currently selected?
      //  Could enforce choosing a field before leaving home screen.
      return;
    }

    var gateData = await http.get(
      Uri.parse(
          'https://todo-proukhgi3a-uc.a.run.app/getGates?fieldID=${currentField.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );
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
}
