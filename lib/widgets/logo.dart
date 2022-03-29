import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  final bool keyboard;
  const Logo({required this.keyboard, Key? key}) : super(key: key);


  @override
  _Logo createState() => _Logo();
}
class _Logo extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      firstChild:
      Padding(
          padding: const EdgeInsets.fromLTRB(110, 10, 110, 20),
          child: Image.asset('assets/transparent_parkr_symbol.png')),
      secondChild:
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 20),
          child: Image.asset('assets/transparent_parkr_logo.png')),
      crossFadeState: widget.keyboard ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}