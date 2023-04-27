import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatemate_mobile/model/firebase/gatemate_auth.dart';
import 'package:gatemate_mobile/model/multiple_gates_view_model.dart';
import 'package:gatemate_mobile/model/viewmodels/gate_management_view_model.dart';
import 'package:gatemate_mobile/view/login/login.dart';
import 'package:gatemate_mobile/view/ui_primatives/confirmation_button.dart';
import 'package:gatemate_mobile/view/ui_primatives/custom_input_field.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

// import '../../model/gate_management_view_model.dart';
import '../ui_primatives/marker_popup.dart';

late int _markerIdValue;
// Set<Marker> _markers = HashSet<Marker>();
late List<Marker> markers = [];
late List<Marker> selectedMarkerColors = [];
String gateHeight = "";

class MultipleGateManagementRoute extends StatefulWidget {
  MultipleGateManagementRoute({super.key});

  @override
  _MultipleGateManagementState createState() => _MultipleGateManagementState();
}

class _MultipleGateManagementState extends State<MultipleGateManagementRoute> {
  final _manageMultipleGatesViewModel = ManageMultipleGatesViewModel();
  final _gateManagementViewModel = GetIt.I<GateManagementViewModel>();
  final _authProvider = GetIt.I<GateMateAuth>();
  final gateHeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    gateHeightController.addListener(
      () {},
    );
    _checkLoginStatus();
    _authProvider.addListener(_checkLoginStatus);
  }

  @override
  void dispose() {
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

  int polyId = 0;

  final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);
  final PopupController _popupController = PopupController();
  var selectedMarkers = <Marker>[];

  void updateHeightDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 16,
              child: Expanded(
                  child: ListView(shrinkWrap: true, children: <Widget>[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const Text("Currently selected gates: "),
                      for (var g in selectedMarkers)
                        Text("Gate: ${g.point.latitude}, ${g.point.longitude}"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          height: 35,
                          child: CustomInputField(
                            inputController: gateHeightController,
                            hintText: "Enter a new height",
                            obscureText: false,
                            prefixIcon: const Icon(Icons.roller_shades_outlined,
                                size: 20),
                          ),
                        ),
                      ),
                      ConfirmationButton(
                        buttonText: 'Update Heights',
                        onPressed: () => {
                          // setState(
                          //   () {
                          for (var m in selectedMarkers)
                            {
                              setHeight(m.point.latitude.toString(),
                                  m.point.longitude.toString()),
                            },
                          selectedMarkers.clear(),
                          selectedMarkerColors.clear(),
                          Navigator.pop(context),
                          Fluttertoast.showToast(
                              msg: "Gates Updated Successfully!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green[400],
                              textColor: Colors.white,
                              fontSize: 16.0),
                        },
                        // ),
                      ),
                      ConfirmationButton(
                          buttonText: 'Cancel',
                          onPressed: () => {
                                selectedMarkers.clear(),
                                selectedMarkerColors.clear(),
                                Navigator.pop(context),
                              }),
                    ],
                  ),
                ),
              ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    _authProvider.getAuthToken().then(
          (value) =>
              _gateManagementViewModel.getGates(value.toString()).then((value) {
            if (mounted) {
              setState(() {
                markers = value;
              });
            }
          }),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Multiple Gates'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: const Text(
                  'Tap on markers to update heights of multiple gates at once.',
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
                    onTap: (_, __) {
                      _popupController.hideAllPopups();
                    },
                  ),
                  nonRotatedChildren: [
                    AttributionWidget.defaultWidget(
                      source: '',
                      onSourceTapped: null,
                    ),
                  ],
                  // layers: [
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
                    // MarkerLayerWidget(
                    //     options: MarkerLayerOptions(
                    //   markers: [
                    //     for (int i = 0;
                    //         i < _manageMultipleGatesViewModel.markers.length;
                    //         i++)
                    //       _manageMultipleGatesViewModel.markers[i],
                    //     // for (int i = 0; i < selectedMarkerColors.length; i++)
                    //     //   selectedMarkerColors[i]
                    //   ],
                    // )),
                    PopupMarkerLayerWidget(
                      options: PopupMarkerLayerOptions(
                        popupController: _popupController,
                        markers: [
                          for (int i = 0; i < markers.length; i++) markers[i],
                          for (int i = 0; i < selectedMarkerColors.length; i++)
                            selectedMarkerColors[i]
                        ],
                        // markerRotateAlignment:
                        //     PopupMarkerLayerOptions.rotationAlignmentFor(
                        //         AnchorAlign.top),
                        // popupBuilder: (BuildContext context, Marker marker) =>
                        //     MarkerPopup(marker),
                        selectedMarkerBuilder: (context, marker) {
                          print("TAP");
                          if (selectedMarkers.length < 3) {
                            if (selectedMarkers.contains(marker) == false) {
                              selectedMarkers.add(marker);
                              selectedMarkerColors.add(
                                Marker(
                                  builder: (_) => const Icon(
                                    Icons.roller_shades_outlined,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                  point: marker.point,
                                ),
                              );
                              print(selectedMarkers);
                            }
                          } else {
                            selectedMarkers.clear();
                            selectedMarkerColors.clear();
                          }
                          return const Text("");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton.extended(
              onPressed: () {
                for (var m in selectedMarkers) {
                  print(m.point);
                }
                updateHeightDialog();
              },
              label: const Text('Change Gate Heights'),
              icon: const Icon(Icons.height),
              backgroundColor: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
}
