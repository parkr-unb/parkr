import 'package:flutter/material.dart';
import 'package:parkr/user.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const String title = 'Settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsPage.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Change Profile Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            const TextField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Valid Password')
            ),
            ElevatedButton(
              child: const Text('Change Settings'),
              onPressed: () {

              }),
            // TODO: GEOFENCING STUFF
            if(CurrentUser().isAdmin()) const Text('ADMIN SHIT'),
          ],
        ),
      ),
    );
  } // build
}
