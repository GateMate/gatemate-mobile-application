import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:gatemate_mobile/view/ui_primatives/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../model/add_gate_model.dart';
import '../ui_primatives/marker_popup.dart';
import '../ui_primatives/my_button.dart';

// Set<Marker> markers = <Marker>{};
List<Marker> markers = [];
int markerId = 0;

class AddFieldRoute extends StatefulWidget {
  const AddFieldRoute({super.key});

  @override
  _AddFieldRoute createState() => _AddFieldRoute();
}

class _AddFieldRoute extends State<AddFieldRoute> {
  AddGateModel addGateModel = AddGateModel();
  final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);
  final PopupController _popupController = PopupController();
  late List<LatLng> polygonList = <LatLng>[];
  final poly1Controller = TextEditingController();
  final poly2Controller = TextEditingController();
  final poly3Controller = TextEditingController();
  final poly4Controller = TextEditingController();

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
    markerId++;
    return ChangeNotifierProvider(
      create: (context) => AddGateModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Field'),
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
                          // setState(() => polygonList.add(latlng));
                          // polygonList.add(latlng);
                          // print(polygonList);

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
                                      child: MyTextField(
                                        controller: poly1Controller,
                                        hintText:
                                            "Enter Latitude and Longitude",
                                        obscureText: false,
                                        prefixIcon: Icon(Icons.my_location),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        MyButton(
                                          buttonText: 'Add Field',
                                          onPressed: () => setState(
                                            () {
                                              // var newMarker = Marker(
                                              //   builder: (_) => const Icon(
                                              //     Icons.roller_shades_outlined,
                                              //     size: 25,
                                              //   ),
                                              //   point: latlng,
                                              // );
                                              // markers.add(newMarker);
                                              // addGateModel
                                              //     .setMarkers(newMarker);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        // MyButton(
                                        //   buttonText: 'No, Don\'t Add Marker',
                                        //   onPressed: () =>
                                        //       Navigator.pop(context),
                                        // ),
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
                        // PolygonLayerWidget(
                        //     options: PolygonLayerOptions(
                        //         polygons: [Polygon(points: polygonList)])),
                        TileLayerWidget(
                          options: TileLayerOptions(
                            urlTemplate:
                                'https://services.arcgisonline.com/arcgis/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}?apiKey=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578',
                            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                            tileProvider: NonCachingNetworkTileProvider(),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        PolygonLayerWidget(
                            options: PolygonLayerOptions(polygons: [
                          Polygon(points: polygonList, color: Colors.black)
                        ]))

                        // PopupMarkerLayerWidget(
                        //   options: PopupMarkerLayerOptions(
                        //     popupController: _popupController,
                        //     markers: [
                        //       for (int i = 0;
                        //           i < addGateModel.markers.length;
                        //           i++)
                        //         addGateModel.markers[i]
                        //     ],
                        //     popupBuilder:
                        //         (BuildContext context, Marker marker) =>
                        //             ExamplePopup(marker),
                        //   ),
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