import 'package:cloud_firestore/cloud_firestore.dart';

class GateModel {
  final String gate_height;
  final String lat;
  final String long;
  final String? node_id;
  final String field_id;

  const GateModel(
      {required this.gate_height,
      required this.lat,
      required this.long,
      required this.node_id,
      required this.field_id});

  toJson() {
    return {
      "Height": gate_height,
      "Lat": lat,
      "Long": long,
      "NodeID": node_id,
      "FieldID": field_id
    };
  }

  factory GateModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return GateModel(
        gate_height: data["gate_height"],
        lat: data["lat"],
        long: data["long"],
        node_id: data["node_id"],
        field_id: data["field_id"]);
  }
}
