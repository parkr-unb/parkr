import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:parkr/gateway.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:parkr/views/manageofficerspage.dart';
import 'package:parkr/registration.dart';
import 'package:parkr/views/settingspage.dart';
import 'package:parkr/widgets/loadingdialog.dart';
import 'package:parkr/analyzer.dart';
import 'package:parkr/user.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({Key? key, required this.camera}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _HomePageState extends State<HomePage> {
  TextEditingController plateCtrl = TextEditingController();
  bool typing = false;
  late CameraController _camera;
  late Future<void> _cameraFuture;

  bool _enableExamination = false;

  @override
  void initState() {
    super.initState();
    _camera = CameraController(widget.camera, ResolutionPreset.medium);
    _cameraFuture = _camera.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final username = CurrentUser().getFirstName();

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(children: [
              Text('Welcome, $username'),
              const Spacer(),
              const Text('Home'),
            ])),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 23),
              Expanded(
                  flex: 25,
                  child: FutureBuilder(
                    future: _cameraFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final size = MediaQuery.of(context).size;
                        var scaler =
                            size.aspectRatio / _camera.value.aspectRatio;
                        if (scaler < 1) scaler = 1 / scaler;
                        return GestureDetector(
                            onTap: () async {
                              try {
                                await _cameraFuture;
                                XFile img = await _camera.takePicture();
                                final plate = await loadingDialog(
                                    context,
                                    getPlate(img),
                                    "Reading plate...",
                                    null,
                                    "Could not read plate") as String?;
                                plateCtrl.text = plate ?? "";
                                if (plateCtrl.text.isNotEmpty) {
                                  setState(() {
                                    _enableExamination = true;
                                  });
                                }
                              } catch (e) {
                                print("Failed to capture photo");
                                print(e);
                              }
                            },
                            child: Transform.scale(
                              scale: scaler,
                              child: Center(
                                  child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1.0, color: Colors.red),
                                ),
                                child: CameraPreview(_camera),
                              )),
                            ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
              const Spacer(flex: 22),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                  child: TextFormField(
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]')),
                        UpperCaseTextFormatter()
                      ],
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5,
                          debugLabel: 'blackMountainView displayLarge'),
                      controller: plateCtrl,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(letterSpacing: 1, fontSize: 25),
                        hintStyle: TextStyle(letterSpacing: 1, fontSize: 18),
                        icon: Icon(Icons.confirmation_number),
                        hintText: 'License plate to examine',
                        labelText: 'License Plate Number *',
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _enableExamination =
                              value != null && value.isNotEmpty;
                        });
                      })),
              ElevatedButton(
                  child: const Text('Examine Registration',
                      style: TextStyle(fontSize: 20.0)),
                  onPressed: _enableExamination == false
                      ? null
                      : () async {
                          final reg = await loadingDialog(
                              context,
                              isValid(plateCtrl.text),
                              "Examining registration...",
                              null,
                              null) as Registration?;
                          // STUB
                          // examine(plate_ctrl.text);
                          if (reg != null) {
                            Navigator.pushNamed(context, "plate",
                                arguments: {"reg": reg});
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text(
                                          'Plate not found in system'),
                                      content: Text(
                                          'Please administer a paper ticket to plate - ' +
                                              plateCtrl.text),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ]);
                                });
                          }
                        }),
              if (!isKeyboardVisible) const Spacer(flex: 5),
              AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  firstChild: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (CurrentUser().isAdmin())
                        ElevatedButton(
                            child: const Text('Officers',
                                style: TextStyle(fontSize: 20.0)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ManageOfficersPage()),
                              );
                            }),
                      const VerticalDivider(),
                      ElevatedButton(
                          child: const Text('Logout',
                              style: TextStyle(fontSize: 20.0)),
                          onPressed: () {
                            Amplify.Auth.signOut();
                            CurrentUser().clear();

                            // completely wipe navigation stack and replace with welcome
                            Navigator.pushNamedAndRemoveUntil(
                                context, "welcome", (_) => false);
                          }),
                      const VerticalDivider(),
                      ElevatedButton(
                          child: const Text('Settings',
                              style: TextStyle(fontSize: 20.0)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsPage()),
                            );
                          })
                    ],
                  ),
                  secondChild: const SizedBox(),
                  crossFadeState: !isKeyboardVisible
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond),
              if (!isKeyboardVisible) const Spacer(flex: 2)
            ],
          ),
        ),
      );
    });
  } // build

  Future<String?> getPlate(XFile img) async {
    var uri = Uri.parse('https://api.platerecognizer.com/v1/plate-reader/');
    var request = http.MultipartRequest("POST", uri);
    request.files.add(http.MultipartFile.fromBytes(
        'upload', await img.readAsBytes(),
        filename: "plate.jpeg"));
    var keys = await Gateway().queryAppKeys();
    if (keys == null) {
      print("Failed to retrieve auth token");
      return "";
    }
    request.headers['Authorization'] = "Token " + keys.plateRecognizer;
    request.headers['accept'] = 'application/json';
    request.headers['content-type'] = 'multipart/form-data';
    var responseBytes = await (await request.send()).stream.toBytes();
    Map<String, dynamic> response = json.decode(utf8.decode(responseBytes));

    if (response['results'].isNotEmpty) {
      print("Plate: " + response['results'][0]['candidates'][0]['plate']);
      return response['results'][0]['candidates'][0]['plate']
          .toString()
          .toUpperCase();
    } else {
      return null;
    }
  }
}
