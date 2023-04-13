import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:gatemate_mobile/model/viewmodels/gate_management_view_model.dart';
import 'package:latlong2/latlong.dart';

import '../ui_primatives/marker_popup.dart';

late int _markerIdValue;
// Set<Marker> _markers = HashSet<Marker>();
late List<Marker> markers = [];

class GateManagementRoute extends StatefulWidget {
  GateManagementRoute({super.key});

  @override
  _GateManagementState createState() => _GateManagementState();
}

class _GateManagementState extends State<GateManagementRoute> {
  GateManagementViewModel _gateManagementViewModel = GateManagementViewModel();
  @override
  void InitState() {
    super.initState();
  }

  int polyId = 0;

  final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);
  final PopupController _popupController = PopupController();

  @override
  Widget build(BuildContext context) {
    _gateManagementViewModel.getGates().then((value) {
      setState(() {
        markers = value;
      });
    });
    // _gateManagementViewModel.getGates();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gate Management'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                      onTap: (_, __) {
                        _popupController.hideAllPopups();
                      },
                    ),
                    nonRotatedChildren: [
                      AttributionWidget.defaultWidget(
                        source: '',
                        onSourceTapped: null,
                      ),
                    ],
                    // layers: [
                    children: [
                      TileLayerWidget(
                        options: TileLayerOptions(
                          urlTemplate:
                              'https://services.arcgisonline.com/arcgis/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}?apiKey=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578',
                          subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                          tileProvider: NonCachingNetworkTileProvider(),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      // MarkerLayerWidget(
                      //     options: MarkerLayerOptions(
                      //   markers: [
                      //     for (int i = 0;
                      //         i < _gateManagementViewModel.markers.length;
                      //         i++)
                      //       _gateManagementViewModel.markers[i]
                      //   ],
                      // )),
                      PopupMarkerLayerWidget(
                          options: PopupMarkerLayerOptions(
                        popupController: _popupController,
                        markers: [
                          for (int i = 0; i < markers.length; i++) markers[i]
                        ],
                        popupBuilder: (BuildContext context, Marker marker) =>
                            ExamplePopup(marker),
                      )),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: const Text(
                    'Click an existing marker to view details',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
// import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
// import 'package:latlong2/latlong.dart';

// import '../../model/viewmodels/gate_management_view_model.dart';
// import '../ui_primatives/confirmation_popup.dart';

// late int _markerIdValue;
// // Set<Marker> _markers = HashSet<Marker>();
// late List<Marker> markers = [];

// class GateManagementView extends StatefulWidget {
//   const GateManagementView({super.key});

//   @override
//   _GateManagementState createState() => _GateManagementState();
// }

// class _GateManagementState extends State<GateManagementView> {
//   // TODO: Use GetIt
//   GateManagementViewModel _gateManagementViewModel = GateManagementViewModel();
//   // final Set<Marker> markers = Set();
//   int polyId = 0;

//   final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);
//   final PopupController _popupController = PopupController();

//   @override
//   Widget build(BuildContext context) {
//     _gateManagementViewModel.getGates().then((value) {
//       setState(() {
//         markers = value;
//       });
//     });
//     // _gateManagementViewModel.getGates();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gate Management'),
//         backgroundColor: Colors.green[700],
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Flexible(
//                   child: FlutterMap(
//                     options: MapOptions(
//                       center: LatLng(36.133512, -94.121556),
//                       // center: LatLng(47.925812, 106.919831),
//                       maxZoom: 18,
//                       zoom: 9.0,
//                       plugins: [EsriPlugin()],
//                       onTap: (_, __) {
//                         _popupController.hideAllPopups();
//                       },
//                     ),
//                     nonRotatedChildren: [
//                       AttributionWidget.defaultWidget(
//                         source: '',
//                         onSourceTapped: null,
//                       ),
//                     ],
//                     // layers: [
//                     children: [
//                       TileLayerWidget(
//                         options: TileLayerOptions(
//                           urlTemplate:
//                               'https://services.arcgisonline.com/arcgis/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}?apiKey=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578',
//                           subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
//                           tileProvider: NonCachingNetworkTileProvider(),
//                           backgroundColor: Colors.transparent,
//                         ),
//                       ),
//                       // MarkerLayerWidget(
//                       //     options: MarkerLayerOptions(
//                       //   markers: [
//                       //     for (int i = 0;
//                       //         i < _gateManagementViewModel.markers.length;
//                       //         i++)
//                       //       _gateManagementViewModel.markers[i]
//                       //   ],
//                       // )),
//                       PopupMarkerLayerWidget(
//                         options: PopupMarkerLayerOptions(
//                           popupController: _popupController,
//                           markers: [
//                             for (int i = 0;
//                                 i < _gateManagementViewModel.markers.length;
//                                 i++)
//                               _gateManagementViewModel.markers[i]
//                           ],
//                           // markerRotateAlignment:
//                           //     PopupMarkerLayerOptions.rotationAlignmentFor(
//                           //         AnchorAlign.top),
//                           popupBuilder: (BuildContext context, Marker marker) =>
//                               ExamplePopup(marker),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.bottomCenter,
//                   child: const Text(
//                     'Click an existing marker to view details',
//                     style: TextStyle(fontSize: 20),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
