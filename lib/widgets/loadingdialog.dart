import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> _displayDialog(BuildContext ctx, AlertDialog? dialog,
    {delay = const Duration(seconds: 0)}) async {
  if (dialog != null) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext context) {
        return dialog;
      },
    );
    await Future.delayed(delay);
  }
}

Future<void> _displayClosingDialog(BuildContext ctx, AlertDialog? dialog,
    {delay = const Duration(seconds: 0)}) async {
  if (dialog != null) {
    await _displayDialog(ctx, dialog, delay: delay);
    Navigator.pop(ctx);
  }
}

Future<Object?> loadingDialog(BuildContext context, Future<Object?> future,
    String loadingText, String? successText, String? failureText,
    {resultDialogDelay = const Duration(seconds: 2)}) async {
  AlertDialog loadingDialog = AlertDialog(
    scrollable: true,
    content: Column(
      children: [const CircularProgressIndicator(), Text(loadingText)],
    ),
  );

  AlertDialog? successDialog;
  if (successText != null) {
    successDialog = AlertDialog(
      scrollable: true,
      content: Column(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 35.0),
          Text(successText)
        ],
      ),
    );
  }

  AlertDialog? failureDialog;
  if (failureText != null) {
    failureDialog = AlertDialog(
      scrollable: true,
      content: Column(
        children: [
          const Icon(Icons.error, color: Colors.red, size: 35.0),
          Text(failureText)
        ],
      ),
    );
  }

  // start loading dialog
  await _displayDialog(context, loadingDialog);

  // execute provided future
  Object? result;
  try {
    result = await future;
  } catch (e) {
    print(e);
    result = null;
  }
  Navigator.pop(context);

  // handle future result
  AlertDialog? dialog = successDialog;
  String? debugText = successText;
  if (result == null) {
    dialog = failureDialog;
    debugText = failureText;
  }

  if (kDebugMode && debugText != null) print(debugText);
  await _displayClosingDialog(context, dialog, delay: resultDialogDelay);
  return result;
}
