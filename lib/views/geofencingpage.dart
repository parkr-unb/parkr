import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/models/GeoCoord.dart';

import '../widgets/loadingdialog.dart';
import '../widgets/visibletextfield.dart';

class GeofencingPage extends StatefulWidget {
  final LocationData location;

  const GeofencingPage({required this.location});

  @override
  _GeofencingState createState() => _GeofencingState();
}

class _GeofencingState extends State<GeofencingPage> {
  TextEditingController nameCtrl = TextEditingController();
  // Location
  late LocationData _locationData;

  // Maps
  Set<Polygon> _polygons = HashSet<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  //ids
  final int _polygonIdCounter = 1;

  // Type controllers
  bool _isPolygon = true; //Default

  @override
  void initState() {
    super.initState();
    _locationData = widget.location;
  }

  // Draw Polygon to the map
  void setPolygon() {
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: polygonLatLngs,
      strokeWidth: 2,
      strokeColor: Colors.yellow,
      fillColor: Colors.yellow.withOpacity(0.15),
    )); // Polygon
  }

  List<GeoCoord> convertLatLngGeoCoords(List<LatLng> list) {
    List<GeoCoord> coords = <GeoCoord>[];
    for (int i=0; i<list.length; i++) {
      coords.add(GeoCoord(latitude: list[i].latitude, longitude: list[i].longitude));
    }
    return coords;
  }

  Future<Object?> saveParkingLot(BuildContext context) async {
    Object? res;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Parking Lot Name'),
              content: VisibleTextField(
                label: "Name",
                hint: "Enter a parking lot name",
                validatorText: "You must enter a valid parking lot name",
                controller: nameCtrl,
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    //TODO: This is busted
                    res = await loadingDialog(
                        context,
                        addGeofence(polygonLatLngs, nameCtrl.text),
                        "Creating parking lot...",
                        "Success",
                        "Failed to create parking lot");
                  },
                ),
              ]);
        });
    return res;
  }

  Future<Object?> addGeofence(List<LatLng> polygonLatLngs, String name) {
    List<GeoCoord> coords = convertLatLngGeoCoords(polygonLatLngs);
    return Gateway().addParkingLot(coords, name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      _locationData.latitude ?? 0.0, _locationData.longitude ?? 0.0),
                  zoom: 16,
                ),
                mapType: MapType.hybrid,
                polygons: _polygons,
                myLocationEnabled: true,
                onTap: (point) {
                  if (_isPolygon) {
                    setState(() {
                      polygonLatLngs.add(point);
                      setPolygon();
                    });
                  }
                },
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            child: _isPolygon ?
                              const Text('Drawing ON') :
                              const Text('Drawing OFF'),
                            onPressed: () {
                              setState(() {
                                _isPolygon = !_isPolygon;
                              });
                            },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          child: const Text('Save'),
                          onPressed: () {
                            //TODO: send to db and exit, call gateway
                            saveParkingLot(context);
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          child: const Text('Reset'),
                          onPressed: () {
                            setState(() {
                              _polygons.clear();
                              polygonLatLngs.clear();
                            });
                          },
                        ),
                      ]
                  )
              )
            ]
        )
    );
  }
}