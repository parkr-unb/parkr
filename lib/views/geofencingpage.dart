import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GeofencingPage extends StatefulWidget {
  final LocationData location;

  const GeofencingPage({required this.location});

  @override
  _GeofencingState createState() => _GeofencingState();
}

class _GeofencingState extends State<GeofencingPage> {
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
                            print(polygonLatLngs.toString());
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