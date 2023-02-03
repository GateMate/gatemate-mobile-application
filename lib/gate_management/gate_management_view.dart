import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:gatemate_mobile/marker_popup.dart';

class GateManagementRoute extends StatelessWidget {
  GateManagementRoute({super.key});
  final PopupController _popupController = PopupController();
  MapController _mapController = MapController();
  late final List<Marker> _markers;

  @override
  Widget build(BuildContext context) {
    _markers = [
      LatLng(36.08, -94.217),
      LatLng(36.065, -94.173),
    ]
        .map(
          (markerPosition) => Marker(
            point: markerPosition,
            width: 40,
            height: 40,
            builder: (_) => const Icon(Icons.roller_shades_outlined, size: 40),
            anchorPos: AnchorPos.align(AnchorAlign.top),
          ),
        )
        .toList();

    return Scaffold(
        appBar: AppBar(title: Text('Gate Management')),
        body: Container(
            child: FlutterMap(
                options: MapOptions(
                    center: LatLng(36.06, -94.16),
                    onTap: (_, __) => _popupController.hideAllPopups()),
                nonRotatedChildren: [
              AttributionWidget.defaultWidget(
                source: '',
                onSourceTapped: null,
              ),
            ],
                children: [
              TileLayer(
                  urlTemplate: 'https://tile.opentopomap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  maxNativeZoom: 19, // OSM max available zoom is at 19.
                  maxZoom: 22),
              PopupMarkerLayerWidget(
                options: PopupMarkerLayerOptions(
                  popupController: _popupController,
                  markers: _markers,
                  markerRotateAlignment:
                      PopupMarkerLayerOptions.rotationAlignmentFor(
                          AnchorAlign.top),
                  popupBuilder: (BuildContext context, Marker marker) =>
                      ExamplePopup(marker),
                ),
              ),
            ])));
  }
}
