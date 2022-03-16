import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/user.dart';
import 'package:parkr/widgets/obscuredtextfield.dart';
import 'package:parkr/widgets/visibletextfield.dart';
import 'package:parkr/widgets/logo.dart';

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
      await Amplify.Auth.signOut();
      SignInResult result = await Amplify.Auth.signIn(
        username: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      if (result.isSignedIn) {
        await CurrentUser().get();
        await CurrentUser().update();
        return true;
      }
    } on UserNotConfirmedException {
      rethrow;
    } on AuthException catch (e) {
      print(e.message);
    }

    return false;
  }

  Future<void> login(BuildContext context) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    const processingBar = SnackBar(content: Text('Processing Data'));
    ScaffoldMessenger.of(context).showSnackBar(processingBar);

    // process login

    bool signedIn = false;
    try {
      signedIn = await signInUser();
    } on UserNotConfirmedException {
      String code = "";
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Account Confirmation'),
                content: SizedBox(
                    height: 200,
                    child: Column(children: [
                      const Text('Enter your confirmation code'),
                      TextField(
                        style: const TextStyle(fontSize: 25),
                        onChanged: (value) {
                          code = value.trim();
                        },
                      )
                    ])),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Confirm'),
                    onPressed: () async {
                      await Amplify.Auth.confirmSignUp(
                          username: emailCtrl.text.trim(),
                          confirmationCode: code);
                      Navigator.of(context).pop();
                      await login(_formKey.currentContext as BuildContext);
                      final user = await CurrentUser().get();
                      await Gateway().addOfficer(user.userId);
                    },
                  ),
                ]);
          });
      return;
    }
    if (!signedIn) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Failed to Log in'),
                content: const Text('Invalid Username and/or Password'),
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
      Navigator.pushNamedAndRemoveUntil(context, "home", (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Logo(),
            VisibleTextField(
              controller: emailCtrl,
            ),
            ObscuredTextField(
              controller: passCtrl,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  Amplify.Auth.signOut();
                  login(context);
                },
                child: const Text('Login'),
              ),
            ),
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "home", (_) => false);
                  },
                  child: const Text('Debug Skip Login'),
                ),
              ),
          ],
        )));
  } // build

}
