import 'package:flutter/material.dart';
import 'package:parkr/widgets/loadingdialog.dart';
import 'package:parkr/user.dart';

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
              // process login
              if (await loadingDialog(
                      context,
                      registerOfficer(emailCtrl.text, firstNameCtrl.text,
                          lastNameCtrl.text, passCtrl.text),
                      "Registering Officer...",
                      "${firstNameCtrl.text} is Registered",
                      "Failed to register officer") !=
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
