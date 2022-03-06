import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:parkr/views/manageofficerspage.dart';
import 'package:parkr/views/welcomepage.dart';
import 'package:parkr/registration.dart';
import 'package:parkr/views/settingspage.dart';
import 'package:parkr/widgets/loadingdialog.dart';

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
    print(ModalRoute.of(context)?.settings);
    final username =
        (ModalRoute.of(context)?.settings.arguments as Map)['user'] as String;

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Parkr Home - Welcome $username'),
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
                                  String plate = await getPlate(img);
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
                          await loading(
                              context,
                              Future.delayed(const Duration(seconds: 2), () {
                                return "";
                              }),
                              "Examining registration...");
                          // STUB
                          // examine(plate_ctrl.text);
                          Registration reg = Registration.basic();
                          if (true) {
                            Navigator.pushNamed(context, "plate",
                                arguments: {"reg": reg, "user": username});
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
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const WelcomePage()),
                                (_) => false);
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
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    img.saveTo('$path/plate.jpg');

    var url = Uri.parse('api.platerecognizer.com/v1/plate-reader/');
    var formData = [];

    var response = await http.post(url,
        headers: {'accept': 'application/json', 'Authorization': '***'},
        body: {'upload': '@$path/plate.jpg', 'regions': 'ca'});

    print(response.body);

    return "";
  }
}
