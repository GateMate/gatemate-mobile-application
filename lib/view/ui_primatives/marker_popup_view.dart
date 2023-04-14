//used https://github.com/rorystephenson/flutter_map_marker_popup/blob/master/example/lib/example_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gatemate_mobile/view/ui_primatives/my_textfield.dart';

import 'my_button.dart';

class viewPopup extends StatefulWidget {
  final Marker marker;
  // final LatLng latLng;

  const viewPopup(this.marker, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _viewPopupState();
}

class _viewPopupState extends State<viewPopup> {
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
            Text(
              'Position: ${widget.marker.point.latitude}, ${widget.marker.point.longitude}',
              style: const TextStyle(fontSize: 12.0),
            ),
            // const Text(
            //   'Current Water Levels:',
            //   style: TextStyle(fontSize: 12.0),
            // ),
          ],
        ),
      ),
    );
  }
}
