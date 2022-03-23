import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/user.dart';
import 'package:parkr/widgets/loadingdialog.dart';
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

  Future<Object?> login(BuildContext context) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (!_formKey.currentState!.validate()) {
      return null;
    }

    // process login
    bool signedIn = false;
    try {
      signedIn = await signInUser(emailCtrl.text, passCtrl.text);
    } on UserNotConfirmedException {
      String code = "";
      await showDialog(
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
                      final res = await confirmUser(emailCtrl.text, code);
                      if (res.isSignUpComplete) {
                        signedIn =
                            await signInUser(emailCtrl.text, passCtrl.text);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ]);
          });
      if (signedIn) {
        final user = await CurrentUser().get();
        await Gateway().addOfficer(user.userId);
      }
    }
    if (!signedIn) {
      return null;
    }
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Logo(keyboard: isKeyboardVisible),
              VisibleTextField(
                controller: emailCtrl,
              ),
              ObscuredTextField(
                controller: passCtrl,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (await loadingDialog(
                            context,
                            login(context),
                            "Logging In...",
                            null,
                            "Failed to log ${emailCtrl.text} in") !=
                        null) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "home", (_) => false);
                    }
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
    });
  } // build

}
