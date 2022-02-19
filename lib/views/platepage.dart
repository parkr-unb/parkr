import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:parkr/analyzer.dart';
import 'package:parkr/registration.dart';

class PlatePage extends StatefulWidget {
  static const String title = 'Examining plates';

  const PlatePage({Key? key}) : super(key: key);

  @override
  State<PlatePage> createState() => _PlatePageState();
}

DateString(DateTime date)
{
  return date;
}

class _PlatePageState extends State<PlatePage> {
  @override
  Widget build(BuildContext context) {
    final registration = (ModalRoute.of(context)?.settings.arguments as Map)['reg'] as Registration;
    bool valid = isValid(registration);
    return Scaffold(
      appBar: AppBar(
        title: const Text(PlatePage.title),
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 10, color: valid ? Colors.green : Colors.red)
          ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Plate: ' + registration.plate,
                style: TextStyle(fontSize: 30),),
              Text('Current Time: ' + DateTime.now().toString(),
                style: TextStyle(fontSize: 20),),
              Text('Start: ' + registration.start.toString(),
                style: TextStyle(fontSize: 20),),
              Text('End: ' + registration.end.toString(),
                style: TextStyle(fontSize: 20),)
            ],
          ),
        ),
      ),
    );
  } // build
}
