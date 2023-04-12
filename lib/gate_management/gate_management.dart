// import 'package:flutter/material.dart';
// import 'package:gatemate_mobile/model/data/gate.dart';
// import 'package:gatemate_mobile/model/gate_management_view_model.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:gatemate_mobile/view/ui_primatives/marker_popup.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
// import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

// late int _markerIdValue;
// // Set<Marker> _markers = HashSet<Marker>();

// class GateManagementRoute extends StatefulWidget {
//   GateManagementRoute({super.key});

//   @override
//   _GateManagementState createState() => _GateManagementState();
// }

// class _GateManagementState extends State<GateManagementRoute> {
//   GateManagementViewModel _gateManagementViewModel = GateManagementViewModel();
//   @override
//   void InitState() {
//     super.initState();
//   }
//   // GateManagementRoute({super.key});

//   // final Set<Marker> markers = Set();
//   int polyId = 0;
//   // late List<GateModel> gate;

//   final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);
//   final PopupController _popupController = PopupController();
//   late final Future<List<GateModel>> gates = Future<List<GateModel>>.delayed(
//       const Duration(seconds: 1), () => _gateManagementViewModel.getGates());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gate Management'),
//         backgroundColor: Colors.green[700],
//       ),
//       body: Stack(
//         children: [
//           FutureBuilder(
//             future: gates,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 GateModel gateModel = snapshot.data as GateModel;
//                 print(gateModel);
//               }
//               throw (Exception);
//             },
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Flexible(
//                   child: FlutterMap(
//                     options: MapOptions(
//                         center: LatLng(36.133512, -94.121556),
//                         // center: LatLng(47.925812, 106.919831),
//                         maxZoom: 18,
//                         zoom: 9.0,
//                         plugins: [EsriPlugin()],
//                         onTap: (tapPos, latlng) {
//                           _popupController.hideAllPopups();
//                           print(latlng);
//                           _gateManagementViewModel.getGates();
//                         }),
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
//                             // gate = await _gateManagementViewModel.getGates()
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
//                     alignment: Alignment.bottomCenter,
//                     child: Text(
//                       'Click an existing marker to view details',
//                       style: const TextStyle(fontSize: 20),
//                       textAlign: TextAlign.center,
//                     ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
