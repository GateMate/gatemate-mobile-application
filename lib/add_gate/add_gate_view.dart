import 'package:flutter/material.dart';
import 'package:gatemate_mobile/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gatemate_mobile/model/add_gate_model.dart';

Set<Marker> _markers = <Marker>{};
int markerId = 0;

class AddGateRoute extends StatefulWidget {
  @override
  _AddGateState createState() => _AddGateState();
}

class _AddGateState extends State<AddGateRoute> {
  AddGateModel addGateModel = AddGateModel();

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

  late GoogleMapController mapController;
  // final Set<Marker> _markers = Set();
  final LatLng _center = const LatLng(36.06889761358809, -94.17477200170791);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  //   AddGateModel().addListener(() {
  //     print('markers ${AddGateModel().markers.toString()}');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // var addGateModelMarkers = context.watch<AddGateModel>().markers;
    // addGateModel = Provider.of<AddGateModel>(context, listen: true);
    markerId++;
    return ChangeNotifierProvider(
        create: (context) => AddGateModel(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Add Gate'),
              backgroundColor: Colors.green[700],
            ),
            body: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              mapType: MapType.terrain,
              onLongPress: (latLng) => {
                _addNewMarkers(latLng),
                AddGateModel().setMarkers(
                    Marker(markerId: MarkerId('$markerId'), position: latLng))
              },
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
              markers: _markers,
            )));
  }

  void _addNewMarkers(LatLng latLng) {
    markerId++;
    var lat = latLng.latitude;
    var long = latLng.longitude;
    var formatLat = lat.toStringAsFixed(3);
    var formatLong = long.toStringAsFixed(3);
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('$markerId'),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(
              title: 'Gate Information',
              snippet: 'Position: $formatLat, $formatLong')));
      // AddMarkers().addMarkerToVM(_markers, context);
    });
  }
}

// class AddMarkers extends StatelessWidget {
//   AddMarkers(int id, LatLng latLng, {super.key});

//   AddGateModel addGateModel = AddGateModel();

//  AddGateModel().setMarkers(
//                     Marker(markerId: MarkerId('$markerId'), position: latLng))

//   @override
//   Widget build(BuildContext context) {
//     AddGateModel().setMarkers(Marker(markerId: MarkerId('$markerId'), position: latLng))
    
//   }
// }

//   double get latitude => 0.0;
//   double get longitude => 0.0;

//   void addMarkerToVM(Set<Marker> setMarkers, BuildContext context) {
//     AddGateModel().markers.clear();
//     for (Marker marker in setMarkers) {
//       AddGateModel().markers.add(marker);
//     }
//     print(AddGateModel().markers.toList().toString());

//     var savedMarkers = context.watch<AddGateModel>().markers;
//   }

//   @override
//   Widget build(BuildContext context) {
//     AddGateModel().markers = _markers;
//     print('addmarkers: $AddGateModel().markers.toList().toString()');

//     var savedMarkers = context.watch<AddGateModel>().markers;

//     return Text(savedMarkers.toString());
//     // _markers = context.watch<AddGaxxteModel>().markers;
//   }
// }

// class AddMarkers extends StatelessWidget {
//   AddMarkers({super.key});

//   @override
//   Widget build(BuildContext context) {
//     _markers = context.watch<AddGateModel>().markers;
//   }
// }