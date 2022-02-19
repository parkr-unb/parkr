import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String title = 'replace with one from AWS Cognito';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                onPressed: () {}),
            const Spacer(),
            TextButton(
                child: const Text('Logout', style: TextStyle(fontSize: 20.0)),
                onPressed: () {}),
            TextButton(
                child: const Text('Update Password',
                    style: TextStyle(fontSize: 20.0)),
                onPressed: () {}),
          ],
        ),
      ),
    );
  } // build
}