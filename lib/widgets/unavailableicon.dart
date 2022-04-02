import 'package:flutter/material.dart';

class UnavailableIcon extends StatelessWidget {
  final String message;
  final Icon icon;

  const UnavailableIcon(
      {Key? key,
      required this.message,
      this.icon = const Icon(Icons.warning, color: Colors.grey, size: 60)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: TextStyle(
                    color: icon.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                text: message)),
      ],
    );
  }
}
