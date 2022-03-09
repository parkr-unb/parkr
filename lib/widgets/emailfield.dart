import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  const EmailField({Key? key, required this.emailController}) : super(key: key);
  final TextEditingController emailController;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
          controller: widget.emailController,
          decoration: const InputDecoration(
              labelText: 'Email', hintText: 'Enter Valid Email'),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "Email is mandatory";
            }
            return null;
          }),
    );
  } // build
}
