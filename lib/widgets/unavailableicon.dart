import 'package:flutter/material.dart';

class UnavailableIcon extends StatelessWidget {
  final String message;
  final IconData iconData;

  const UnavailableIcon(
      {Key? key,
      required this.message,
      this.iconData = Icons.warning})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Icon icon = Icon(iconData, color: Colors.grey, size: 60);
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
