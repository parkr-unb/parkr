import 'package:flutter/material.dart';

class ObscuredTextField extends StatefulWidget {
  const ObscuredTextField(
      {Key? key,
      required this.controller,
      this.label = "Password",
      this.hint = '',
      this.validatorText = "Please enter a valid password",
      this.padding = 25.0})
      : super(key: key);
  final TextEditingController controller;
  final String label;
  final String hint;
  final String validatorText;
  final double padding;

  @override
  State<ObscuredTextField> createState() => _ObscuredTextFieldState();
}

class _ObscuredTextFieldState extends State<ObscuredTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.padding),
        child: TextFormField(
            controller: widget.controller,
            obscureText: _isObscure,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
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
                return widget.validatorText;
              }
              return null;
            }));
  } // build
}
