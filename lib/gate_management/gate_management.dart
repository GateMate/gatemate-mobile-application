import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gatemate_mobile/map_pin_pill/map_pin_pill.dart';
import 'package:gatemate_mobile/map_pin_pill/map_pin_pill_model.dart';
import 'package:gatemate_mobile/model/gate_management_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../app_constants.dart';

PinInformation currentlySelectedPin = PinInformation(
    location: LatLng(0, 0), locationName: '', labelColor: Colors.grey);

class GateManagementRoute extends StatelessWidget {
  GateManagementRoute({super.key});

  late GoogleMapController mapController;
  PinInformation currentlySelectedPin = PinInformation(
      location: LatLng(0, 0), locationName: '', labelColor: Colors.grey);
  GateManagementViewModel _gateManagementViewModel = GateManagementViewModel();
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
        body: Stack(children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.terrain,
            markers: _gateManagementViewModel.markers,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10.0,
            ),
          ),
          MapPinPillComponent(
              pinPillPosition: -100, currentlySelectedPin: currentlySelectedPin)
        ]));
  }
}
