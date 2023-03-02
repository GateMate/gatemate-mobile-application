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
import 'package:flutter_map_line_editor/polyeditor.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';

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
  final polyLat1Controller = TextEditingController();
  final polyLong1Controller = TextEditingController();
  final polyLat2Controller = TextEditingController();
  final polyLong2Controller = TextEditingController();
  final polyLat3Controller = TextEditingController();
  final polyLong3Controller = TextEditingController();
  final polyLat4Controller = TextEditingController();
  final polyLong4Controller = TextEditingController();
  late PolyEditor polyEditor;

  List<Polygon> polygons = [];
  var testPolygon =
      Polygon(color: Colors.deepOrange, isFilled: true, points: []);

  @override
  void initState() {
    super.initState();
    Future(showOptions);
    // addGateModel = Provider.of<AddGateModel>(context, listen: true);
    // addGateModel.addListener(() => mounted ? setState(() {}) : null);

    // initialization goes here
    polyEditor = PolyEditor(
      addClosePathMarker: true,
      points: testPolygon.points,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: () => {setState(() {})},
    );

    polygons.add(testPolygon);
  }

  @override
  void dispose() {
    // teardown goes here
    super.dispose();
  }

  void showOptions() {
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
              Column(
                children: [
                  const Text(
                    'Draw Your Field on the Map or Enter Coordinates',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  MyButton(
                    buttonText: 'Draw Field on Map',
                    onPressed: () => setState(
                      () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  MyButton(
                    buttonText: 'Enter Coordinates',
                    onPressed: () => setState(
                      () {
                        Navigator.pop(context);
                        Future(dialogCoordinates);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void dialogCoordinates() {
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
              Column(
                children: [
                  const Text(
                    'Enter Latitude and Longitude Values for 4 Points to Create a Field Within Those Points:',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          subtitle: MyTextField(
                            controller: polyLat1Controller,
                            hintText: "Enter Latitude 1",
                            obscureText: false,
                            prefixIcon: Icon(Icons.my_location),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                          child: ListTile(
                        subtitle: MyTextField(
                          controller: polyLong1Controller,
                          hintText: "Enter Longitude 1",
                          obscureText: false,
                          prefixIcon: Icon(Icons.my_location),
                        ),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          subtitle: MyTextField(
                            controller: polyLat2Controller,
                            hintText: "Enter Latitude 2",
                            obscureText: false,
                            prefixIcon: Icon(Icons.my_location),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                          child: ListTile(
                        subtitle: MyTextField(
                          controller: polyLong2Controller,
                          hintText: "Enter Longitude 2",
                          obscureText: false,
                          prefixIcon: Icon(Icons.my_location),
                        ),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          subtitle: MyTextField(
                            controller: polyLat3Controller,
                            hintText: "Enter Latitude 3",
                            obscureText: false,
                            prefixIcon: Icon(Icons.my_location),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                          child: ListTile(
                        subtitle: MyTextField(
                          controller: polyLong3Controller,
                          hintText: "Enter Longitude 3",
                          obscureText: false,
                          prefixIcon: Icon(Icons.my_location),
                        ),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          subtitle: MyTextField(
                            controller: polyLat4Controller,
                            hintText: "Enter Latitude 4",
                            obscureText: false,
                            prefixIcon: Icon(Icons.my_location),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                          child: ListTile(
                        subtitle: MyTextField(
                          controller: polyLong4Controller,
                          hintText: "Enter Longitude 4",
                          obscureText: false,
                          prefixIcon: Icon(Icons.my_location),
                        ),
                      ))
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  MyButton(
                    buttonText: 'Add Field',
                    onPressed: () => setState(
                      () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
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
                        allowPanningOnScrollingParent: false,
                        // center: LatLng(47.925812, 106.919831),
                        maxZoom: 18,
                        zoom: 9.0,
                        plugins: [EsriPlugin(), DragMarkerPlugin()],
                        onTap: (tapPos, latlng) {
                          polyEditor.add(testPolygon.points, latlng);
                          setState(() => {
                                // polygonList.add(latlng);
                                markers.add(Marker(
                                  builder: (_) => const Icon(
                                    Icons.circle,
                                    size: 25,
                                  ),
                                  point: latlng,
                                )),

                                polygonList.add(latlng),
                                print(polygonList),
                              });
                        },
                      ),
                      //   )
                      // ],
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
                        PolygonLayerWidget(
                            options: PolygonLayerOptions(polygons: polygons)),
                        MarkerLayerWidget(
                            options: MarkerLayerOptions(markers: markers)),

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
                      'Tap at a location to add a coordinate',
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
