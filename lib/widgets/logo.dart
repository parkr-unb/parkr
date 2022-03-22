import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 20),
      child: Image.asset('assets/transparent_parkr_logo.png'),
    );
  } // build
}

class LogoSymbol extends StatelessWidget {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const LogoSymbol(
      {Key? key, this.left = 0, this.top = 0, this.right = 0, this.bottom = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: Image.asset('assets/transparent_parkr_symbol.png'),
    );
  } // build
}
