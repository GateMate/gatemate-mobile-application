//used https://github.com/rorystephenson/flutter_map_marker_popup/blob/master/example/lib/example_popup.dart

// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/my_button.dart';
import 'package:latlong2/latlong.dart';

class ExamplePopup extends StatefulWidget {
  final Marker marker;
  // final LatLng latLng;

  const ExamplePopup(this.marker, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExamplePopupState();
}

class _ExamplePopupState extends State<ExamplePopup> {
  @override
  Widget build(BuildContext context) {
    print("in popup");
    return Card(
      color: Colors.green[400],
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
            IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        elevation: 16,
                        child: Container(
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Center(
                                  child: Text(
                                      'Are you sure you want to raise this gate?',
                                      style: const TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center)),
                              Column(children: [
                                MyButton(
                                    buttonText: "Yes, Raise Gate",
                                    onPressed: () => Navigator.pop(context)),
                                MyButton(
                                    buttonText: 'No, Don\'t Raise the gate',
                                    onPressed: () => Navigator.pop(context))
                              ]),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    });
              },
              tooltip: "Raise Gates",
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        elevation: 16,
                        child: Container(
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Center(
                                  child: Text(
                                      'Are you sure you want to lower this gate?',
                                      style: const TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center)),
                              Column(children: [
                                MyButton(
                                    buttonText: 'Yes, Lower Gate',
                                    onPressed: () => Navigator.pop(context)),
                                MyButton(
                                    buttonText: 'No, Don\'t Lower the Gate',
                                    onPressed: () => Navigator.pop(context))
                              ]),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    });
              },
              tooltip: "Lower Gates",
            ),
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
              // 'Position: ${widget.marker.point.latitude}, ${widget.marker.point.longitude}',
              'Position: ${widget.marker.point.latitude}, ${widget.marker.point.longitude}',
              style: const TextStyle(fontSize: 12.0),
            ),
            Text(
              'Current Water Levels:',
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
