import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VisibleTextField extends StatelessWidget {
  const VisibleTextField(
      {Key? key,
      required this.controller,
      this.label = "Email",
      this.hint = "Enter your email",
      this.validatorText = "You must enter a valid email",
      this.inputRegex = "",
      this.padding = 25.0})
      : super(key: key);
  final TextEditingController controller;
  final String label;
  final String hint;
  final String validatorText;
  final String inputRegex;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp(inputRegex)),
          ],
          controller: controller,
          decoration:
              InputDecoration(labelText: label, hintText: hint),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return validatorText;
            }
            return null;
          }),
    );
  } // build
}
