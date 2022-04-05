import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:parkr/displayable_exception.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/registration.dart';
import 'package:parkr/user.dart';
import 'package:parkr/widgets/loadingdialog.dart';
import 'package:parkr/models/Tickets.dart';
import 'package:parkr/widgets/visibletextfield.dart';

class PlatePage extends StatefulWidget {
  static const String title = 'Examining plates';

  const PlatePage({Key? key}) : super(key: key);

  @override
  State<PlatePage> createState() => _PlatePageState();
}

dateToString(DateTime date) {
  String day = "";
  switch (date.month) {
    case 1:
      day += "January";
      break;
    case 2:
      day += "February";
      break;
    case 3:
      day += "March";
      break;
    case 4:
      day += "April";
      break;
    case 5:
      day += "May";
      break;
    case 6:
      day += "June";
      break;
    case 7:
      day += "July";
      break;
    case 8:
      day += "August";
      break;
    case 9:
      day += "September";
      break;
    case 10:
      day += "October";
      break;
    case 11:
      day += "November";
      break;
    case 12:
      day += "December";
      break;
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
  bool valid = false;
  TextEditingController reasonCtrl = TextEditingController();

  String generateTicketType(String licensePlate, String? lotLocation) {
    var ticketString =
        'The vehicle with license plate $licensePlate was ticketed for the following infractions: ';
    if (!_hasPass) {
      ticketString += 'Invalid Pass, ';
    }
    if (_invalidLot) {
      ticketString += 'Invalid Lot, ';
    }
    if (_blocking) {
      ticketString += 'Obstruction, ';
    }
    if (_multiple) {
      ticketString += 'Occupying multiple spots, ';
    }
    if (_alt) {
      ticketString +=
          'Other (${reasonCtrl.text.isEmpty ? "Contact Administrator" : reasonCtrl.text}), ';
    }
    var ticketType = ticketString.substring(0, ticketString.length - 2);
    if(lotLocation != null) {
      ticketType += "\nThese infractions occurred in the '$lotLocation' lot.";
    }
    return ticketType;
  }

  Future<Object?> getTicketReason(BuildContext context) async {
    Object? res;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Additional Ticket Information'),
              content: VisibleTextField(
                label: "What is the reason for ticketing?",
                hint: "Reason for ticketing",
                validatorText: "You must enter a valid reason",
                controller: reasonCtrl,
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments as Map);
    final registration = arguments["reg"] as Registration;
    final parkingLot = arguments["loc"];
    final username = CurrentUser().getFirstName();
    _hasPass = registration.verified;
    if (parkingLot == null && init == false) {
      _invalidLot = true;
      init = true;
    }
    valid = (_hasPass && !_invalidLot && !_blocking && !_multiple && !_alt);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(PlatePage.title),
      ),
      body: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 6, color: valid ? Colors.green : Colors.red)),
          padding: EdgeInsets.zero,
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
                      const Text('Infraction Type',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Row(
                        children: [
                          Checkbox(
                            value: !_hasPass,
                            onChanged: (bool? newValue) {
                              setState(() {
                                null;
                              });
                            },
                          ),
                          const Text('Parked Without Pass')
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _invalidLot,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _invalidLot = newValue!;
                              });
                            },
                          ),
                          const Text('Parked in Invalid Lot')
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _blocking,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _blocking = newValue!;
                              });
                            },
                          ),
                          const Text('Blocking Pathway')
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _multiple,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _multiple = newValue!;
                              });
                            },
                          ),
                          const Text('Occupying Multiple Slots')
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _alt,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _alt = newValue!;
                                if (_alt == true) {
                                  getTicketReason(context);
                                }
                              });
                            },
                          ),
                          const Text('Another Reason')
                        ],
                      ),
                    ],
                  ),
                  const Expanded(child: VerticalDivider()),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50),
                          const Text('Parking Officer'),
                          Text(username,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 50),
                          const Text('Infraction Date'),
                          Text(dateToString(DateTime.now()),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 50),
                          const Text('Infraction Location'),
                          Text(parkingLot ?? 'N/A',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const Text('')
                        ],
                      )
                    ],
                  ))
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: valid
                      ? const Icon(Icons.check, color: Colors.green, size: 80.0)
                      : const Icon(Icons.error, color: Colors.red, size: 80.0),
                ),
              ),
              Expanded(
                child: SizedBox(
                    height: 10,
                    child: valid
                        ? const Text('',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 45))
                        : const Text('',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 45))),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Registration Information',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                          children: <TextSpan>[
                        const TextSpan(text: 'License Plate: '),
                        TextSpan(
                            text: registration.plate,
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ])),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                          children: <TextSpan>[
                        const TextSpan(text: 'Registration Holder: '),
                        TextSpan(
                            text: registration.email,
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ])),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                          children: <TextSpan>[
                        const TextSpan(text: 'Commencement: '),
                        TextSpan(
                            text: registration.start !=
                                    TemporalDateTime(
                                        DateTime(0, 0, 0, 0, 0, 0, 0, 0))
                                ? dateToString(DateTime.parse(
                                    registration.start.toString()))
                                : 'N/A',
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ])),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                          children: <TextSpan>[
                        const TextSpan(text: 'Expiration: '),
                        TextSpan(
                            text: registration.end !=
                                    TemporalDateTime(
                                        DateTime(0, 0, 0, 0, 0, 0, 0, 0))
                                ? dateToString(
                                    DateTime.parse(registration.end.toString()))
                                : 'N/A',
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ])),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: const Text('Generate Ticket'),
                      onPressed: valid
                          ? null
                          : () async {
                              Future<Tickets?> administerTicket() async {
                                if (registration.email != 'N/A') {
                                  final emailResp = await Gateway().emailTicket(
                                      registration.email,
                                      generateTicketType(registration.plate, parkingLot));
                                  if (emailResp != null &&
                                      emailResp.error != null) {
                                    print(
                                        "Failure submitting ticket: ${emailResp.error}");
                                    return null;
                                  }
                                  return await Gateway().administerTicket(
                                      registration.plate,
                                      generateTicketType(registration.plate, parkingLot));
                                } else {
                                  throw DisplayableException(
                                      "Registration does not exist: Administer paper ticket");
                                }
                              }

                              Tickets? tickets = await loadingDialog(
                                  context,
                                  administerTicket(),
                                  "Administering ticket...",
                                  "Success",
                                  "Failed to administer ticket") as Tickets?;
                              Navigator.pop(context);
                            }),
                  ElevatedButton(
                      child: const Text('Back'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
            ],
          )),
    );
  } // build
}
