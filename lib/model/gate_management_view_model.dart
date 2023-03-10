import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
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
