import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class CurrentUser {
  static final CurrentUser _instance = CurrentUser._privateConstructor();
  static AuthUser? _user;
  CurrentUser._privateConstructor();

  factory CurrentUser() {
    return _instance;
  }

  Future<AuthUser> get() async {
    if(_user == null) {
      _user = await Amplify.Auth.getCurrentUser();
    }
    return _user as AuthUser;
  }
}
