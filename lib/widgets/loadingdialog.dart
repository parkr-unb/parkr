import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/51415236/show-circular-progress-dialog-in-login-screen-in-flutter-how-to-implement-progr
Object? loading(BuildContext context, Future<Object?> future, String text) async {
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
//   var result = await future;
//   Navigator.pop(context);
//   return result;
  Object o = await future.then((Object o) {
    Navigator.pop(context);
    print("No error");
    return o;
  }).catchError((Object o) {
    Navigator.pop(context);
    print("Error caught");
    return o;
  });
  print("returning o");
  return o;
}