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

    // DocumentSnapshot snapshot = (await _db
    //     .collection("gates_test")
    //     .where('lat', isEqualTo: latitude)
    //     .where('long', isEqualTo: longitude)
    //     .get()) as DocumentSnapshot<Object?>;

    // print(snapshot.reference.id);

    // DocumentReference doc_ref = FirebaseFirestore.instance
    //     .collection("board")
    //     .document(doc_id)
    //     .collection("Dates")
    //     .document();

    // DocumentSnapshot ds =
    //     await FirebaseFirestore.instance.collection('users').doc('30').get();
    // getname = ds.data['name'];
    // snapshot.docs.first
    //     .data()
    //     .update({gateHeight: gateHeight}).then((value) => print("updated"));
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

  Future<List<Marker>> getGates() async {
    final snapshot = await _db.collection("gates_test").get();

    final gateData =
        snapshot.docs.map((e) => GateModel.fromSnapshot(e)).toList();

    for (var g in gateData) {
      markers.add(Marker(
          point: LatLng(double.parse(g.lat), double.parse(g.long)),
          builder: (_) => const Icon(Icons.roller_shades_outlined, size: 25)));
    }

    return markers;
  }

  // String snippetMessage(LatLng latLng) {
  //   var elevation = fetchElevation(latLng);
  //   return 'Location: {$latLng}, Elevation: ${elevation}';
  // }

  // Future<http.Response> fetchElevation(LatLng latLng) {
  //   return http.get(Uri.parse(
  //       'https://api.open-elevation.com/api/v1/lookup?locations=$latLng'));
  // }
}
