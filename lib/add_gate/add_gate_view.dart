import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../app_constants.dart';

class AddGateRoute extends StatelessWidget {
  const AddGateRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Gate'),
        ),
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                  minZoom: 5,
                  maxZoom: 18,
                  zoom: 13,
                  center: AppConstants.myLocation),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/cpatton/cldievrq0000301o10nbx1zvu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY3BhdHRvbiIsImEiOiJjbGRodG1pZ3kweWFyM3ZvM2trcjY5d3liIn0.Th1u92jVxkdhJp1-pcJpdA",
                  // "https://api.mapbox.com/styles/v1/dhruv25/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                  additionalOptions: {
                    'mapStyleId': 'mapbox.mapbox-outdoors-v11',
                    'accessToken': AppConstants.mapBoxAccessToken,
                  },
                ),
              ],
            )
          ],
        )
        // child: FlutterMap(
        //   options: MapOptions(
        //     minZoom: 5,
        //     maxZoom: 18,
        //     zoom: 13,
        //     center: AppConstants.myLocation,
        //   ),
        //   layers: [
        //     TileLayerOptions(
        //       urlTemplate:
        //           "https://api.mapbox.com/styles/v1/cpatton/cldievrq0000301o10nbx1zvu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY3BhdHRvbiIsImEiOiJjbGRodG1pZ3kweWFyM3ZvM2trcjY5d3liIn0.Th1u92jVxkdhJp1-pcJpdA",
        //       additionalOptions: {
        //         'mapStyleId': AppConstants.mapBoxStyleId,
        //         'accessToken': AppConstants.mapBoxAccessToken,
        //       },
        //     ),
        //   ],
        // ),
        // child: ElevatedButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   child: const Text('adding a gate'),
        // ),

        );
  }
}
