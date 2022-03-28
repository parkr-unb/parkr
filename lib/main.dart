import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';

import 'package:parkr/amplifyconfiguration.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/views/geofencingpage.dart';
import 'package:parkr/views/homepage.dart';
import 'package:parkr/views/welcomepage.dart';
import 'package:parkr/models/ModelProvider.dart';
import 'package:parkr/views/platepage.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ParkrApp extends StatefulWidget {
  final CameraDescription camera;
  final LocationData locationData;

  ParkrApp({Key? key, required this.camera, required this.locationData}) : super(key: key);

  @override
  State<ParkrApp> createState() => _ParkrAppState();
}

class _ParkrAppState extends State<ParkrApp> {
  @override
  Widget build(BuildContext context) {
    // navigate straight to home page if already signed in
    Widget startPage = const WelcomePage();
    try {
      Amplify.Auth.fetchAuthSession()
          .timeout(const Duration(seconds: 5))
          .then((session) {
        if (session.isSignedIn) {
          startPage = HomePage(camera: widget.camera);
        }
      });
    } on TimeoutException {
      // just continue, and let the user sign in, as usual
      print('Poor network quality while fetching user session timed out');
    } on Exception catch (e) {
      print(e);
      rethrow;
    }

    return MaterialApp(
      title: 'Parkr',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          backgroundColor: Colors.white,
        ),
      ).copyWith(
        indicatorColor: Colors.red,
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
        ),
      ),
      home: startPage,
      routes: {
        "plate": (BuildContext context) => const PlatePage(),
        "home": (BuildContext context) => HomePage(camera: widget.camera),
        "welcome": (BuildContext context) => const WelcomePage(),
        "geo": (BuildContext context) => GeofencingPage(location: widget.locationData),
      },
    );
  } // build
}

Future<void> setupAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAPI(modelProvider: ModelProvider.instance));
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig); // from amplifyconfiguration.dart
  } on Exception catch (e) {
    print(
        "Tried to reconfigure Amplify; this can occur when your app restarts on Android. $e");
  }
}

late CameraDescription camera;

Location location = Location();
bool _serviceEnabled = false;
PermissionStatus? _permissionGranted;
late LocationData locationData;

_checkLocationPermission() async {
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  locationData = await location.getLocation();
}

Future<void> setupCamera() async {
  try {
    final cameras = await availableCameras();
    camera = cameras.first;
  } on Exception catch (e) {
    print("Tried to initialize camera but failed: $e");
  }
}

void setupAppKeys() async {
  try {
    await Gateway().queryAppKeys();
  } on Exception catch (e) {
    print("Failed to acquire app keys: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Future.wait([setupAmplify(), setupCamera(), ]);
  } on Exception catch (e) {
    print("Failed setup the application: $e");
  }

  try {
    await _checkLocationPermission();
  } on Exception catch (e) {
    print("Failed setup the application: $e");
  }

  runApp(ParkrApp(camera: camera, locationData: locationData));
}
