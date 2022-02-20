import 'package:flutter/material.dart';
import 'package:parkr/registration.dart';
import 'package:parkr/views/platepage.dart';
import 'package:parkr/views/registerpage.dart';
import 'package:parkr/views/settingspage.dart';
import 'package:camera/camera.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;
  const HomePage({Key? key, required this.camera}) : super(key: key);


  static const String title = 'Examination';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController plate_ctrl = TextEditingController();
  late CameraController _camera;
  late Future<void> _cameraFuture;

  @override
  void initState() {
    super.initState();

    _camera = CameraController(
      widget.camera,
      ResolutionPreset.low
    );
    _cameraFuture = _camera.initialize();
  }
  @override
  void dispose() {
    this._camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: _cameraFuture,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  final size = MediaQuery.of(context).size;
                  return
                    Container(
                      child: Transform.scale(
                        scale: (_camera.value.aspectRatio / size.aspectRatio)/2.5,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: _camera.value.aspectRatio,
                            child:
                              CameraPreview(_camera)
                          )
                        )
                      )
                    );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const Spacer(),
            TextFormField(
              controller: plate_ctrl,
              decoration: const InputDecoration(
                icon: Icon(Icons.confirmation_number),
                hintText: 'What license place would you like to examine?',
                labelText: 'License Plate Number *',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
            ),
            ElevatedButton(
                child: const Text('Examine Registration',
                    style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  // STUB
                  // examine(plate_ctrl.text);
                  Registration reg = Registration.basic();
                  if(true)
                  {
                    const plate_page = PlatePage();
                    Navigator.pushNamed(context, "plate", arguments: {"reg": reg});
                  }
                  else
                  {
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text('Plate not found in system'),
                          content: Text('Please administer a paper ticket to plate - ' + plate_ctrl.text),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ]
                      );
                    });
                  }
                }),
            const Spacer(),
            TextButton(
                child: const Text('Logout', style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
            TextButton(
                child: const Text('Edit Profile',
                    style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                }),
          ],
        ),
      ),
    );
  } // build
}
