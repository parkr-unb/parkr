import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class RegisterOfficerPage extends StatefulWidget {
  const RegisterOfficerPage({Key? key}) : super(key: key);

  @override
  State<RegisterOfficerPage> createState() => _RegisterOfficerPageState();
}

class _RegisterOfficerPageState extends State<RegisterOfficerPage> {
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> registerOfficer() async {
    final fullName = lastNameCtrl.text + ',' + firstNameCtrl.text;
    try {
      Map<CognitoUserAttributeKey, String> userAttributes = {
        CognitoUserAttributeKey.name: fullName
        // additional attributes as needed
      };

      SignUpResult result = await Amplify.Auth.signUp(
          username: emailCtrl.text,
          password: passCtrl.text,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      if (result.isSignUpComplete) {
        return true;
      }
    } on AuthException catch (e) {
      print(e.message);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register Parking Officer"),
        ),
        body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                      controller: firstNameCtrl,
                      decoration: const InputDecoration(
                          labelText: 'First Name',
                          hintText: 'Enter Officer\'s First Name'),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "First Name is mandatory";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                      controller: lastNameCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Last Name',
                          hintText: 'Enter Officer\'s Last Name'),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Last Name is mandatory";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter Officer\'s Email'),
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
                            labelText: 'Temporary Password',
                            hintText: 'Enter a Temporary Password'),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Temporary password is mandatory";
                          }
                          return null;
                        })),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        const processingBar =
                            SnackBar(content: Text('Processing Data'));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(processingBar);

                        // process login
                        final registered = await registerOfficer();
                        if (registered) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('Officer Registered'),
                                    content: const Text(
                                        'Successfully registered officer!'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            firstNameCtrl.clear();
                                            lastNameCtrl.clear();
                                            emailCtrl.clear();
                                            passCtrl.clear();
                                          });
                                        },
                                      ),
                                    ]);
                              });
                        } else {
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
                        }

                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      }
                    },
                    child: const Text('Register'),
                  ),
                ),
              ],
            )));
  } // build
}
