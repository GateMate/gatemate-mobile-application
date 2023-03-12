//used https://github.com/rorystephenson/flutter_map_marker_popup/blob/master/example/lib/example_popup.dart

// import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/model/gate_management_view_model.dart';
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
  GateManagementViewModel _gateManagementViewModel = GateManagementViewModel();
  late var gateHeight;

  @override
  void initState() {
    super.initState();
    gateHeightController.addListener(
      () {},
    );
  }

  void setHeight(String latitude, String longitude) {
    print(gateHeightController.text);

    setState() {
      gateHeight = gateHeightController.text;
    }

    _gateManagementViewModel.setGateHeight(
        latitude, longitude, gateHeightController.text);
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
            // IconButton(
            //   icon: const Icon(Icons.arrow_upward),
            //   onPressed: () {
            // showDialog(
            //   context: context,
            //   builder: (context) {
            //     return Dialog(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(40),
            //       ),
            //       elevation: 16,
            //       child: ListView(
            //         shrinkWrap: true,
            //         children: <Widget>[
            //           const SizedBox(height: 20),
            //           const Center(
            //             child: Text(
            //               'Are you sure you want to raise this gate?',
            //               style: TextStyle(fontSize: 20),
            //               textAlign: TextAlign.center,
            //             ),
            //           ),
            //           Column(
            //             children: [
            //               MyButton(
            //                   buttonText: "Yes, Raise Gate",
            //                   onPressed: ()
            //                   async => {
            //                         httpStuff = http.get(Uri.parse(
            //                             'http://172.20.10.10:8000')),
            //                         Navigator.pop(context),
            //                       }
            //                       ),
            //               MyButton(
            //                 buttonText: 'No, Don\'t Raise the gate',
            //                 onPressed: () => Navigator.pop(context),
            //               )
            //             ],
            //           ),
            //           const SizedBox(height: 20),
            //         ],
            //       ),
            //     );
            //   },
            // );
            //   },
            //   tooltip: "Raise Gates",
            // ),
            // IconButton(
            //   padding: EdgeInsets.zero,
            //   icon: const Icon(Icons.arrow_downward),
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return Dialog(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(40),
            //           ),
            //           elevation: 16,
            //           child: ListView(
            //             shrinkWrap: true,
            //             children: <Widget>[
            //               const SizedBox(height: 20),
            //               const Center(
            //                 child: Text(
            //                   'Are you sure you want to lower this gate?',
            //                   style: TextStyle(fontSize: 20),
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ),
            //               Column(
            //                 children: [
            //                   MyButton(
            //                     buttonText: 'Yes, Lower Gate',
            //                     onPressed: () => Navigator.pop(context),
            //                   ),
            //                   MyButton(
            //                     buttonText: 'No, Don\'t Lower the Gate',
            //                     onPressed: () => Navigator.pop(context),
            //                   ),
            //                 ],
            //               ),
            //               const SizedBox(height: 20),
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //   },
            //   tooltip: "Lower Gates",
            // ),
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
            Text(
              'Position: ${widget.marker.point.latitude}, ${widget.marker.point.longitude}',
              style: const TextStyle(fontSize: 12.0),
            ),
            // const Text(
            //   'Current Water Levels:',
            //   style: TextStyle(fontSize: 12.0),
            // ),
            SizedBox(
              height: 35,
              child: MyTextField(
                  controller: gateHeightController,
                  hintText: "Gate Height",
                  obscureText: false,
                  prefixIcon:
                      const Icon(Icons.roller_shades_outlined, size: 20)),
            ),
            MyButton(
                onPressed: () {
                  setHeight(widget.marker.point.latitude.toString(),
                      widget.marker.point.longitude.toString());
                },
                buttonText: "Save Height")
          ],
        ),
      ),
    );
  }
}
