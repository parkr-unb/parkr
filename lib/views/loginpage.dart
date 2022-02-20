import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:parkr/views/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String title = 'Login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController name_ctrl = TextEditingController();
  TextEditingController pass_ctrl = TextEditingController();
  bool _auth = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LoginPage.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: name_ctrl,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _auth ? Colors.black : Colors.red,
                    width: 1.0
                  ),
                ),
                labelText: 'Username',
                hintText: 'Enter Valid Username')
            ),
            TextField(
                controller: pass_ctrl,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _auth ? Colors.black : Colors.red,
                        width: 1.0
                      ),
                    ),
                    labelText: 'Password',
                    hintText: 'Enter Valid Password')
            ),
            TextButton(
                onPressed: () async {
                  // auth = login(name_ctrl.text, pass_ctrl.text);
                  const auth = true;
                  if(auth)
                  {
                    Navigator.pushNamed(context, 'examine');
                  }
                  else
                  {
                    name_ctrl.text = "";
                    name_ctrl.text = "";
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text('Failed to Log in'),
                          content: Text('Invalid Username and/or Password'),
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
                  setState(() {
                    _auth = auth;
                  });
                },
                child: const Text('Login', style: TextStyle(fontSize: 20.0)))
          ],
        ),
      ),
    );
  } // build
}
