import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';

import 'package:parkr/amplifyconfiguration.dart';
import 'package:parkr/views/welcomepage.dart';

class ParkrApp extends StatefulWidget {
  const ParkrApp({Key? key}) : super(key: key);
  static const String title = 'replace with one from AWS Cognito';

  @override
  State<ParkrApp> createState() => _ParkrAppState();
}

class _ParkrAppState extends State<ParkrApp> {
  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    print('configuring');
    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    // Add all plugins before configuring Amplify
    // Amplify.configure() may only be called once
    try {
      await Amplify.addPlugins(
          [AmplifyAuthCognito()]);
      await Amplify.configure(amplifyconfig); // from amplifyconfiguration.dart
    } on Exception catch (e) {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android. $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticated = Authenticator(
      child: const Scaffold(
        body: Center(child: Text('You are logged in!')),
      ),
    );

    return Authenticator(
      child: MaterialApp(
        title: 'Parkr',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        builder: Authenticator.builder(),
        home: authenticated,
      ),
    );
  } // build
}

void main() {
  runApp(const ParkrApp());
}
