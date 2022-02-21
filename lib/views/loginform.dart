import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkr/views/homepage.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> signInUser() async {
    try {
      SignInResult result = await Amplify.Auth.signIn(
        username: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      if (result.isSignedIn) {
        return true;
      }
    } on UserNotConfirmedException {
      rethrow;
    } on AuthException catch (e) {
      print(e.message);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Email', hintText: 'Enter Valid Email'),
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
                    obscureText: true,
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
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    const processingBar =
                        SnackBar(content: Text('Processing Data'));
                    ScaffoldMessenger.of(context).showSnackBar(processingBar);

                    // process login

                    bool signedIn = false;
                    try {
                      signedIn = await signInUser();
                    } on UserNotConfirmedException catch (e) {
                      String code = "";
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text('Account Confirmation'),
                                content: SizedBox(
                                    height: 400,
                                    child: Column(children: [
                                      const Text(
                                          'Enter your confirmation code'),
                                      TextField(
                                        onChanged: (value) {
                                          code = value.trim();
                                        },
                                      )
                                    ])),
                                actions: [
                                  TextButton(
                                    child: const Text('Confirm'),
                                    onPressed: () {
                                      Amplify.Auth.confirmSignUp(
                                          username: emailCtrl.text.trim(),
                                          confirmationCode: code);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ]);
                          });
                    }
                    if (!signedIn) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text('Failed to Log in'),
                                content: const Text(
                                    'Invalid Username and/or Password'),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ]);
                          });
                    } else {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();

                      Navigator.pushNamed(
                        context,
                        "home",
                      );
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ),
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "home");
                  },
                  child: const Text('Debug Skip Login'),
                ),
              ),
          ],
        ));
  } // build
}
