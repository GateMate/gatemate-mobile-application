import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class AddGateRoute extends StatelessWidget {
  AddGateRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          center: LatLng(51.509364, -0.128928),
          zoom: 9.2,
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
        ]);
  }
}
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 34.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Card(
      //         child: TextField(
      //           decoration: InputDecoration(
      //             contentPadding: EdgeInsets.all(16.0),
      //             hintText: "Search for your localisation",
      //             prefixIcon: Icon(Icons.location_on_outlined),
      //           ),
      //         ),
      //       ),
      //       Card(
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Column(
      //             children: [
      //               Text(
      //                   "${location.first.countryName},${location.first.locality}, ${location.first.featureName}"),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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

