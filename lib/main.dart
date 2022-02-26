import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:parkr/amplifyconfiguration.dart';
import 'package:parkr/views/homepage.dart';
import 'package:parkr/views/welcomepage.dart';

import 'package:parkr/views/platepage.dart';

class ParkrApp extends StatefulWidget {
  final CameraDescription camera;

  const ParkrApp({Key? key, required this.camera}) : super(key: key);

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
      },
    );
  } // build
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Amplify.addPlugins([AmplifyAuthCognito()]);
    await Amplify.configure(amplifyconfig); // from amplifyconfiguration.dart
  } on Exception catch (e) {
    print(
        "Tried to reconfigure Amplify; this can occur when your app restarts on Android. $e");
  }

  late CameraDescription camera;
  try {
    final cameras = await availableCameras();
    camera = cameras.first;
  } on Exception catch (e) {
    print("Tried to initialize camera but failed");
  }

  runApp(ParkrApp(camera: camera));
}
