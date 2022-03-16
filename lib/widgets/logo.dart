import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 20),
        child: Image.asset('assets/parkr_logo.png'),
    );
  } // build
}
