import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:parkr/widgets/loadingdialog.dart';

import 'package:parkr/displayable_exception.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/widgets/obscuredtextfield.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const String title = 'Settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController prevpassCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController confirmpassCtrl = TextEditingController();

  Future<Object?> changePass() async {
    try {
      await Amplify.Auth.updatePassword(newPassword: passCtrl.text, oldPassword: prevpassCtrl.text);
      return "Success";
    } on InvalidPasswordException catch (e) {
      throw DisplayableException("Please submit a more secure password");
    } on LimitExceededException catch (e) {
      throw DisplayableException("Cannot update password, try again tomorrow");
    }

  }

  Future<Object?> removeLots(BuildContext context) async {
    Object? res;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Remove Parking Lots'),
              content: const Text('Are you sure you want to remove all parking lots?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Remove'),
                  onPressed: () async {
                    res = await loadingDialog(
                        context,
                        Gateway().removeParkingLots(),
                        "Removing parking lots...",
                        "Success",
                        "Failed to remove parking lots");
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsPage.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Spacer(),
            const Text('Change Profile Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            ObscuredTextField(
              label: 'Previous password',
              controller: prevpassCtrl,
            ),
            ObscuredTextField(
              label: 'New password',
              controller: passCtrl,
            ),
            ObscuredTextField(
              label: 'Confirm new password',
              controller: confirmpassCtrl,
            ),
            ElevatedButton(
              child: const Text('Change Settings'),
              onPressed: () async {
                if(passCtrl.text == confirmpassCtrl.text){
                  await loadingDialog(context,
                      changePass(),
                      "Updating password...",
                      "Updated password",
                      "Failed to update password");
                }
              }),
            const Spacer(flex: 2),
            ElevatedButton(
                child: const Text('Add Parking Lot'),
                onPressed: () {
                  Navigator.pushNamed(context, "geo");
                }),
            ElevatedButton(
                child: const Text('Remove Parking Lots'),
                onPressed: () {
                  removeLots(context);
                }),
            const Spacer(),
          ],
        ),
      ),
    );
  } // build
}
