import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:parkr/displayable_exception.dart';
import 'package:parkr/widgets/loadingdialog.dart';

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

  // returns error message or empty string on success
  Future<void> registerOfficer() async {
    final email = emailCtrl.text.trim();
    final splitEmail = email.split("@");
    if (splitEmail.length != 2) {
      throw DisplayableException("Email must contain a single '@'");
    }

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
      if (!result.isSignUpComplete) {
        throw DisplayableException("Register Operation did not complete");
      }
    } on InvalidPasswordException {
      throw DisplayableException("Password must be at least 8 characters");
    } on UsernameExistsException {
      throw DisplayableException(
          "An officer with the provided email already exists");
    } on InvalidParameterException catch (e) {
      // e message from cognito is directly displayable
      throw DisplayableException(e.toString());
    } on AuthException catch (e) {
      final msgParts = e.message.split(':');
      final ignoreIdx = msgParts.length - 1;
      final presentableMsg = msgParts.sublist(ignoreIdx).join(':').trim();
      throw DisplayableException(presentableMsg);
    }
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
          child: Column(
            children: buildTextFields(),
          )),
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
              if (await loadingDialog(
                      context,
                      registerOfficer(),
                      "Registering Officer...",
                      "${firstNameCtrl.text} is Registered",
                      "") !=
                  null) {
                Navigator.of(context).pop();
              }
            }
          },
        ),
      ],
    );
  } // build
}
