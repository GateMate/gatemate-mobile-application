// import 'dart:html';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/model/data/gate.dart';
import 'package:latlong2/latlong.dart';

int markerId = 0;

class ManageMultipleGatesViewModel extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  List<Marker> markers = [];
  var gateHeight = 0.0;
  var idToUpdate = "";

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
}
