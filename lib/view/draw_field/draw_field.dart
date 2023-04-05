import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:gatemate_mobile/model/add_field.dart';
import 'package:gatemate_mobile/view/ui_primatives/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:gatemate_mobile/view/ui_primatives/marker_popup_view.dart';

import '../../model/add_gate_model.dart';

import '../ui_primatives/my_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

List<Marker> markers = [];
int markerId = 0;

class AddFieldRoute extends StatefulWidget {
  const AddFieldRoute({super.key});

  @override
  _AddFieldRoute createState() => _AddFieldRoute();
}

class _AddFieldRoute extends State<AddFieldRoute> {
  AddFieldModel addFieldModel = AddFieldModel();
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
  late var poly1LatLng;
  late var poly2LatLng;
  late var poly3LatLng;
  late var poly4LatLng;

  @override
  void initState() {
    super.initState();
    Future(dialogCoordinates);
    polyLat1Controller.addListener(
      () {},
    );
    polyLat2Controller.addListener(
      () {},
    );
    polyLat3Controller.addListener(
      () {},
    );
    polyLat4Controller.addListener(
      () {},
    );
    polyLong1Controller.addListener(
      () {},
    );
    polyLong2Controller.addListener(
      () {},
    );
    polyLong3Controller.addListener(
      () {},
    );
    polyLong4Controller.addListener(
      () {},
    );
  }

  @override
  void dispose() {
    // teardown goes here
    super.dispose();
  }

  void createPolygon() async {
    setState(() {
      polygonList.clear();
      markers.clear();
    });
    polygonList.add(LatLng(double.parse(polyLat1Controller.text),
        double.parse(polyLong1Controller.text)));
    poly1LatLng = (Marker(
      builder: (_) => const Icon(
        Icons.circle,
        size: 15,
      ),
      point: LatLng(double.parse(polyLat1Controller.text),
          double.parse(polyLong1Controller.text)),
    ));

    markers.add(poly1LatLng);

    polygonList.add(LatLng(double.parse(polyLat2Controller.text),
        double.parse(polyLong2Controller.text)));
    poly2LatLng = (Marker(
      builder: (_) => const Icon(
        Icons.circle,
        size: 15,
      ),
      point: LatLng(double.parse(polyLat2Controller.text),
          double.parse(polyLong2Controller.text)),
    ));

    markers.add(poly2LatLng);

    polygonList.add(LatLng(double.parse(polyLat3Controller.text),
        double.parse(polyLong3Controller.text)));
    poly3LatLng = (Marker(
      builder: (_) => const Icon(
        Icons.circle,
        size: 15,
      ),
      point: LatLng(double.parse(polyLat3Controller.text),
          double.parse(polyLong3Controller.text)),
    ));

    markers.add(poly3LatLng);

    polygonList.add(LatLng(double.parse(polyLat4Controller.text),
        double.parse(polyLong4Controller.text)));

    poly4LatLng = (Marker(
      builder: (_) => const Icon(
        Icons.circle,
        size: 15,
      ),
      point: LatLng(double.parse(polyLat4Controller.text),
          double.parse(polyLong4Controller.text)),
    ));

    markers.add(poly4LatLng);

    var response = await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/addField'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nw': markers.elementAt(0).point.latitude.toString() +
              "|" +
              markers.elementAt(0).point.longitude.toString(),
          'ne': markers.elementAt(1).point.latitude.toString() +
              "|" +
              markers.elementAt(1).point.longitude.toString(),
          'sw': markers.elementAt(2).point.latitude.toString() +
              "|" +
              markers.elementAt(2).point.longitude.toString(),
          'se': markers.elementAt(3).point.latitude.toString() +
              "|" +
              markers.elementAt(3).point.longitude.toString(),
        }));

    var body = jsonDecode(response.body);

    var thingToSendIvris = body['success'];

    // var tiles = await http
    //     .get(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/tile-field?fieldID='));

    // var tileMarkers = jsonDecode(tiles.body);

    // print(thingToSendIvris);
  }

  void saveFieldDialog() {
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
                const Center(
                  child: Text(
                    'Create this as a new field?',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  children: [
                    MyButton(
                      buttonText: 'Yes, Create Field',
                      onPressed: () => setState(
                        () {
                          setState(() {
                            polygonList.clear();
                            markers.clear();
                            polyLat1Controller.clear();
                            polyLat2Controller.clear();
                            polyLat3Controller.clear();
                            polyLat4Controller.clear();
                            polyLong1Controller.clear();
                            polyLong2Controller.clear();
                            polyLong3Controller.clear();
                            polyLong4Controller.clear();
                          });
                          addFieldModel.setMarkers(poly1LatLng);
                          addFieldModel.setMarkers(poly2LatLng);
                          addFieldModel.setMarkers(poly3LatLng);
                          addFieldModel.setMarkers(poly4LatLng);
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: "Field Added Successfully!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green[400],
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                      ),
                    ),
                    MyButton(
                        buttonText: 'No, Don\'t Create Field',
                        onPressed: () => {
                              setState(() {
                                polygonList.clear();
                                markers.clear();
                                polyLat1Controller.clear();
                                polyLat2Controller.clear();
                                polyLat3Controller.clear();
                                polyLat4Controller.clear();
                                polyLong1Controller.clear();
                                polyLong2Controller.clear();
                                polyLong3Controller.clear();
                                polyLong4Controller.clear();
                              }),
                              Navigator.pop(context),
                            }),
                  ],
                ),
              ]));
        });
  }

  Widget getText() {
    if (polygonList.length == 4) {
      return const Text(
        'Tap the "+" to Add the Field',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Tap the Green Button to Add Coordinates To Make a Field',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _getFab() {
    if (polygonList.length >= 4) {
      return FloatingActionButton(
        onPressed: () {
          saveFieldDialog();
        },
        backgroundColor: Colors.green[400],
        child: const Icon(Icons.add),
      );
    } else {
      return FloatingActionButton(
        onPressed: () {
          Future(dialogCoordinates);
        },
        backgroundColor: Colors.green[400],
        child: const Icon(Icons.add_location),
      );
    }
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          subtitle: MyTextField(
                            controller: polyLat1Controller,
                            hintText: "NW Lat 1",
                            obscureText: false,
                            prefixIcon: Icon(Icons.my_location),
                            onChanged: () {
                              print(polyLat1Controller.text);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        subtitle: MyTextField(
                          controller: polyLong1Controller,
                          hintText: "NW Long 1",
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          subtitle: MyTextField(
                              controller: polyLat2Controller,
                              hintText: "NE Lat 2",
                              obscureText: false,
                              prefixIcon: Icon(Icons.my_location)),
                        ),
                      ),
                      Expanded(
                          child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        subtitle: MyTextField(
                          controller: polyLong2Controller,
                          hintText: "NE Long 2",
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          subtitle: MyTextField(
                            controller: polyLat3Controller,
                            hintText: "SW Lat 3",
                            obscureText: false,
                            prefixIcon: Icon(Icons.my_location),
                          ),
                        ),
                      ),
                      Expanded(
                          child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        subtitle: MyTextField(
                          controller: polyLong3Controller,
                          hintText: "SW Long 3",
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          subtitle: MyTextField(
                            controller: polyLat4Controller,
                            hintText: "SE Lat 4",
                            obscureText: false,
                            prefixIcon: Icon(Icons.my_location),
                          ),
                        ),
                      ),
                      Expanded(
                          child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        subtitle: MyTextField(
                          controller: polyLong4Controller,
                          hintText: "SE Long 4",
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
                        createPolygon();
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
                        plugins: [EsriPlugin()],
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
                            options: PolygonLayerOptions(polygons: [
                          Polygon(
                              points: polygonList,
                              color: Colors.green,
                              borderStrokeWidth: 5.0)
                        ])),
                        MarkerLayerWidget(
                            options: MarkerLayerOptions(markers: markers)),
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(10.0),
                          child: _getFab(),
                        ),
                        PopupMarkerLayerWidget(
                          options: PopupMarkerLayerOptions(
                            popupController: _popupController,
                            markers: markers,
                            popupBuilder:
                                (BuildContext context, Marker marker) =>
                                    viewPopup(marker),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: getText(),
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
