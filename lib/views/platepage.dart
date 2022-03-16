import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:parkr/analyzer.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/registration.dart';
import 'package:parkr/user.dart';
import 'package:parkr/widgets/loadingdialog.dart';
import 'package:parkr/widgets/successdialog.dart';
import 'package:parkr/widgets/failuredialog.dart';


import '../models/Tickets.dart';

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
  bool init = false;
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments as Map);
    final registration = arguments["reg"] as Registration;
    final username = CurrentUser().getName();
    if(!init)
    {
      var result = isValid(registration);
      _hasPass = result['haspass'];
      _invalidLot = result['invalidLot'];
      _blocking = result['blocking'];
      _multiple = result['multiple'];
      _alt = result['alt'];
      init = true;

    }
    bool valid = (_hasPass || _invalidLot || _blocking || _blocking || _multiple || _alt);
  return Scaffold(
      appBar: AppBar(
        title: const Text(PlatePage.title),
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 6, color: valid ? Colors.red : Colors.green)
          ),
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
        child:
            Column(
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
                    Expanded(
                      child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 50),
                                Text('Parking Officer'),
                                Text(username!,
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
                    )
                  ],
                ),
                Expanded(
                  child: SizedBox(height: 50),
                ),
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
                    onPressed: !valid ? null : () async {
                      Tickets? tickets = await (loading(
                        context,
                        Future.delayed(const Duration(seconds: 2), () {
                        return Gateway().administerTicket(registration.plate, 'invalid-pass');
                      }),
                      "Administering ticket...")) as Tickets?;
                      if (tickets == null) {
                        await (fail(
                            context,
                            Future.delayed(const Duration(seconds: 2), () {
                              return "Failure";
                            }),
                            "An error has occured."));
                        print("Ticket generation failed");
                      }
                      else {
                        await (success(
                            context,
                            Future.delayed(const Duration(seconds: 2), () {
                              return "Success";
                            }),
                            "Success!"));
                        print("Successful ticket generation");
                      }
                      // Gateway().administerTicket(registration.plate);
                      Navigator.pop(context);
                    }
                  ),
                ],
              ),
            ],
        )
      ),
    );
  } // build
}
