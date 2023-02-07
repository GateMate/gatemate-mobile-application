import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../app_constants.dart';

class AddGateRoute extends StatelessWidget {
  AddGateRoute({super.key});

  late GoogleMapController mapController;
  final Set<Marker> _markers = Set();
  final LatLng _center = const LatLng(36.06889761358809, -94.17477200170791);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _addMarkers() async {
    double lat = 36.06889761358809;
    double long = -94.17477200170791;
    // setState(() {
    _markers.clear();
    _markers.add(Marker(
        markerId: MarkerId('$lat, $long'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
            title: 'Gate Information', snippet: 'Position: $lat, $long')));
    // });
  }

  @override
  Widget build(BuildContext context) {
    _addMarkers();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Gate'),
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

          // Stack(
          //   children: [
          //     FlutterMap(
          //       options: MapOptions(
          //           minZoom: 5,
          //           maxZoom: 18,
          //           zoom: 13,
          //           center: AppConstants.myLocation),
          //       layers: [
          //         TileLayerOptions(
          //           urlTemplate:
          //               "https://api.mapbox.com/styles/v1/cpatton/cldievrq0000301o10nbx1zvu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY3BhdHRvbiIsImEiOiJjbGRodG1pZ3kweWFyM3ZvM2trcjY5d3liIn0.Th1u92jVxkdhJp1-pcJpdA",
          //           // "https://api.mapbox.com/styles/v1/dhruv25/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
          //           additionalOptions: {
          //             'mapStyleId': 'mapbox.mapbox-outdoors-v11',
          //             'accessToken': AppConstants.mapBoxAccessToken,
          //           },
          //         ),
          //       ],
          //     )
          //   ],
          // )
          // child: FlutterMap(
          //   options: MapOptions(
          //     minZoom: 5,
          //     maxZoom: 18,
          //     zoom: 13,
          //     center: AppConstants.myLocation,
          //   ),
          //   layers: [
          //     TileLayerOptions(
          //       urlTemplate:
          //           "https://api.mapbox.com/styles/v1/cpatton/cldievrq0000301o10nbx1zvu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY3BhdHRvbiIsImEiOiJjbGRodG1pZ3kweWFyM3ZvM2trcjY5d3liIn0.Th1u92jVxkdhJp1-pcJpdA",
          //       additionalOptions: {
          //         'mapStyleId': AppConstants.mapBoxStyleId,
          //         'accessToken': AppConstants.mapBoxAccessToken,
          //       },
          //     ),
          //   ],
          // ),
          // child: ElevatedButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: const Text('adding a gate'),
          // ),
        ));
  }
}
