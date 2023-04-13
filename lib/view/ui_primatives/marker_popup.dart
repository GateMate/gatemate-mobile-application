//used https://github.com/rorystephenson/flutter_map_marker_popup/blob/master/example/lib/example_popup.dart

// import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/model/viewmodels/gate_management_view_model.dart';
import 'package:gatemate_mobile/view/ui_primatives/my_textfield.dart';
import 'package:http/http.dart' as http;

import 'my_button.dart';

class ExamplePopup extends StatefulWidget {
  final Marker marker;
  // final LatLng latLng;

  const ExamplePopup(this.marker, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExamplePopupState();
}

class _ExamplePopupState extends State<ExamplePopup> {
  late Future<http.Response> httpStuff;
  final gateHeightController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();
  GateManagementViewModel _gateManagementViewModel = GateManagementViewModel();
  String gateHeight = "";
  String lat = "";
  String long = "";

  @override
  void initState() {
    super.initState();
    gateHeightController.addListener(
      () {},
    );
    getHeight();
  }

  getHeight() async {
    print(await _gateManagementViewModel.getGateHeight(
        widget.marker.point.latitude.toString(),
        widget.marker.point.longitude.toString()));
    gateHeight = await _gateManagementViewModel.getGateHeight(
        widget.marker.point.latitude.toString(),
        widget.marker.point.longitude.toString());
  }

  void setHeight(String latitude, String longitude) {
    print(gateHeightController.text);

    setState() {
      gateHeight = gateHeightController.text;
    }

    _gateManagementViewModel.setGateHeight(
        latitude, longitude, gateHeightController.text);
  }

  void setPosition(String latitude, String longitude) {
    print(latController.text);
    print(longController.text);

    setState() {
      lat = latController.text;
      long = longController.text;
    }

    _gateManagementViewModel.updatePosition(lat, long);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[400],
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
          ],
        ),
      ),
    );
  }

  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Gate Information',
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            SizedBox(
              height: 35,
              child: MyTextField(
                  controller: latController,
                  hintText:
                      "Lat: ${widget.marker.point.latitude.toString().substring(0, 6)}",
                  obscureText: false,
                  prefixIcon: const Icon(Icons.location_on_outlined, size: 20)),
            ),
            SizedBox(
              height: 35,
              child: MyTextField(
                  controller: longController,
                  hintText:
                      "Long: ${widget.marker.point.longitude.toString().substring(0, 6)}",
                  obscureText: false,
                  prefixIcon: const Icon(Icons.location_on_outlined, size: 20)),
            ),
            SizedBox(
              height: 35,
              child: MyTextField(
                  controller: gateHeightController,
                  hintText: "GateHeight: $gateHeight",
                  obscureText: false,
                  prefixIcon:
                      const Icon(Icons.roller_shades_outlined, size: 20)),
            ),
            MyButton(
                onPressed: () {
                  setPosition(widget.marker.point.latitude.toString(),
                      widget.marker.point.longitude.toString());
                  setHeight(widget.marker.point.latitude.toString(),
                      widget.marker.point.longitude.toString());
                },
                buttonText: "Update")
          ],
        ),
      ),
    );
  }
}
