import 'package:flutter/material.dart';
import 'package:gatemate_mobile/main.dart';
// import 'package:gatemate_mobile/map_pin_pill/map_pin_pill.dart';
// import 'package:gatemate_mobile/map_pin_pill/map_pin_pill_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gatemate_mobile/model/add_gate_model.dart';
import 'package:custom_info_window/custom_info_window.dart';
// import 'package:clippy_flutter/triangle.dart';
import 'package:http/http.dart' as http;

Set<Marker> _markers = <Marker>{};
int markerId = 0;

class AddGateRoute extends StatefulWidget {
  @override
  _AddGateState createState() => _AddGateState();
}

class _AddGateState extends State<AddGateRoute> {
  AddGateModel addGateModel = AddGateModel();
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(36.06889761358809, -94.17477200170791);

  @override
  void initState() {
    super.initState();
    // addGateModel = Provider.of<AddGateModel>(context, listen: true);
    // addGateModel.addListener(() => mounted ? setState(() {}) : null);

    // initialization goes here
  }

  @override
  void dispose() {
    // teardown goes here
    super.dispose();
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  //   AddGateModel().addListener(() {
  //     print('markers ${AddGateModel().markers.toString()}');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // var addGateModelMarkers = context.watch<AddGateModel>().markers;
    // addGateModel = Provider.of<AddGateModel>(context, listen: true);'
    markerId++;
    return ChangeNotifierProvider(
        create: (context) => AddGateModel(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Add Gate'),
              backgroundColor: Colors.green[700],
            ),
            body: Stack(children: <Widget>[
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _customInfoWindowController.googleMapController = controller;
                },
                mapType: MapType.terrain,
                onLongPress: (latLng) => {
                  // <Widget>[
                  //   AlertDialog(
                  //     title: Text(
                  //         'Welcome'), // To display the title it is optional
                  //     content: Text(
                  //         'GeeksforGeeks'), // Message which will be pop up on the screen
                  //     actions: [
                  //       // Action widget which will provide the user to acknowledge the choice
                  //       TextButton(
                  //         // FlatButton widget is used to make a text to work like a button
                  //         // textColor: Colors.black,
                  //         onPressed:
                  //             () {}, // function used to perform after pressing the button
                  //         child: Text('CANCEL'),
                  //       ),
                  //       TextButton(
                  //         // textColor: Colors.black,
                  //         onPressed: () {},
                  //         child: Text('ACCEPT'),
                  //       ),
                  //     ],
                  //   ),
                  // ],
                  _addNewMarkers(latLng),
                  AddGateModel().setMarkers(
                      Marker(markerId: MarkerId('$markerId'), position: latLng))
                },
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                markers: _markers,
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Text('Press and hold at a location to add a gate',
                      style: const TextStyle(
                          fontSize: 20, backgroundColor: Colors.white)))

              // CustomInfoWindow(
              //   controller: _customInfoWindowController,
              //   height: 75,
              //   width: 150,
              //   offset: 50,
              // ),
            ])));
  }

  void _addNewMarkers(LatLng latLng) {
    markerId++;
    var lat = latLng.latitude;
    var long = latLng.longitude;
    var formatLat = lat.toStringAsFixed(3);
    var formatLong = long.toStringAsFixed(3);
    var elevation = fetchElevation(latLng);

    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('$markerId'),
          position: LatLng(lat, long),
          // onTap: () {
          //   _customInfoWindowController.addInfoWindow!(
          //     Column(
          //       children: [
          //         Expanded(
          //           child: Container(
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(4),
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Icon(
          //                     Icons.account_circle,
          //                     color: Colors.blue,
          //                     size: 30,
          //                   ),
          //                   SizedBox(
          //                     width: 8.0,
          //                   ),
          //                   Text("I am here",
          //                       style: Theme.of(context).textTheme.headline6
          //                       // .copyWith(
          //                       //   color: Colors.white,
          //                       // ),
          //                       )
          //                 ],
          //               ),
          //             ),
          //             width: double.infinity,
          //             height: double.infinity,
          //           ),
          //         ),
          //         // Triangle.isosceles(
          //         //   edge: Edge.BOTTOM,
          //         //   child: Container(
          //         //     color: Colors.blue,
          //         //     width: 20.0,
          //         //     height: 10.0,
          //         //   ),
          //         // ),
          //       ],
          //     ),
          //     LatLng(lat, long),
          //   );
          // },
          infoWindow: InfoWindow(
              title: 'Gate Information',
              snippet:
                  'Position: $formatLat, $formatLong, Elevation: $elevation')));
      // AddMarkers().addMarkerToVM(_markers, context);
    });
  }

  Future<http.Response> fetchElevation(LatLng latLng) {
    return http.get(Uri.parse(
        'https://api.open-elevation.com/api/v1/lookup?locations=$latLng'));
  }
}
