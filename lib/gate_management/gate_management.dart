import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../app_constants.dart';

class GateManagementRoute extends StatelessWidget {
  GateManagementRoute({super.key});

  late GoogleMapController mapController;
  final Set<Marker> _markers = Set();

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
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        mapType: MapType.terrain,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10.0,
        ),
      ),
    );
  }
}
