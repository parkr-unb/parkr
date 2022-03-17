import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/51415236/show-circular-progress-dialog-in-login-screen-in-flutter-how-to-implement-progr
Future<Object> loading(BuildContext context, Future<Object?> future, String text) async {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(margin: const EdgeInsets.only(left: 7), child: Text(text)),
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
  return future.then((result) {
    Navigator.pop(context);
    Object val = result ?? "";
    return val;
  });
}