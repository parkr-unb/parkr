import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';

import 'package:parkr/amplifyconfiguration.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/views/homepage.dart';
import 'package:parkr/views/welcomepage.dart';
import 'package:parkr/models/ModelProvider.dart';
import 'package:parkr/views/platepage.dart';

class ParkrApp extends StatefulWidget {
  final CameraDescription camera;

  const ParkrApp({Key? key, required this.camera}) : super(key: key);

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
            return snapshot.hasData ? snapshot.data as Widget : const Text(
                "Jesus Loves You");
          }),
      routes: {
        "plate": (BuildContext context) => const PlatePage(),
        "home": (BuildContext context) => HomePage(camera: widget.camera),
        "welcome": (BuildContext context) => const WelcomePage(),
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
    await Future.wait([
      setupAmplify(),
      setupCamera(),
    ]);
  } on Exception catch (e) {
    print("Failed setup the application: $e");
  }

  runApp(ParkrApp(camera: camera));
}
