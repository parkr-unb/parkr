import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:parkr/displayable_exception.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/models/Officer.dart';

Future<void> registerOfficer(
    String email, String firstName, String lastName, String password) async {
  // basic email validation before sending cognito request
  final emailTrimmed = email.trim();
  final splitEmail = emailTrimmed.split("@");
  if (splitEmail.length != 2) {
    throw DisplayableException("Email must contain a single '@'");
  }

  final fullName = lastName.trim() + ',' + firstName.trim();
  try {
    Map<CognitoUserAttributeKey, String> userAttributes = {
      CognitoUserAttributeKey.name: fullName
      // additional attributes as needed
    };

    SignUpResult result = await Amplify.Auth.signUp(
        username: emailTrimmed,
        password: password.trim(),
        options: CognitoSignUpOptions(userAttributes: userAttributes));
    if (!result.isSignUpComplete) {
      throw DisplayableException("Register Operation did not complete");
    }
  } on InvalidPasswordException {
    throw DisplayableException("Password must be at least 8 characters");
  } on UsernameExistsException {
    throw DisplayableException(
        "An officer with the provided email already exists");
  } on InvalidParameterException catch (e) {
    // e message from cognito is directly displayable
    throw DisplayableException(e.toString());
  } on AuthException catch (e) {
    final msgParts = e.message.split(':');
    final ignoreIdx = msgParts.length - 1;
    final presentableMsg = msgParts.sublist(ignoreIdx).join(':').trim();
    throw DisplayableException(presentableMsg);
  }
}

Future<bool> signInUser(String email, String password) async {
  try {
    await Amplify.Auth.signOut();
    SignInResult result = await Amplify.Auth.signIn(
      username: email.trim(),
      password: password.trim(),
    );
    if (result.isSignedIn) {
      await CurrentUser().get();
      await CurrentUser().update();
      return true;
    }
  } on UserNotConfirmedException {
    rethrow;
  } on AuthException catch (e) {
    print(e.message);
  }

  return false;
}

Future<SignUpResult> confirmUser(String email, String confirmCode) async {
  return await Amplify.Auth.confirmSignUp(
      username: email.trim(), confirmationCode: confirmCode.trim());
}

class CurrentUser {
  static CurrentUser _instance = CurrentUser._privateConstructor();
  static AuthUser? _user;
  String? _name;
  Officer? _officer;
  bool _admin = false;

  CurrentUser._privateConstructor();

  factory CurrentUser() {
    return _instance;
  }

  void clear() {
    _instance = CurrentUser._privateConstructor();
  }

  Future<void> update() async {
    _officer ??= await Gateway().getOfficerByID((await get()).userId);
    if (_officer != null) {
      admin = _officer?.role == "admin";
    }

    var res = await Amplify.Auth.fetchUserAttributes();
    for (var element in res) {
      if (element.userAttributeKey.key == "name") {
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

  set admin(bool auth) {
    _admin = auth;
  }

  bool isAdmin() {
    return _admin;
  }

  String? getOrg() {
    if (_officer != null && _officer?.organization != null) {
      return _officer?.organization?.getId();
    }
    return "";
  }
}
