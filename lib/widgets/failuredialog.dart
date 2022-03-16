import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/51415236/show-circular-progress-dialog-in-login-screen-in-flutter-how-to-implement-progr
Object fail(BuildContext context, Future<Object> future, String text) async {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const Icon(Icons.error,
            color: Colors.red,
            size: 35.0),
        Container(margin: const EdgeInsets.only(left: 3), child: Text(text)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  Object o = await future.then((Object o) {
    Navigator.pop(context);
    return o;
  }).catchError((Object o) {
    Navigator.pop(context);
    return o;
  });
  return o;
}