import 'package:flutter/material.dart';
import 'package:parkr/registration.dart';
import 'package:parkr/views/platepage.dart';
import 'package:parkr/views/registerpage.dart';
import 'package:parkr/views/settingspage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String title = 'Examination';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController plate_ctrl = TextEditingController();
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
