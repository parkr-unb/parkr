import 'package:flutter/material.dart';

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
            TextField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter Valid Username')
            ),
            TextField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Valid Password')
            ),
          ],
        ),
      ),
    );
  } // build
}
