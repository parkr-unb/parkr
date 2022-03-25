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

import 'package:location/location.dart';

class ParkrApp extends StatefulWidget {
  final CameraDescription camera;
  final LocationData locationData;

  ParkrApp({Key? key, required this.camera, required this.locationData})
      : super(key: key);

  @override
  State<ParkrApp> createState() => _ParkrAppState();
}

class _ParkrAppState extends State<ParkrApp> {
  Future<Widget> _buildStartPage(BuildContext context) async {
    // navigate straight to home page if already signed in
    Widget startPage = const WelcomePage();
    try {
      await Amplify.Auth.fetchAuthSession()
          .timeout(const Duration(seconds: 5))
          .then((session) {
        if (session.isSignedIn) {
          startPage = HomePage(camera: widget.camera);
        }
      });
    } on TimeoutException {
      // just continue, and let the user sign in, as usual
      print('Poor network quality. Fetching user session timed out');
    } on Exception catch (e) {
      print(e);
      rethrow;
    }

    return startPage;
  }

  @override
  Widget build(BuildContext context) {
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
      home: FutureBuilder<Widget>(
          future: _buildStartPage(context),
          builder: (BuildContext ctx, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Text(
                  "An internal Parkr error occurred. Please reload the application.");
            }
            return snapshot.hasData
                ? snapshot.data as Widget
                : Image.asset('assets/transparent_parkr_logo.png');
          }),
      routes: {
        "plate": (BuildContext context) => const PlatePage(),
        "home": (BuildContext context) => HomePage(camera: widget.camera),
        "welcome": (BuildContext context) => const WelcomePage(),
        "geo": (BuildContext context) =>
            GeofencingPage(location: widget.locationData),
      },
    );
  } // build
}

Future<void> _setupAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAPI(modelProvider: ModelProvider.instance));
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig); // from amplifyconfiguration.dart
  } on Exception catch (e) {
    print(
        "Tried to reconfigure Amplify; this can occur when your app restarts on Android. $e");
  }
}

Location location = Location();

Future<LocationData?> _checkLocationPermission() async {
  var _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }
  var _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }
  final locationData = await location.getLocation();
  return locationData;
}

Future<CameraDescription?> _setupCamera() async {
  CameraDescription? camera;
  try {
    final cameras = await availableCameras();
    camera = cameras.first;
  } on Exception catch (e) {
    print("Tried to initialize camera but failed: $e");
  }
  return camera;
}

Future<void> _setupAppKeys() async {
  try {
    await Gateway().queryAppKeys();
  } on Exception catch (e) {
    print("Failed to acquire app keys: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  CameraDescription? camera;
  LocationData? locationData;
  try {
    await Future.wait<Object?>([
      _setupAmplify(),
      _setupAppKeys(),
      _setupCamera().then((c) => camera = c),
      _checkLocationPermission().then((l) => locationData = l)
    ]);
  } on Exception catch (e) {
    print("Failed setup the application: $e");
  }

  runApp(ParkrApp(camera: camera, locationData: locationData));
}
