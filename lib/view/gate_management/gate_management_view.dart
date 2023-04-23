import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:gatemate_mobile/model/firebase/gatemate_auth.dart';
import 'package:gatemate_mobile/model/viewmodels/gate_management_view_model.dart';
import 'package:gatemate_mobile/view/login/login.dart';
import 'package:get_it/get_it.dart';
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
  final _gateManagementViewModel = GateManagementViewModel();
  final _authProvider = GetIt.I<GateMateAuth>();

  final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);
  final PopupController _popupController = PopupController();

  int polyId = 0;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _authProvider.addListener(_checkLoginStatus);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_checkLoginStatus);
    super.dispose();
  }

  void _checkLoginStatus() {
    // TODO: Ensure 'null' is the correct thing to check for
    if (_authProvider.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
        );
      });
    } else {
      // TODO: Either do something here or remove "else"
    }
  }

  @override
  Widget build(BuildContext context) {
    _authProvider.getAuthToken().then(
          (value) =>
              _gateManagementViewModel.getGates(value.toString()).then((value) {
            if (mounted) {
              setState(() {
                markers = value;
              });
            }
          }),
        );

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
                              MarkerPopup(marker),
                        ),
                      ),
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
