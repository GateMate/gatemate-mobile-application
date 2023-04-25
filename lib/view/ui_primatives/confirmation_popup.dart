//used https://github.com/rorystephenson/flutter_map_marker_popup/blob/master/example/lib/example_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'confirmation_button.dart';

class ConfirmationPopup extends StatefulWidget {
  final Marker marker;
  // final LatLng latLng;

  const ConfirmationPopup(this.marker, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConfirmationPopupState();
}

class _ConfirmationPopupState extends State<ConfirmationPopup> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[400],
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 16,
                      child: Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                'Are you sure you want to raise this gate?',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Column(
                              children: [
                                ConfirmationButton(
                                  buttonText: "Yes, Raise Gate",
                                  onPressed: () => Navigator.pop(context),
                                ),
                                ConfirmationButton(
                                  buttonText: 'No, Don\'t Raise the gate',
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              tooltip: "Raise Gates",
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_downward),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 16,
                      child: Expanded(
                          child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              'Are you sure you want to lower this gate?',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Column(
                            children: [
                              ConfirmationButton(
                                buttonText: 'Yes, Lower Gate',
                                onPressed: () => Navigator.pop(context),
                              ),
                              ConfirmationButton(
                                buttonText: 'No, Don\'t Lower the Gate',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),
                    );
                  },
                );
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
              'Position: ${widget.marker.point.latitude}, ${widget.marker.point.longitude}',
              style: const TextStyle(fontSize: 12.0),
            ),
            const Text(
              'Current Water Levels:',
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
