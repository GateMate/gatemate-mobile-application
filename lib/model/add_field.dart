import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AddFieldModel extends ChangeNotifier {
  List<Marker> markers = [];

  setMarkers(Marker m) {
    this.markers.add(m);
    notifyListeners();
    print('markers: ${this.markers}');
  }
}
