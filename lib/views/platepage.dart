import 'package:flutter/material.dart';
import 'package:parkr/registration.dart';

class PlatePage extends StatefulWidget {
  static const String title = 'Examining plates';
  final Registration registration;

  const PlatePage({Key? key, required this.registration}) : super(key: key);


  @override
  State<PlatePage> createState() => _PlatePageState(registration: this.registration);
}

class _PlatePageState extends State<PlatePage> {
  var registration;

  _PlatePageState({this.registration});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PlatePage.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Plate: ',
              style: TextStyle(fontSize: 25),)
          ],
        ),
      ),
    );
  } // build
}
