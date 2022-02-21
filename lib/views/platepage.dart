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
  String day = "";
  switch(date.month) {
    case 0: day += "January"; break;
    case 1: day += "Febuary"; break;
    case 2: day += "March"; break;
    case 3: day += "April"; break;
    case 4: day += "May"; break;
    case 5: day += "June"; break;
    case 6: day += "July"; break;
    case 7: day += "August"; break;
    case 8: day += "September"; break;
    case 9: day += "October"; break;
    case 10: day += "November"; break;
    case 11: day += "December"; break;
  }
  day += ' ';
  day += date.day.toString();
  day += ',';
  day += date.year.toString();
  return day;
}

class _PlatePageState extends State<PlatePage> {
  bool _hasPass = false;
  bool _invalidLot = false;
  bool _blocking = false;
  bool _multiple = false;
  bool _alt = false;
  @override
  Widget build(BuildContext context) {
    final registration = (ModalRoute.of(context)?.settings.arguments as Map)['reg'] as Registration;
    bool valid = isValid(registration) && (_hasPass || _invalidLot || _blocking || _blocking || _multiple || _alt);
    return Scaffold(
      appBar: AppBar(
        title: const Text(PlatePage.title),
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 10, color: valid ? Colors.green : Colors.red)
          ),
        alignment: Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Infraction Type',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      )
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _hasPass,
                          onChanged: (bool? newValue) {
                            setState(() { _hasPass = newValue!; });
                          },
                        ),
                        Text('Parked Without Pass')
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _invalidLot,
                          onChanged: (bool? newValue) {
                            setState(() { _invalidLot = newValue!; });
                          },
                        ),
                        Text('Parked in Invalid Lot')
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _blocking,
                          onChanged: (bool? newValue) {
                            setState(() { _blocking = newValue!; });
                          },
                        ),
                        Text('Blocking Pathway')
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _multiple,
                          onChanged: (bool? newValue) {
                            setState(() { _multiple = newValue!; });
                          },
                        ),
                        Text('Occupying Multiple Slots')
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _alt,
                          onChanged: (bool? newValue) {
                            setState(() { _alt = newValue!; });
                          },
                        ),
                        Text('Another Reason')
                      ],
                    ),
                  ],
                ),
                const VerticalDivider(),
                const VerticalDivider(),
                const VerticalDivider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Text('Parking Officer'),
                        Text('Richard Stallman',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 50),
                        Text('Infraction Date'),
                        Text(DateString(DateTime.now()),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 50),
                        Text('Infraction Location'),
                        Text('Head Hall Lot 4',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('')
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Registration Information',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    )
                ),
                RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'License Plate: '),
                          TextSpan(text: registration.plate,
                              style: const TextStyle(fontWeight: FontWeight.bold))
                        ]
                    )
                ),
                RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Registration Holder: '),
                          TextSpan(text: registration.email,
                              style: const TextStyle(fontWeight: FontWeight.bold))
                        ]
                    )
                ),
                RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Commencement: '),
                          TextSpan(text: DateString(registration.start),
                              style: const TextStyle(fontWeight: FontWeight.bold))
                        ]
                    )
                ),
                RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Expiration: '),
                          TextSpan(text: DateString(registration.end),
                              style: const TextStyle(fontWeight: FontWeight.bold))
                        ]
                    )
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    child: Text('Generate Ticket'),
                    onPressed: !valid ? null : () {
                      // send ticket
                      Navigator.pop(context);
                    }
                ),
                ElevatedButton(
                    child: Text('Back'),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  } // build
}
