import 'package:flutter/material.dart';
import 'package:parkr/views/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String title = 'Login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  bool _auth = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(LoginPage.title),
        ),
        body: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                          controller: emailCtrl,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter Valid Email'),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Email is mandatory";
                            }
                            return null;
                          }),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                            controller: passCtrl,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter Valid Password'),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Password is mandatory";
                              }
                              return null;
                            })),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ))));

    // OLD WITHOUT A FORM FOR VALIDATION
    return Scaffold(
      appBar: AppBar(
        title: const Text(LoginPage.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: _auth ? Colors.black : Colors.red, width: 1.0),
                    ),
                    labelText: 'Email',
                    hintText: 'Enter Valid Email')),
            TextField(
                controller: passCtrl,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: _auth ? Colors.black : Colors.red, width: 1.0),
                    ),
                    labelText: 'Password',
                    hintText: 'Enter Valid Password')),
            TextButton(
                onPressed: () {
                  // auth = login(name_ctrl.text, pass_ctrl.text);
                  print(emailCtrl.text + " " + passCtrl.text);
                  const auth = false;
                  if (auth) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else {
                    emailCtrl.text = "";
                    emailCtrl.text = "";
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
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
                              ]);
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
