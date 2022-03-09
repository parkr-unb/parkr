import 'package:flutter/material.dart';

class VisibleTextField extends StatefulWidget {
  const VisibleTextField({Key? key,
    required this.controller,
    this.label = "Email",
    this.hint = "Enter your email",
    this.validatorText = "You must enter a valid email"}) : super(key: key);
  final TextEditingController controller;
  final String label;
  final String hint;
  final String validatorText;

  @override
  State<VisibleTextField> createState() => _VisibleTextFieldState();
}

class _VisibleTextFieldState extends State<VisibleTextField> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return widget.validatorText;
            }
            return null;
          }),
    );
  } // build
}
