import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_line_editor/polyeditor.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatemate_mobile/model/add_field.dart';
import 'package:gatemate_mobile/model/firebase/gatemate_auth.dart';
import 'package:gatemate_mobile/model/viewmodels/add_gate_model.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:gatemate_mobile/view/login/login.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../ui_primatives/confirmation_button.dart';
import '../ui_primatives/custom_input_field.dart';

List<Marker> markers = [];
List<Marker> gates = [];
int markerId = 0;
String fieldID = "";

class AddFieldRoute extends StatefulWidget {
  const AddFieldRoute({super.key});

  @override
  _AddFieldRoute createState() => _AddFieldRoute();
}

class _AddFieldRoute extends State<AddFieldRoute> {
  final addFieldModel = AddFieldModel();
  final _authProvider = GetIt.I<GateMateAuth>();
  final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);
  final PopupController _popupController = PopupController();
  late List<LatLng> polygonList = <LatLng>[];
  late List<LatLng> polygon0List = <LatLng>[];
  late List<LatLng> polygon1List = <LatLng>[];
  late List<LatLng> polygon2List = <LatLng>[];
  late List<LatLng> polygon3List = <LatLng>[];
  late PolyEditor polyEditor;
  List<LatLng> poly0List = <LatLng>[LatLng(0, 0)];
  late List<LatLng> poly1List = <LatLng>[];
  late List<LatLng> poly2List = <LatLng>[];
  late List<LatLng> poly3List = <LatLng>[];
  late List<Polygon> polygons = <Polygon>[];
  final polyLat1Controller = TextEditingController();
  final polyLong1Controller = TextEditingController();
  final polyLat2Controller = TextEditingController();
  final polyLong2Controller = TextEditingController();
  final polyLat3Controller = TextEditingController();
  final polyLong3Controller = TextEditingController();
  final polyLat4Controller = TextEditingController();
  final polyLong4Controller = TextEditingController();
  final fieldNameController = TextEditingController();
  final _fieldsViewModel = GetIt.I<FieldsViewModel>();
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
    fieldNameController.addListener(
      () {},
    );
    _checkLoginStatus();
    _authProvider.addListener(_checkLoginStatus);
  }

  @override
  void dispose() {
    // teardown goes here
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

  void createPolygon() async {
    setState(() {
      polygonList.clear();
      polygon0List.clear();
      polygon1List.clear();
      polygon2List.clear();
      polygon3List.clear();
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

    print(polygonList);

    poly4LatLng = (Marker(
      builder: (_) => const Icon(
        Icons.circle,
        size: 15,
      ),
      point: LatLng(double.parse(polyLat4Controller.text),
          double.parse(polyLong4Controller.text)),
    ));

    markers.add(poly4LatLng);
    // var response;

    await _authProvider
        .getAuthToken()
        .then((value) => createField(value.toString()));
  }

  void createField(String token) async {
    var responseBody;
    var response = await http
        .post(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/addField'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': token,
            },
            body: jsonEncode(<String, String>{
              'ne': markers.elementAt(0).point.latitude.toString() +
                  "|" +
                  markers.elementAt(0).point.longitude.toString(),
              'nw': markers.elementAt(1).point.latitude.toString() +
                  "|" +
                  markers.elementAt(1).point.longitude.toString(),
              'sw': markers.elementAt(2).point.latitude.toString() +
                  "|" +
                  markers.elementAt(2).point.longitude.toString(),
              'se': markers.elementAt(3).point.latitude.toString() +
                  "|" +
                  markers.elementAt(3).point.longitude.toString(),
              'fieldName': fieldNameController.text.toString(),
            }))
        .then((value) {
      // getField(token);
      responseBody = jsonDecode(value.body);
      // print(responseBody);
      fieldID = responseBody['fieldID'].toString();

      print("GIMME FIELD ID" + fieldID);
      _fieldsViewModel.refresh();

      drawSquares(token, fieldID);
    });

    // var responseBody = jsonDecode(response.body);
    // print(responseBody);

    // fieldID = responseBody['success'].toString();

    // print("GIMME FIELD ID" + fieldID.toString());

    // drawSquares(token);
  }

  // getField(String token) async {
  //   var response = await http
  //       .post(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/getField'),
  //           headers: <String, String>{
  //             'Content-Type': 'application/json; charset=UTF-8',
  //           },
  //           body: jsonEncode(<String, String>{'auth_token': token}))
  //       .then((value) {
  //     print(value.body);
  //   });
  // }

  drawSquares(String token, String field) async {
    var tiles = await http.post(
        Uri.parse('https://todo-proukhgi3a-uc.a.run.app/tile-field'),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode(<String, String>{'fieldID': '${field}'}));

    // print(tiles.body);

    print(tiles.body);

    var jsonDecodeGatePlacement = (jsonDecode(tiles.body) as Map).map(
        (key, value) => MapEntry(key as String, value as Map<String, dynamic>));

    // print(jsonDecodeGatePlacement);

    for (var i = 0; i < jsonDecodeGatePlacement.length; i++) {
      // print(jsonDecodeGatePlacement[i.toString()]!['height_val'].runtimeType);
      // setState(() {
      if (jsonDecodeGatePlacement[i.toString()]!['height_val'] == 0) {
        // print("HOWDYYYYY 0");
        setState(() {
          polygon0List.clear();
          polygon0List.add(LatLng(
              double.parse(jsonDecodeGatePlacement[i.toString()]!['nw_point']
                  .toString()
                  .split('|')[0]),
              double.parse(jsonDecodeGatePlacement[i.toString()]!['nw_point']
                  .toString()
                  .split('|')[1])));
          polygon0List.add(LatLng(
              double.parse(jsonDecodeGatePlacement[i.toString()]!['ne_point']
                  .toString()
                  .split('|')[0]),
              double.parse(jsonDecodeGatePlacement[i.toString()]!['ne_point']
                  .toString()
                  .split('|')[1])));
          polygon0List.add(LatLng(
              double.parse(jsonDecodeGatePlacement[i.toString()]!['se_point']
                  .toString()
                  .split('|')[0]),
              double.parse(jsonDecodeGatePlacement[i.toString()]!['se_point']
                  .toString()
                  .split('|')[1])));
          polygon0List.add(LatLng(
              double.parse(jsonDecodeGatePlacement[i.toString()]!['sw_point']
                  .toString()
                  .split('|')[0]),
              double.parse(jsonDecodeGatePlacement[i.toString()]!['sw_point']
                  .toString()
                  .split('|')[1])));
          // if (polygon0List.length == 4) {
          // print("POLYGON" + polygon0List.toString());
          getPoints(polygon0List, Colors.purple);
        });
        // }
      } else if (jsonDecodeGatePlacement[i.toString()]!['height_val'] == 1) {
        polygon1List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['nw_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['nw_point']
                .toString()
                .split('|')[1])));
        polygon1List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['ne_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['ne_point']
                .toString()
                .split('|')[1])));
        polygon1List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['se_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['se_point']
                .toString()
                .split('|')[1])));
        polygon1List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['sw_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['sw_point']
                .toString()
                .split('|')[1])));
        getPoints(polygon1List, Colors.blue);
      } else if (jsonDecodeGatePlacement[i.toString()]!['height_val'] == 2) {
        polygon2List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['nw_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['nw_point']
                .toString()
                .split('|')[1])));
        polygon2List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['ne_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['ne_point']
                .toString()
                .split('|')[1])));
        polygon2List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['se_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['se_point']
                .toString()
                .split('|')[1])));
        polygon2List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['sw_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['sw_point']
                .toString()
                .split('|')[1])));
        getPoints(polygon2List, Colors.red);
      } else if (jsonDecodeGatePlacement[i.toString()]!['height_val'] == 3) {
        polygon3List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['nw_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['nw_point']
                .toString()
                .split('|')[1])));
        polygon3List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['ne_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['ne_point']
                .toString()
                .split('|')[1])));
        polygon3List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['se_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['se_point']
                .toString()
                .split('|')[1])));
        polygon3List.add(LatLng(
            double.parse(jsonDecodeGatePlacement[i.toString()]!['sw_point']
                .toString()
                .split('|')[0]),
            double.parse(jsonDecodeGatePlacement[i.toString()]!['sw_point']
                .toString()
                .split('|')[1])));
        getPoints(polygon3List, Colors.orange);
      }
      // });
    }
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
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
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
                    ConfirmationButton(
                      buttonText: 'Yes, Create Field',
                      onPressed: () => setState(
                        () {
                          setState(() {
                            polygonList.clear();
                            polygon0List.clear();
                            polygon1List.clear();
                            polygon2List.clear();
                            polygon3List.clear();
                            markers.clear();
                            gates.clear();
                            polygons.clear();
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
                            fontSize: 16.0,
                          );
                        },
                      ),
                    ),
                    ConfirmationButton(
                      buttonText: 'No, Don\'t Create Field',
                      onPressed: () => {
                        _authProvider.getAuthToken().then(
                              ((value) => addFieldModel.deleteField(
                                  fieldID, value.toString())),
                            ),
                        setState(() {
                          polygonList.clear();
                          polygon0List.clear();
                          polygon1List.clear();
                          polygon2List.clear();
                          polygon3List.clear();
                          markers.clear();
                          gates.clear();
                          polygons.clear();
                          poly0List.clear();
                          poly1List.clear();
                          poly2List.clear();
                          poly3List.clear();
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
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget getText() {
    if (polygonList.length == 4) {
      return const Text(
        'Tap to place a gate on the borders between colors,\nTap the "+" to Add or Delete the Field',
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
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            subtitle: CustomInputField(
                              inputController: fieldNameController,
                              hintText: "Enter a Field Name",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.text_fields),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    child: Text(
                      'Enter Latitude and Longitude Values for 4 Points to Create a Field Within Those Points:',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            subtitle: CustomInputField(
                              inputController: polyLat1Controller,
                              hintText: "NW Lat 1",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.my_location),
                            ),
                          ),
                        ),
                        Expanded(
                            child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          subtitle: CustomInputField(
                            inputController: polyLong1Controller,
                            hintText: "NW Long 1",
                            obscureText: false,
                            prefixIcon: const Icon(Icons.my_location),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            subtitle: CustomInputField(
                              inputController: polyLat2Controller,
                              hintText: "NE Lat 2",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.my_location),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            subtitle: CustomInputField(
                              inputController: polyLong2Controller,
                              hintText: "NE Long 2",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.my_location),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            subtitle: CustomInputField(
                              inputController: polyLat3Controller,
                              hintText: "SE Lat 3",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.my_location),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            subtitle: CustomInputField(
                              inputController: polyLong3Controller,
                              hintText: "SE Long 3",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.my_location),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            subtitle: CustomInputField(
                              inputController: polyLat4Controller,
                              hintText: "SW Lat 4",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.my_location),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            subtitle: CustomInputField(
                              inputController: polyLong4Controller,
                              hintText: "SW Long 4",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.my_location),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ConfirmationButton(
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
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: getText(),
                ),
                Flexible(
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(36.133512, -94.121556),
                      allowPanningOnScrollingParent: false,
                      // center: LatLng(47.925812, 106.919831),
                      maxZoom: 18,
                      zoom: 9.0,
                      onTap: (tapPosition, point) {
                        setState(() {
                          var gate = Marker(
                            point: point,
                            builder: (_) => const Icon(
                              Icons.roller_shades_outlined,
                              size: 25,
                            ),
                          );
                          gates.add(gate);
                          _authProvider.getAuthToken().then(
                                (value) => addFieldModel.addToFB(
                                  gate,
                                  fieldID,
                                  value.toString(),
                                ),
                              );
                        });
                      },
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
                          // backgroundColor: Colors.transparent,
                        ),
                      ),
                      PolygonLayerWidget(
                        options: PolygonLayerOptions(
                          polygons: polygons +
                              [
                                Polygon(
                                  points: polygonList,
                                  borderStrokeWidth: 5.0,
                                  borderColor: Colors.black,
                                ),
                              ],
                        ),
                      ),
                      MarkerLayerWidget(
                        options: MarkerLayerOptions(markers: markers + gates),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(10.0),
              child: _getFab(),
            ),
          ],
        ),
      ),
    );
  }

  List<Polygon> getPoints(List<LatLng> list, Color color) {
    polyEditor = PolyEditor(
      pointIcon: const Icon(
        Icons.lens,
        size: 15,
        color: Colors.orange,
      ),
      points: [
        for (int p = 0; p < list.length; p = p + 4)
          {
            setState(() {
              polygons.add(
                Polygon(
                  points: <LatLng>[
                    list[p],
                    list[p + 1],
                    list[p + 2],
                    list[p + 3],
                  ],
                  color: color,
                  isFilled: true,
                ),
              );
            }),
          },
      ],
    );

    return polygons;
  }
}
