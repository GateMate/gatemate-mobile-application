import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:gatemate_mobile/model/viewmodels/add_gate_model.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../model/viewmodels/add_gate_model.dart';
import '../ui_primatives/confirmation_popup.dart';
import '../ui_primatives/confirmation_button.dart';

// Set<Marker> markers = <Marker>{};
List<Marker> markers = [];
int markerId = 0;

class AddGateView extends StatefulWidget {
  const AddGateView({super.key});

  @override
  _AddGateState createState() => _AddGateState();
}

class _AddGateState extends State<AddGateView> {
  AddGateModel addGateModel = AddGateModel();
  final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);
  final PopupController _popupController = PopupController();

  @override
  void initState() {
    super.initState();
    // addGateModel = Provider.of<AddGateModel>(context, listen: true);
    // addGateModel.addListener(() => mounted ? setState(() {}) : null);

    // initialization goes here
  }

  @override
  void dispose() {
    // teardown goes here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var addGateModelMarkers = context.watch<AddGateModel>().markers;
    // addGateModel = Provider.of<AddGateModel>(context, listen: true);'
    markerId++;
    return ChangeNotifierProvider(
      create: (context) => AddGateModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Gate'),
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
                        onTap: (tapPos, latlng) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                elevation: 16,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    const SizedBox(height: 20),
                                    Center(
                                      child: Text(
                                        'Are you sure you want to add a marker at ${latlng.latitude.toStringAsFixed(3)}, ${latlng.longitude.toStringAsFixed(3)}?',
                                        style: const TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        ConfirmationButton(
                                          buttonText: 'Yes, Add Marker',
                                          onPressed: () => setState(
                                            () {
                                              var newMarker = Marker(
                                                builder: (_) => const Icon(
                                                  Icons.roller_shades_outlined,
                                                  size: 25,
                                                ),
                                                point: latlng,
                                              );
                                              markers.add(newMarker);
                                              addGateModel
                                                  .setMarkers(newMarker);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        ConfirmationButton(
                                          buttonText: 'No, Don\'t Add Marker',
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
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
                        PopupMarkerLayerWidget(
                          options: PopupMarkerLayerOptions(
                            popupController: _popupController,
                            markers: [
                              for (int i = 0;
                                  i < addGateModel.markers.length;
                                  i++)
                                addGateModel.markers[i]
                            ],
                            // markerRotateAlignment:
                            //     PopupMarkerLayerOptions.rotationAlignmentFor(
                            //         AnchorAlign.top),
                            popupBuilder:
                                (BuildContext context, Marker marker) =>
                                    ConfirmationPopup(marker),
                          ),
                        ),
                        // MarkerLayerOptions(
                        //   markers: [
                        //     for (int i = 0;
                        //         i < addGateModel.markers.length;
                        //         i++)
                        //       addGateModel.markers[i]
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: const Text(
                      'Tap at a location to add a gate or click an existing marker to view details',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<http.Response> fetchElevation(LatLng latLng) {
    return http.get(Uri.parse(
      'https://api.open-elevation.com/api/v1/lookup?locations=$latLng',
    ));
  }
}
