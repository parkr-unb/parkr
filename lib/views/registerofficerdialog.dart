import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class RegisterOfficerDialog extends StatefulWidget {
  const RegisterOfficerDialog({Key? key}) : super(key: key);

  @override
  State<RegisterOfficerDialog> createState() => _RegisterOfficerDialogState();
}

class _RegisterOfficerDialogState extends State<RegisterOfficerDialog> {
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> registerOfficer() async {
    final fullName = lastNameCtrl.text.trim() + ',' + firstNameCtrl.text.trim();
    try {
      Map<CognitoUserAttributeKey, String> userAttributes = {
        CognitoUserAttributeKey.name: fullName
        // additional attributes as needed
      };

      SignUpResult result = await Amplify.Auth.signUp(
          username: emailCtrl.text.trim(),
          password: passCtrl.text.trim(),
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      if (result.isSignUpComplete) {
        return true;
      }
    } on AuthException catch (e) {
      print(e.message);
    }
    return false;
  }

  List<Widget> buildTextFields() {
    final textFields = <Widget>[
      TextFormField(
          controller: firstNameCtrl,
          decoration: const InputDecoration(
              labelText: 'First Name', hintText: 'Enter Officer\'s First Name'),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "First Name is mandatory";
            }
            return null;
          }),
      TextFormField(
          controller: lastNameCtrl,
          decoration: const InputDecoration(
              labelText: 'Last Name', hintText: 'Enter Officer\'s Last Name'),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "Last Name is mandatory";
            }
            return null;
          }),
      TextFormField(
          controller: emailCtrl,
          decoration: const InputDecoration(
              labelText: 'Email', hintText: 'Enter Officer\'s Email'),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "Email is mandatory";
            }
            return null;
          }),
      TextFormField(
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
          }),
    ];

    return textFields.map((tf) {
      return Padding(
          padding: const EdgeInsets.all(5.0), child: Center(child: tf));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('New Officer'),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: buildTextFields(),)
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              const processingBar = SnackBar(content: Text('Processing Data'));
              ScaffoldMessenger.of(context).showSnackBar(processingBar);

              // process login
              final registered = await registerOfficer();
              if (!registered) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('Failure'),
                          content: const Text('Friggen Dummy'),
                          actions: [
                            TextButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ]);
                    }
                  );
              } else {
                Navigator.of(context).pop();
              }
            }
          },
        ),
      ],
    );
  } // build
}
