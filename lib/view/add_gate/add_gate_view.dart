import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatemate_mobile/model/viewmodels/add_gate_model.dart';
import 'package:gatemate_mobile/view/ui_primatives/marker_popup_view.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../model/firebase/gatemate_auth.dart';
import '../login/login.dart';
import '../ui_primatives/confirmation_button.dart';
import '../ui_primatives/custom_input_field.dart';

// Set<Marker> markers = <Marker>{};
List<Marker> markers = [];
int markerId = 0;

class AddGateView extends StatefulWidget {
  const AddGateView({super.key});

  @override
  _AddGateState createState() => _AddGateState();
}

class _AddGateState extends State<AddGateView> {
  AddGateModel addGateModel = AddGateModel();
  final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);
  final PopupController _popupController = PopupController();
  final addMarkerLatController = TextEditingController();
  final addMarkerLongController = TextEditingController();
  final _authProvider = GetIt.I<GateMateAuth>();

  @override
  void initState() {
    super.initState();
    Future(markerToAddDialog);
    addMarkerLatController.addListener(() {});
    addMarkerLongController.addListener(() {});
    _authProvider.addListener(_checkLoginStatus);
    // addGateModel = Provider.of<AddGateModel>(context, listen: true);
    // addGateModel.addListener(() => mounted ? setState(() {}) : null);

    // initialization goes here
  }

  @override
  void dispose() {
    // teardown goes here
    _authProvider.removeListener(_checkLoginStatus);
    super.dispose();
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

  void addMarker() {
    var m = Marker(
      builder: (_) => const Icon(
        Icons.roller_shades_outlined,
        size: 25,
      ),
      point: LatLng(
        double.parse(addMarkerLatController.text),
        double.parse(addMarkerLongController.text),
      ),
    );
    setState(
      () {
        markers.add(m);
      },
    );
    addGateModel.setMarkers(m);
    _authProvider
        .getAuthToken()
        .then((value) => {addGateModel.addToFB(m, value.toString())});

    Fluttertoast.showToast(
      msg: "Gate Marker Added Successfully!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green[400],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void markerToAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 16,
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  const Text(
                    'Enter the Latitude and Longitude To Add a Gate Marker at that Location:',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            subtitle: CustomInputField(
                              inputController: addMarkerLatController,
                              hintText: "Lat",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.my_location),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            subtitle: CustomInputField(
                              inputController: addMarkerLongController,
                              hintText: "Long",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.my_location),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ConfirmationButton(
                    buttonText: 'Add Gate',
                    onPressed: () => setState(
                      () {
                        addMarker();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

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
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: const Text(
                    'Tap the "+" to add a gate marker or click an existing marker to view details',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(36.133512, -94.121556),
                      // center: LatLng(47.925812, 106.919831),
                      maxZoom: 18,
                      zoom: 9.0,
                      plugins: [EsriPlugin()],
                    ),
                    children: [
                      TileLayerWidget(
                        options: TileLayerOptions(
                          urlTemplate:
                              'https://services.arcgisonline.com/arcgis/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}?apiKey=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578',
                          subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                          tileProvider: NonCachingNetworkTileProvider(),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      PopupMarkerLayerWidget(
                        options: PopupMarkerLayerOptions(
                          popupController: _popupController,
                          markers: [
                            for (int i = 0;
                                i < addGateModel.markers.length;
                                i++)
                              addGateModel.markers[i]
                          ],
                          popupBuilder: (BuildContext context, Marker marker) =>
                              viewPopup(marker),
                        ),
                      ),
                      // MarkerLayerOptions(
                      //   markers: [
                      //     for (int i = 0;
                      //         i < addGateModel.markers.length;
                      //         i++)
                      //       addGateModel.markers[i]
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(10.0),
              child: FloatingActionButton(
                onPressed: () {
                  addMarkerLatController.clear();
                  addMarkerLongController.clear();
                  markerToAddDialog();
                },
                backgroundColor: Colors.green[400],
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<http.Response> fetchElevation(LatLng latLng) {
  //   return http.get(Uri.parse(
  //     'https://api.open-elevation.com/api/v1/lookup?locations=$latLng',
  //   ));
  // }
}
