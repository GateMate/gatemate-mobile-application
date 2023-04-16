//used https://github.com/rorystephenson/flutter_map_marker_popup/blob/master/example/lib/example_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/model/firebase/gatemate_auth.dart';
import 'package:gatemate_mobile/model/viewmodels/gate_management_view_model.dart';
import 'package:gatemate_mobile/view/ui_primatives/confirmation_button.dart';
import 'package:gatemate_mobile/view/ui_primatives/custom_input_field.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../login/login.dart';

class MarkerPopup extends StatefulWidget {
  final Marker marker;
  // final LatLng latLng;

  const MarkerPopup(this.marker, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MarkerPopupState();
}

class _MarkerPopupState extends State<MarkerPopup> {
  late Future<http.Response> httpStuff;
  final gateHeightController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();
  final _gateManagementViewModel = GateManagementViewModel();
  String gateHeight = "";
  String lat = "";
  String long = "";
  final _authProvider = GetIt.I<GateMateAuth>();

  @override
  void initState() {
    super.initState();
    gateHeightController.addListener(
      () {},
    );
    _authProvider.addListener(_checkLoginStatus);
    getHeight();
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

  getHeight() async {
    _authProvider.getAuthToken().then((value) => getHeightFromFB(
        widget.marker.point.latitude.toString(),
        widget.marker.point.longitude.toString(),
        value.toString()));
  }

  getHeightFromFB(String latitude, String longitude, String token) async {
    gateHeight = await _gateManagementViewModel.getGateHeight(
        latitude, longitude, token);
  }

  void setHeight(String latitude, String longitude) {
    print(gateHeightController.text);

    if (gateHeightController.text.isNotEmpty) {
      setState() {
        gateHeight = gateHeightController.text;
      }

      _authProvider.getAuthToken().then((value) => setHeightInFB(
          latitude, longitude, gateHeightController.text, value.toString()));
    }
  }

  setHeightInFB(
      String latitude, String longitude, String height, String token) async {
    _gateManagementViewModel.setGateHeight(latitude, longitude, height, token);
  }

  setPosition(String latitude, String longitude) {
    print(latController.text);
    print(longController.text);

    if (latController.text.isNotEmpty && longController.text.isNotEmpty) {
      setState() {
        lat = latController.text;
        long = longController.text;
      }

      _authProvider.getAuthToken().then((value) => setPositionInFB(
          latitude,
          longitude,
          latController.text,
          longController.text,
          value.toString()));
    }
    ;
  }

  setPositionInFB(String latitude, String longitude, String newLat,
      String newLong, String token) async {
    _gateManagementViewModel.setPosition(
        latitude, longitude, newLat, newLong, token);
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
              child: CustomInputField(
                inputController: latController,
                hintText:
                    "Lat: ${widget.marker.point.latitude.toString().substring(0, 6)}",
                obscureText: false,
                prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
              ),
            ),
            SizedBox(
              height: 35,
              child: CustomInputField(
                inputController: longController,
                hintText:
                    "Long: ${widget.marker.point.longitude.toString().substring(0, 6)}",
                obscureText: false,
                prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
              ),
            ),
            SizedBox(
              height: 35,
              child: CustomInputField(
                inputController: gateHeightController,
                hintText: "GateHeight: $gateHeight",
                obscureText: false,
                prefixIcon: const Icon(Icons.roller_shades_outlined, size: 20),
              ),
            ),
            // ConfirmationButton(
            //   onPressed: () {
            //     setPosition(
            //       widget.marker.point.latitude.toString(),
            //       widget.marker.point.longitude.toString(),
            //     );
            //     setHeight(
            //       widget.marker.point.latitude.toString(),
            //       widget.marker.point.longitude.toString(),
            //     );
            //   },
            //   buttonText: "Update",
            // ),
            ConfirmationButton(
                onPressed: () {
                  // if (lat != "" && long != "") {
                  setPosition(widget.marker.point.latitude.toString(),
                      widget.marker.point.longitude.toString());
                  // }
                  if (gateHeight.length > 0) {
                    setHeight(widget.marker.point.latitude.toString(),
                        widget.marker.point.longitude.toString());
                  }
                },
                buttonText: "Update")
          ],
        ),
      ),
    );
  }
}
