import 'package:flutter/material.dart';
import 'package:gatemate_mobile/main.dart';

import 'package:provider/provider.dart';
import 'package:gatemate_mobile/model/add_gate_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:gatemate_mobile/marker_popup.dart';

Set<Marker> _markers = <Marker>{};
int markerId = 0;

class AddGateRoute extends StatefulWidget {
  @override
  _AddGateState createState() => _AddGateState();
}

class _AddGateState extends State<AddGateRoute> {
  AddGateModel addGateModel = AddGateModel();
  final LatLng _center = LatLng(36.06889761358809, -94.17477200170791);

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
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child: FlutterMap(
                    options: MapOptions(
                        center: LatLng(32.91081899999999, -92.734876),
                        // center: LatLng(47.925812, 106.919831),
                        zoom: 9.0,
                        plugins: [EsriPlugin()],
                        onTap: (tapPos, latlng) {
                          print(latlng);
                          _addNewMarkers(latlng);
                          // setState(() {
                          //   markers.add(
                          //     Marker(
                          //       width: 150.0,
                          //       height: 150.0,
                          //       point: latlng,
                          //       builder: (ctx) => const Icon(
                          //         Icons.location_on,
                          //         color: Colors.red,
                          //         size: 35.0,
                          //       ),
                          //     ),
                          //   );
                          // });
                        }),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            // 'https://services.arcgisonline.com/arcgis/rest/services/WorldElevation3D/Terrain3D/ImageServer/tile/{z}/{y}/{x}?apiKey=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578',
                            'https://services.arcgisonline.com/arcgis/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}?apiKey=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578',
                        // 'https://basemaps-api.arcgis.com/arcgis/rest/services/styles/ArcGIS:Topographic/?type=style&token=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578',
                        // 'https://ibasemaps-api.arcgis.com/arcgis/rest/services/styles/ArcGIS:Terrain?type=style&token=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578',
                        // 'https://ibasemaps-api.arcgis.com/arcgis/rest/services/Elevation/World_Topographic/MapServer/tile/{z}/{y}/{x}?token=<AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578>',
                        // 'https://basemaps-api.arcgis.com/arcgis/rest/services/styles/ArcGIS:Terrain:Detail/?token=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578',
                        // 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                        subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                      ),
                      FeatureLayerOptions(
                        "https://services.arcgisonline.com/arcgis/rest/services/World_Hillshade/MapServer/tile/{z}/{y}/{x}?apiKey=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578",
                        "polygon",
                        onTap: (dynamic attributes, LatLng location) {
                          print(attributes);
                        },
                        render: (dynamic attributes) {
                          // You can render by attribute
                          return PolygonOptions(
                              borderColor: Colors.blueAccent,
                              color: Colors.black12,
                              borderStrokeWidth: 2);
                        },
                      ),
                      FeatureLayerOptions(
                        "https://services.arcgisonline.com/arcgis/rest/services/WorldElevation3D/Terrain3D/ImageServer/tile/{z}/{y}/{x}?apiKey=AAPK9832e94d28094f39a7c33300e31ddd28P3dyFrvyoHAnYo3etV-ZrnsdZdCGXg2nG7HmfduCx6PE8v2IAVVOnSbtncioU578",
                        "point",
                        render: (dynamic attributes) {
                          // You can render by attribute
                          return PointOptions(
                            width: 30.0,
                            height: 30.0,
                            builder: const Icon(Icons.pin_drop),
                          );
                        },
                        onTap: (attributes, LatLng location) {
                          print(attributes);
                        },
                      ),
                      // ),
                    ],
                    children: [
                      Text('Press and hold at a location to add a gate',
                          style: const TextStyle(
                              fontSize: 20, backgroundColor: Colors.white))
                    ]),
              ),
            ],
          ),
        ),
      ),
    );

    // CustomInfoWindow(
    //   controller: _customInfoWindowController,
    //   height: 75,
    //   width: 150,
    //   offset: 50,
    // ),
    // ])));
  }

  void _addNewMarkers(LatLng latLng) {
    markerId++;
    var lat = latLng.latitude;
    var long = latLng.longitude;
    var formatLat = lat.toStringAsFixed(3);
    var formatLong = long.toStringAsFixed(3);
    var elevation = fetchElevation(latLng);

    // setState(() {
    //   _markers.add(Marker(
    //       markerId: MarkerId('$markerId'),
    //       position: LatLng(lat, long),
    //       infoWindow: InfoWindow(
    //           title: 'Gate Information',
    //           snippet:
    //               'Position: $formatLat, $formatLong, Elevation: $elevation')));
    //   // AddMarkers().addMarkerToVM(_markers, context);
    // });
  }

  Future<http.Response> fetchElevation(LatLng latLng) {
    return http.get(Uri.parse(
        'https://api.open-elevation.com/api/v1/lookup?locations=$latLng'));
  }
}
