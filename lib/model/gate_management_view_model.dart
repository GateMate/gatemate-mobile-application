// import 'dart:html';

// import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/model/data/gate.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int markerId = 0;

class GateManagementViewModel extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  List<Marker> markers = [];
  var gateHeight = 0.0;
  var idToUpdate = "";

  void setGateHeight(
      String latitude, String longitude, String gateHeight) async {
    print("HERE");
    FirebaseFirestore.instance
        .collection("gates_test")
        .where('lat', isEqualTo: latitude)
        .where('long', isEqualTo: longitude)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        print(element.id);
        DocumentSnapshot ds = (await FirebaseFirestore.instance
                .collection("gates_test")
                .doc(element.id))
            .update({"gate_height": gateHeight}) as DocumentSnapshot<Object?>;
        // return ds;
      });
    });

    createAlbum(gateHeight);
  }

  Future<http.Response> createAlbum(String height) async {
    if (kDebugMode) {
      // ignore: prefer_interpolation_to_compose_strings
      print("HEIGHT" + height);
    }
    return await http.post(
      Uri.parse('http://10.0.2.2:5000/setGateHeight'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'height': height,
      }),
    );
  }

  // Future<List<Marker>> getGates() async {
  //   final snapshot = await _db.collection("gates_test").get();

  //   final gateData =
  //       snapshot.docs.map((e) => GateModel.fromSnapshot(e)).toList();

  //   for (var g in gateData) {
  //     markers.add(Marker(
  //         point: LatLng(double.parse(g.lat), double.parse(g.long)),
  //         builder: (_) => const Icon(Icons.roller_shades_outlined, size: 25)));
  //   }

  //   return markers;
  // }

  getGates() async {
    var gateData = await http
        .get(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getGates'));

    // var gates = (jsonDecode(gateData.body) as Map).map(
    // (key, value) => MapEntry(key as String, value as Map<String, String>));

    Map<String, dynamic> data = jsonDecode(gateData.body);
    print(data);

    // print(gateData.body);

    // var gates = jsonDecode(gateData.body).cast<Map<String, dynamic>>();
    // var decodeGates = gates['success'].toString();

    // print(gates);
    // print(gates.entries.length);

    for (var g in data.entries) {
      // print(g.value['lat']);
      markers.add(Marker(
          point: LatLng(
              double.parse(g.value['lat']!), double.parse(g.value['long']!)),
          builder: (_) => const Icon(Icons.roller_shades_outlined, size: 25)));
    }
    print(markers.length);
    return markers;
  }
}
