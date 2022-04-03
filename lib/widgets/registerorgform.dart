import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:parkr/displayable_exception.dart';
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
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<Object?> registerAdmin(BuildContext context) async {
    bool created = await loadingDialog(
      context,
      registerOfficer(emailCtrl.text, firstNameCtrl.text, lastNameCtrl.text, passCtrl.text, admin: true, orgID: orgNameCtrl.text),
      "Signing up Admin",
      null,
      "Failed to create ${emailCtrl.text} as admin"
    ) as bool? ?? false;
    if(!created) {
      throw DisplayableException("Failed to create Admin");
    }
    // process login
    bool signedIn = false;
    try {
      signedIn = (await loadingDialog(
          context,
          signInUser(emailCtrl.text, passCtrl.text),
          "Logging in",
          null,
          "Failed to Login to: ${emailCtrl.text}") as bool?) ??
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
                        as bool? ?? false;
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ]);
          });
    }
    if (!signedIn) {
      return null;
    }
    await Gateway().confirmOfficer();

    return "Success";
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
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Logo(keyboard: isKeyboardVisible),
              VisibleTextField(
                controller: orgNameCtrl,
                label: 'Organization Name',
                hint: 'Enter New Organization Name',
                validatorText: 'Organization name is mandatory',
              ),
              VisibleTextField(
                controller: firstNameCtrl,
                label: 'First Name',
                hint: 'Enter Organization Admin\'s First Name',
                validatorText: 'Name is mandatory',
              ),
              VisibleTextField(
                controller: lastNameCtrl,
                label: 'Last Name',
                hint: 'Enter Organization Admin\'s Last Name',
                validatorText: 'Name is mandatory',
              ),
              VisibleTextField(
                controller: emailCtrl,
                label: 'Admin Email',
                hint: 'Enter Organization Administrator\'s Email',
                validatorText: 'Admin email is mandatory',
                inputRegex: r"[A-Z]",
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

                      if (await loadingDialog(
                          context,
                          registerOrg(context),
                          "Registering Organization...",
                          "Your organization is registered",
                          "Failed to register organization") ==
                          null) {
                        return;
                      }

                      var success = await registerAdmin(context);
                      if(success == null)
                      {
                        return;
                      }

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
    });
  } // build
}
