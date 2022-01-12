import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static const String title = 'Parkr';

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(WelcomePage.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: (){}, child: const Text('Login', style: TextStyle(fontSize: 20.0))),
            TextButton(onPressed: (){}, child: const Text('Sign Up', style: TextStyle(fontSize: 20.0)))
          ],
        ),
      ),
    );
  } // build
}
