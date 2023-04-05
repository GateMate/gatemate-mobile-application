import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatemate_mobile/view/ui_primatives/marker_popup_view.dart';
import 'package:gatemate_mobile/view/ui_primatives/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../model/add_gate_model.dart';
import '../ui_primatives/my_button.dart';

// Set<Marker> markers = <Marker>{};
List<Marker> markers = [];
int markerId = 0;

class AddGateRoute extends StatefulWidget {
  const AddGateRoute({super.key});

  @override
  _AddGateState createState() => _AddGateState();
}

class _AddGateState extends State<AddGateRoute> {
  AddGateModel addGateModel = AddGateModel();
  final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);
  final PopupController _popupController = PopupController();
  final addMarkerLatController = TextEditingController();
  final addMarkerLongController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future(markerToAddDialog);
    addMarkerLatController.addListener(() {});
    addMarkerLongController.addListener(() {});
    // addGateModel = Provider.of<AddGateModel>(context, listen: true);
    // addGateModel.addListener(() => mounted ? setState(() {}) : null);

    // initialization goes here
  }

  @override
  void dispose() {
    // teardown goes here
    super.dispose();
  }

  void addMarker() {
    var m = Marker(
      builder: (_) => const Icon(Icons.roller_shades_outlined, size: 25),
      point: LatLng(double.parse(addMarkerLatController.text),
          double.parse(addMarkerLongController.text)),
    );
    setState(
      () {
        markers.add(m);
      },
    );
    addGateModel.setMarkers(m);

    Fluttertoast.showToast(
        msg: "Gate Marker Added Successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void markerToAddDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 16,
              child: ListView(shrinkWrap: true, children: <Widget>[
                const SizedBox(height: 20),
                Column(children: [
                  const Text(
                    'Enter the Latitude and Longitude To Add a Gate Marker at that Location:',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Row(children: [
                    Expanded(
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        subtitle: MyTextField(
                          controller: addMarkerLatController,
                          hintText: "Lat",
                          obscureText: false,
                          prefixIcon: Icon(Icons.my_location),
                          onChanged: () {
                            print(addMarkerLatController.text);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        subtitle: MyTextField(
                          controller: addMarkerLongController,
                          hintText: "Long",
                          obscureText: false,
                          prefixIcon: Icon(Icons.my_location),
                          onChanged: () {
                            print(addMarkerLongController.text);
                          },
                        ),
                      ),
                    ),
                  ]),
                ]),
                Column(
                  children: [
                    MyButton(
                      buttonText: 'Add Gate',
                      onPressed: () => setState(
                        () {
                          addMarker();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ]));
        });
  }

  // void confirmationDialog(LatLng latlng) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(40),
  //         ),
  //         elevation: 16,
  //         child: ListView(
  //           shrinkWrap: true,
  //           children: <Widget>[
  //             const SizedBox(height: 20),
  //             Center(
  //               child: Text(
  //                 'Are you sure you want to add a marker at ${latlng.latitude.toStringAsFixed(3)}, ${latlng.longitude.toStringAsFixed(3)}?',
  //                 style: const TextStyle(fontSize: 20),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //             Column(
  //               children: [
  //                 MyButton(
  //                   buttonText: 'Yes, Add Marker',
  //                   onPressed: () => setState(
  //                     () {
  //                       var newMarker = Marker(
  //                         builder: (_) => const Icon(
  //                           Icons.roller_shades_outlined,
  //                           size: 25,
  //                         ),
  //                         point: latlng,
  //                       );
  //                       markers.add(newMarker);
  //                       addGateModel.setMarkers(newMarker);
  //                       Navigator.pop(context);
  //                     },
  //                   ),
  //                 ),
  //                 MyButton(
  //                   buttonText: 'No, Don\'t Add Marker',
  //                   onPressed: () => Navigator.pop(context),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 20),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
                        onTap: (tapPos, latlng) {},
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
                            popupBuilder:
                                (BuildContext context, Marker marker) =>
                                    viewPopup(marker),
                          ),
                        ),
                        Container(
                            alignment: Alignment.bottomRight,
                            padding: const EdgeInsets.all(10.0),
                            child: FloatingActionButton(
                              onPressed: () {
                                addMarkerLatController.clear();
                                addMarkerLongController.clear();
                                markerToAddDialog();
                              },
                              backgroundColor: Colors.green[400],
                              child: const Icon(Icons.add),
                            )),
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
                      'Tap the "+" to add a gate marker or click an existing marker to view details',
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

  // Future<http.Response> fetchElevation(LatLng latLng) {
  //   return http.get(Uri.parse(
  //     'https://api.open-elevation.com/api/v1/lookup?locations=$latLng',
  //   ));
  // }
}
