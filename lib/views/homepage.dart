import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:parkr/views/manageofficerspage.dart';
import 'package:parkr/views/welcomepage.dart';
import 'package:parkr/registration.dart';
import 'package:parkr/views/platepage.dart';
import 'package:parkr/views/settingspage.dart';
import 'package:camera/camera.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({Key? key, required this.camera}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController plateCtrl = TextEditingController();
  late CameraController _camera;
  late Future<void> _cameraFuture;
  bool enableExamination = false;

  @override
  void initState() {
    super.initState();
    _camera = CameraController(widget.camera, ResolutionPreset.low);
    _cameraFuture = _camera.initialize();
  }

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Parkr Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: _cameraFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final size = MediaQuery.of(context).size;
                  return Transform.scale(
                      scale:
                          (_camera.value.aspectRatio / size.aspectRatio) / 2.5,
                      child: Center(
                          child: AspectRatio(
                              aspectRatio: _camera.value.aspectRatio,
                              child: CameraPreview(_camera))));
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
              onSaved: (String? value) {
                print("SAAAAAAAAAAAVING");
                enableExamination = value != null && value.isNotEmpty;
              },
              validator: (String? value) {
                final err = (value != null && value.contains('@'))
                    ? 'Do not use the @ character.'
                    : null;
                return err;
              },
            ),
            ElevatedButton(
                child: const Text('Examine Registration',
                    style: TextStyle(fontSize: 20.0)),
                onPressed: enableExamination == false
                    ? null
                    : () {
                        // STUB
                        // examine(plate_ctrl.text);
                        Registration reg = Registration.basic();
                        if (true) {
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
            const Spacer(),
            TextButton(
                child: const Text('Parking Officers',
                    style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageOfficersPage()),
                  );
                }),
            TextButton(
                child: const Text('Logout', style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  Amplify.Auth.signOut();

                  // completely wipe navigation stack and replace with welcome
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WelcomePage()),
                      (_) => false);
                }),
            TextButton(
                child: const Text('Edit Profile',
                    style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                }),
          ],
        ),
      ),
    );
  } // build
}
