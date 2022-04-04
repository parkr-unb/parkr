import 'package:flutter/material.dart';
import 'package:parkr/widgets/loadingdialog.dart';
import 'package:parkr/user.dart';
import 'package:parkr/widgets/obscuredtextfield.dart';
import 'package:parkr/widgets/visibletextfield.dart';

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
    const padding = 5.0;
    final textFields = <Widget>[
      VisibleTextField(
        controller: firstNameCtrl,
        label: "First Name",
        hint: "Enter Officer's First Name",
        validatorText: "First Name is mandatory",
        padding: padding,
      ),
      VisibleTextField(
          controller: lastNameCtrl,
          label: "Last Name",
          hint: "Enter Officer's Last Name",
          validatorText: "Last Name is mandatory",
          padding: padding),
      VisibleTextField(
          controller: emailCtrl, inputRegex: r'[A-Z]', padding: padding),
      ObscuredTextField(controller: passCtrl, padding: padding)
    ];

    return textFields;
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
