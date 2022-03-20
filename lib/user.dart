import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'gateway.dart';
import 'models/Officer.dart';

class CurrentUser {
  static CurrentUser _instance = CurrentUser._privateConstructor();
  static AuthUser? _user;
  String? _name;
  Officer? _officer;

  CurrentUser._privateConstructor();

  factory CurrentUser() {
    return _instance;
  }
  void clear() {
    _instance = CurrentUser._privateConstructor();
  }

  Future<void> update() async {
    _officer ??= await Gateway().getOfficerByID((await get()).userId);

    var res = await Amplify.Auth.fetchUserAttributes();
    for(var element in res)
    {
      if(element.userAttributeKey.key == "name")
      {
        var rawName = element.value;
        var commaIdx = rawName.indexOf(',');
        var firstName = rawName.substring(commaIdx + 1);
        var lastName = "";
        if (commaIdx != -1) {
          lastName = rawName.substring(0, commaIdx);
        }
        _name = firstName + " " + lastName;
      }
    }
  }

  Future<AuthUser> get() async {
    _user ??= await Amplify.Auth.getCurrentUser();
    return _user as AuthUser;
  }

  String? getName() {
    return _name ?? "Yevgen";
  }

  bool isAdmin() {
    return _officer?.role == "admin";
  }

  String? getOrg() {
    if (_officer != null && _officer?.organization != null) {
      return _officer?.organization?.getId();
    }
    return "";
  }
}
