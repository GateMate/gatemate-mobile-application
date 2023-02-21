import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/gate_management_view_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/my_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:gatemate_mobile/marker_popup.dart';

import '../app_constants.dart';
import 'package:http/http.dart' as http;

late int _markerIdValue;
// Set<Marker> _markers = HashSet<Marker>();

class GateManagementRoute extends StatefulWidget {
  GateManagementRoute({super.key});

  @override
  _GateManagementState createState() => _GateManagementState();
}

class _GateManagementState extends State<GateManagementRoute> {
  // GateManagementRoute({super.key});

  GateManagementViewModel _gateManagementViewModel = GateManagementViewModel();
  // final Set<Marker> markers = Set();
  int polyId = 0;

  final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gate Management'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Flexible(
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(36.133512, -94.121556),
                      // center: LatLng(47.925812, 106.919831),
                      maxZoom: 18,
                      zoom: 9.0,
                      plugins: [EsriPlugin()],
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            'https://services.arcgisonline.com/arcgis/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}?apiKey=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578',
                        subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                        tileProvider: NonCachingNetworkTileProvider(),
                        backgroundColor: Colors.transparent,
                      ),
                      MarkerLayerOptions(
                        markers: [
                          for (int i = 0;
                              i < _gateManagementViewModel.markers.length;
                              i++)
                            _gateManagementViewModel.markers[i]
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Stack(children: <Widget>[
      //   GoogleMap(
      //     onMapCreated: _onMapCreated,
      //     mapType: MapType.terrain,
      //     markers: _gateManagementViewModel.markers,
      //     initialCameraPosition: CameraPosition(
      //       target: _center,
      //       zoom: 10.0,
      //     ),
      //     onTap: (latLng) {
      //       _setMarkers(latLng);
      //     },
      //   ),
      // ]
    );
  }
}
