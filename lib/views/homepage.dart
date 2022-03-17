import 'dart:convert';

import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:parkr/gateway.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:parkr/views/manageofficerspage.dart';
import 'package:parkr/views/welcomepage.dart';
import 'package:parkr/registration.dart';
import 'package:parkr/views/settingspage.dart';
import 'package:parkr/widgets/loadingdialog.dart';

import '../user.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({Key? key, required this.camera}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
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
    final username = CurrentUser().getName();

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Home - Welcome $username'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              FutureBuilder(
                future: _cameraFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final size = MediaQuery.of(context).size;
                    return Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              try {
                                await _cameraFuture;
                                _camera.takePicture().then((XFile img) async {
                                  String plate = (await loading(context, getPlate(img), "Reading plate")) as String;
                                  plateCtrl.text = plate;
                                  if(plate.isNotEmpty)
                                  {
                                    setState(() {
                                      _enableExamination = true;
                                    });
                                  }
                                });
                              } catch (e) {
                                print("Failed to capture photo");
                                print(e);
                              }
                            },
                            child: Transform.scale(
                                scale: ((_camera.value.aspectRatio /
                                    size.aspectRatio)),
                                child: Center(
                                    child: AspectRatio(
                                        aspectRatio: _camera.value.aspectRatio,
                                        child: CameraPreview(_camera))))));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const Spacer(),
              TextFormField(
                  controller: plateCtrl,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.confirmation_number),
                    hintText: 'What license place would you like to examine?',
                    labelText: 'License Plate Number *',
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _enableExamination = value != null && value.isNotEmpty;
                    });
                  }),
              ElevatedButton(
                  child: const Text('Examine Registration',
                      style: TextStyle(fontSize: 20.0)),
                  onPressed: _enableExamination == false
                      ? null
                      : () async {
                          Registration? reg = (await loading(
                              context,
                              Future.delayed(const Duration(seconds: 2), () {
                                return Registration.basic();
                              }),
                              "Examining registration...")) as Registration?;
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
                                      title: Text('Plate not found in system'),
                                      content: Text(
                                          'Please administer a paper ticket to plate - ' +
                                              plateCtrl.text),
                                      actions: [
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ]);
                                });
                          }
                        }),
              if (!isKeyboardVisible)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(CurrentUser().isAdmin())
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
                )
            ],
          ),
        ),
      );
    });
  } // build

  Future<String> getPlate(XFile img) async {
    var uri = Uri.parse('https://api.platerecognizer.com/v1/plate-reader/');
    var request = new http.MultipartRequest("POST", uri);
    request.files.add(http.MultipartFile.fromBytes('upload', await img.readAsBytes(), filename: "plate.jpeg"));
    var keys = await Gateway().queryAppKeys();
    if(keys == null || keys.plateRecognizer == null)
    {
      print("Failed to retrieve auth token");
      return "";
    }
    request.headers['Authorization'] = "Token " + keys.plateRecognizer;
    request.headers['accept'] = 'application/json';
    request.headers['content-type'] = 'multipart/form-data';
    var responseBytes = await (await request.send()).stream.toBytes();
    Map<String, dynamic> response = json.decode(utf8.decode(responseBytes));

    if(response['results'].isNotEmpty)
    {
      print("Plate: " + response['results'][0]['candidates'][0]['plate']);
      return response['results'][0]['candidates'][0]['plate'];
    }
    else{
      return "";
    }
  }
}
