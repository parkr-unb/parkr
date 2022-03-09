import 'package:flutter/material.dart';
import 'package:parkr/widgets/loginform.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({Key? key, required this.passwordController}) : super(key: key);
  final TextEditingController passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
            controller: widget.passwordController,
            obscureText: _isObscure,
            decoration: InputDecoration(
              labelText: 'Password',
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
                return "Password is mandatory";
              }
              return null;
            }));
  } // build
}
