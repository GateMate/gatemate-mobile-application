import 'package:cloud_firestore/cloud_firestore.dart';

class GateModel {
  final String gate_height;
  final String lat;
  final String long;

  const GateModel(
      {required this.gate_height, required this.lat, required this.long});

  toJson() {
    return {"Height": gate_height, "Lat": lat, "Long": long};
  }

  factory GateModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return GateModel(
        gate_height: data["gate_height"], lat: data["lat"], long: data["long"]);
  }
}
