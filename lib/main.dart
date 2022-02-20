import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:parkr/views/homepage.dart';
import 'package:parkr/views/loginpage.dart';
import 'package:parkr/views/platepage.dart';
import 'package:parkr/views/welcomepage.dart';

class ParkrApp extends StatelessWidget {
  final CameraDescription camera;
  const ParkrApp({Key? key, required this.camera}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parkr',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: const WelcomePage(),
      routes: {
        "plate": (BuildContext context) => PlatePage(),
        "examine": (BuildContext context) => HomePage(camera: camera,),
      },
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final camera = cameras.first;
  runApp(ParkrApp(camera: camera));
}

