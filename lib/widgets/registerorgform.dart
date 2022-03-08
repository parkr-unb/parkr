import 'package:flutter/material.dart';

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
  bool _isObscure = true;

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Image.asset('assets/parkr_logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                  controller: orgNameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Organization Name',
                      hintText: 'Enter New Organization Name'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Organization name is mandatory";
                    }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Admin Email',
                      hintText: 'Enter Organization Administrator\'s Email'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Admin email is mandatory";
                    }
                    return null;
                  }),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                    controller: passCtrl,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Admin Password',
                      hintText:
                        'Enter Organization Administrator\'s Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Admin password is mandatory";
                      }
                      return null;
                    })),
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
