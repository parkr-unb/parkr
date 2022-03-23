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
      signedIn = (await loadingDialog(
              context,
              signInUser(emailCtrl.text, passCtrl.text),
              "Logging In...",
              null,
              "Failed to log ${emailCtrl.text} in") as bool?) ??
          false;
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
                        textAlign: TextAlign.center,
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
                      final res = await loadingDialog(
                          context,
                          confirmUser(emailCtrl.text, code),
                          "Confirming User...",
                          null,
                          "Failed to confirm user") as SignUpResult?;
                      if (res == null) {
                        signedIn = false;
                      } else if (res.isSignUpComplete) {
                        signedIn = await loadingDialog(
                                    context,
                                    signInUser(emailCtrl.text, passCtrl.text),
                                    "Signing In...",
                                    null,
                                    "Parkr experienced an error signing you in. Please try again.")
                                as bool? ??
                            false;
                        Navigator.of(context).pop();
                      }
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
                    if (await login(context) != null) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "home", (_) => false);
                    } else {
                      print("LITERALLY FUCK YOU");
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
