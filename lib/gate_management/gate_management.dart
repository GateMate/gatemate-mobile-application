import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gatemate_mobile/data.dart';
import 'package:gatemate_mobile/map_pin_pill/map_pin_pill.dart';
import 'package:gatemate_mobile/map_pin_pill/map_pin_pill_model.dart';
import 'package:gatemate_mobile/model/gate_management_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_services_dart/googles_maps_services_dart.dart';
import 'package:map_elevation/map_elevation.dart';

import '../app_constants.dart';
import 'package:http/http.dart' as http;

final api = GooglesMapsServicesDart().getElevationAPIApi();
PinInformation currentlySelectedPin = PinInformation(
    location: LatLng(0, 0), locationName: '', labelColor: Colors.grey);
late int _markerIdValue;
Set<Marker> _markers = HashSet<Marker>();

class GateManagementRoute extends StatefulWidget {
  GateManagementRoute({super.key});

  @override
  _GateManagementState createState() => _GateManagementState();
}

class _GateManagementState extends State<GateManagementRoute> {
  late ElevationPoint hoverPoint;
  // GateManagementRoute({super.key});

  late GoogleMapController mapController;
  PinInformation currentlySelectedPin = PinInformation(
      location: LatLng(0, 0), locationName: '', labelColor: Colors.grey);
  GateManagementViewModel _gateManagementViewModel = GateManagementViewModel();
  final Set<Marker> _markers = Set();
  int polyId = 0;

  final LatLng _center = const LatLng(36.06889761358809, -94.17477200170791);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gate Management'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.terrain,
            markers: _gateManagementViewModel.markers,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10.0,
            ),
            onTap: (latLng) {
              _setMarkers(latLng);
            },
          ),
        ]));
  }

  void _setMarkers(LatLng point) {
    final String markerId = 'marked_id_$_markerIdValue';
    _markerIdValue++;
    var lat = point.latitude;
    var long = point.longitude;
    var formatLat = lat.toStringAsFixed(3);
    var formatLong = long.toStringAsFixed(3);
    setState(() {
      _markers.add(Marker(markerId: MarkerId(markerId), position: point));
    });
  }
}
