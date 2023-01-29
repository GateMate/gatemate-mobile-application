import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class AddGateRoute extends StatelessWidget {
  AddGateRoute({super.key});
  final PopupController _popupController = PopupController();
  MapController _mapController = MapController();
  double _zoom = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add a Gate')),
        body: Container(
            child: FlutterMap(
                options: MapOptions(
                  center: LatLng(36.06, -94.16),
                  zoom: 10,
                ),
                nonRotatedChildren: [
              AttributionWidget.defaultWidget(
                source: '',
                onSourceTapped: null,
              ),
            ],
                children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                      width: 30.0,
                      height: 30.0,
                      point: LatLng(36.083, -94.216),
                      builder: (ctx) => Container(
                              child: Container(
                            child: Icon(
                              Icons.roller_shades_outlined,
                              color: Colors.blueAccent,
                              size: 40,
                            ),
                          )))
                ],
              ),
            ])));
  }
}
      // Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Add Gate'),
      //   ),
      //   body: Center(
      //     child: ElevatedButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       child: const Text('adding a gate'),
      //     ),
      //   ),
      // ),

