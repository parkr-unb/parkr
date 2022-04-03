import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:location/location.dart';

import 'package:parkr/amplifyconfiguration.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/views/geofencingpage.dart';
import 'package:parkr/views/homepage.dart';
import 'package:parkr/views/welcomepage.dart';
import 'package:parkr/models/ModelProvider.dart';
import 'package:parkr/views/platepage.dart';
import 'package:parkr/displayable_exception.dart';
import 'package:parkr/widgets/unavailableicon.dart';

class ParkrApp extends StatefulWidget {
  final CameraDescription? camera;
  final LocationData? locationData;
  final DisplayableException? startupException;

  ParkrApp(
      {Key? key,
      required this.camera,
      required this.locationData,
      required this.startupException})
      : super(key: key);

  @override
  State<ParkrApp> createState() => _ParkrAppState();
}

class _ParkrAppState extends State<ParkrApp> {
  Future<Widget> _buildStartPage(BuildContext context) async {
    if (widget.startupException != null) {
      throw widget.startupException as DisplayableException;
    }

    // navigate straight to home page if already signed in
    Widget startPage = const WelcomePage();
    try {
      final session = await Amplify.Auth.fetchAuthSession()
          .timeout(const Duration(seconds: 5));
      if (session.isSignedIn) {
        startPage = HomePage(camera: widget.camera);
      }
    } on TimeoutException {
      // just continue, and let the user sign in, as usual
      print('Poor network quality. Fetching user session timed out');
    } on Exception catch (e) {
      // just continue, and let the user sign in, as usual
      print(e);
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
            final logo = Image.asset('assets/transparent_parkr_logo.png');
            if (snapshot.hasError) {
              print(snapshot.error);
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    logo,
                    const Spacer(flex: 2),
                    UnavailableIcon(
                        message:
                            "${(snapshot.error as DisplayableException).cause}\n Please restart Parkr",
                        iconData: Icons.error),
                    const Spacer(flex: 4)
                  ]);
            }

            return snapshot.hasData ? snapshot.data as Widget : logo;
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
    await Amplify.addPlugins([
      AmplifyAPI(modelProvider: ModelProvider.instance),
      AmplifyAuthCognito()
    ]);
    await Amplify.configure(amplifyconfig); // from amplifyconfiguration.dart
  } on Exception catch (e) {
    print(
        "Tried to reconfigure Amplify; this can occur when your app restarts on Android:  $e");
    if (!kDebugMode) {
      rethrow;
    }
  }
}

Location _location = Location();

Future<LocationData?> _checkLocationPermission() async {
  var _serviceEnabled = await _location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await _location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }
  var _permissionGranted = await _location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await _location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }
  final locationData = await _location.getLocation();
  return locationData;
}

Future<CameraDescription?> _setupCamera() async {
  CameraDescription? camera;
  try {
    final cameras = await availableCameras();
    camera = cameras.first;
  } on Exception catch (e) {
    print("Tried to initialize camera but failed: $e");
    rethrow;
  }
  return camera;
}

Future<void> _setupAppKeys() async {
  try {
    await Gateway().queryAppKeys();
  } on Exception catch (e) {
    print("Failed to acquire app keys: $e");
    rethrow;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DisplayableException? startupException;
  List<Object?>? startups;
  try {
    startups = await Future.wait<Object?>([
      () async {
        await _setupAmplify();
        await _setupAppKeys();
      }(),
      _setupCamera(),
      _checkLocationPermission()
    ]);
  } on DisplayableException catch (e) {
    startupException = e;
  } on Exception catch (e) {
    print("Failed setup the application: $e");
    startupException = DisplayableException(
        "Parkr experienced issues while initializing. This could be due to a poor network connection.");
  }

  final CameraDescription? camera = startups != null && startups.length > 1
      ? startups[1] as CameraDescription?
      : null;
  final LocationData? location = startups != null && startups.length > 2
      ? startups[2] as LocationData?
      : null;

  runApp(ParkrApp(
      camera: camera,
      locationData: location,
      startupException: startupException));
}
