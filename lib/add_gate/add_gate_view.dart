import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../app_constants.dart';

class AddGateRoute extends StatelessWidget {
  const AddGateRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gate'),
      ),
      body: Center(
        // child: MapboxMap(
        //   accessToken:
        //       "pk.eyJ1IjoiY3BhdHRvbiIsImEiOiJjbGRodG1pZ3kweWFyM3ZvM2trcjY5d3liIn0.Th1u92jVxkdhJp1-pcJpdA",
        //   onMapCreated: onMapCreated,
        //   initialCameraPosition: _kInitialPosition,
        //   trackCameraPosition: true,
        //   styleString: 'mapbox://styles/dimoll/ckt01jn3m7amx17qnidfw4rd7',
        //   myLocationRenderMode: MyLocationRenderMode.GPS,
        //   onMapClick: onMapClick,
        // ),
        child: FlutterMap(
          options: MapOptions(
            minZoom: 5,
            maxZoom: 18,
            zoom: 13,
            center: AppConstants.myLocation,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/cpatton/cldievrq0000301o10nbx1zvu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY3BhdHRvbiIsImEiOiJjbGRodG1pZ3kweWFyM3ZvM2trcjY5d3liIn0.Th1u92jVxkdhJp1-pcJpdA",
              additionalOptions: {
                'mapStyleId': AppConstants.mapBoxStyleId,
                'accessToken': AppConstants.mapBoxAccessToken,
              },
            ),
          ],
        ),
        // child: ElevatedButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   child: const Text('adding a gate'),
        // ),
      ),
    );
  }
}
