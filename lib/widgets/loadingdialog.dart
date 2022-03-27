import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkr/displayable_exception.dart';

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

AlertDialog createFailureDialog(String text) {
  return AlertDialog(
    scrollable: true,
    content: Column(
      children: [
        const Icon(Icons.error, color: Colors.red, size: 35.0),
        Text(text)
      ],
    ),
  );
}

Future<Object?> loadingDialog(BuildContext context, Future<Object?> future,
    String loadingText, String? successText, String? failureText,
    {resultDialogDelay = const Duration(seconds: 2),
    useExceptionText = true,
    timeoutDelay = const Duration(seconds: 8)}) async {
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
    failureDialog = createFailureDialog(failureText);
  }

  // start loading dialog
  await _displayDialog(context, loadingDialog);

  // execute provided future
  Object? result;
  try {
    result = await (future.timeout(timeoutDelay));
  } on DisplayableException catch (e) {
    failureDialog = createFailureDialog(e.toString());
  } on TimeoutException catch (e) {
    failureDialog = createFailureDialog(
        "Poor Network Quality. Request timed out. Please try again.");
  } catch (e) {
    print(e);
    Navigator.pop(context);
    rethrow;
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
