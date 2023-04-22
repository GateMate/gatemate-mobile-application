// import 'dart:html';

// import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/model/data/gate.dart';
import 'package:gatemate_mobile/model/viewmodels/gate_management_view_model.dart';
import 'package:gatemate_mobile/view/gate_management/gate_management_view.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
