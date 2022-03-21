import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:parkr/widgets/visibletextfield.dart';
import 'package:parkr/widgets/logo.dart';
import 'package:parkr/widgets/obscuredtextfield.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/user.dart';
import 'package:parkr/widgets/loadingdialog.dart';

class RegisterOrgForm extends StatefulWidget {
  const RegisterOrgForm({Key? key}) : super(key: key);

  static const String title = 'Login';

  @override
  State<RegisterOrgForm> createState() => _RegisterOrgFormState();
}

class _RegisterOrgFormState extends State<RegisterOrgForm> {
  TextEditingController orgNameCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
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

  // TODO: Chris, why are you returning empty strings here??
  Future<Object?> registerAdmin(BuildContext context) async {
    Map<CognitoUserAttributeKey, String> userAttributes = {
      CognitoUserAttributeKey.name: nameCtrl.text.trim()
      // additional attributes as needed
    };

    SignUpResult result = await Amplify.Auth.signUp(
        username: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
        options: CognitoSignUpOptions(userAttributes: userAttributes));

    // process login
    bool signedIn = false;
    try {
      signedIn = await signInUser();
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
                      SignUpResult res = await Amplify.Auth.confirmSignUp(
                          username: emailCtrl.text.trim(),
                          confirmationCode: code);
                      if(res.isSignUpComplete)
                      {
                        signedIn = await signInUser();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ]);
          });
    }
    if (!signedIn) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Failed to add Admin'),
                content: const Text('The admin was not able to be created'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]);
          }
      );
      return "";
    }
    await CurrentUser().update();
    final user = await CurrentUser().get();
    await Gateway().addAdmin(user.userId);
  }

  Future<Object> registerOrg(BuildContext context) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (!_formKey.currentState!.validate()) {
      return "";
    }

    await Gateway().addOrganization(orgNameCtrl.text.trim());
    return "";
  }

  //This is just a temporary form. We will need a way for organizations to
  // register themselves. Credit card info, parking lot geography, contact phone
  // number, etc. may be needed
  // maybe a scrollable form?
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            const Logo(),
            VisibleTextField(
              controller: orgNameCtrl,
              label: 'Organization Name',
              hint: 'Enter New Organization Name',
              validatorText: 'Organization name is mandatory',
            ),
            VisibleTextField(
              controller: nameCtrl,
              label: 'Full Name',
              hint: 'Enter Organization Administrator\'s Name',
              validatorText: 'Name is mandatory',
            ),
            VisibleTextField(
              controller: emailCtrl,
              label: 'Admin Email',
              hint: 'Enter Organization Administrator\'s Email',
              validatorText: 'Admin email is mandatory',
            ),
            ObscuredTextField(
              controller: passCtrl,
              label: 'Admin Password',
              hint: 'Enter the Organization Administrator\'s Password',
              validatorText: 'Admin password is mandatory',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    await loadingDialog(
                        context,
                        registerAdmin(context),
                        "Registering Admin...",
                        null,
                        "Failed to register organization manager");
                    await loadingDialog(
                        context,
                        registerOrg(context),
                        "Registering Organization...",
                        "Your organization is registered",
                        "Failed to register organization");

                    CurrentUser().admin = true;

                    Navigator.pushNamedAndRemoveUntil(
                        context, "home", (_) => false);
                  }
                },
                child: const Text('Create Organization'),
              ),
            ),
          ],
        )));
  } // build
}
