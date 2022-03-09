import 'package:flutter/material.dart';
import 'package:parkr/widgets/visibletextfield.dart';
import 'package:parkr/widgets/logo.dart';
import 'package:parkr/widgets/obscuredtextfield.dart';

class RegisterOrgForm extends StatefulWidget {
  const RegisterOrgForm({Key? key}) : super(key: key);

  static const String title = 'Login';

  @override
  State<RegisterOrgForm> createState() => _RegisterOrgFormState();
}

class _RegisterOrgFormState extends State<RegisterOrgForm> {
  TextEditingController orgNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //This is just a temporary form. We will need a way for organizations to
  // register themselves. Credit card info, parking lot geography, contact phone
  // number, etc. may be needed
  // maybe a scrollable form?
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );

                    // TODO:
                    // register the admin user
                    // register the org
                    // immediatly present the confirmation dialog
                  }
                },
                child: const Text('Create Organization'),
              ),
            ),
          ],
        ));
  } // build
}
