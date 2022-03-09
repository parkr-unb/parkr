import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:parkr/models/ModelProvider.dart';
import 'package:parkr/models/Ticket.dart';

class Gateway {
  static final Gateway _instance = Gateway._privateConstructor();

  Gateway._privateConstructor();

  factory Gateway() {
    return _instance;
  }

  Future<Ticket?> administerTicket(String license) async {
    // TODO: accept org in a better way
    // TODO: also send an email to parker
    final licenseOrg = license.trim().replaceAll("-", "") + "-" + "unb";
    try {
      final ticket = Ticket(
          licenseOrg: licenseOrg, createdAt: TemporalDateTime.now());
      final request = ModelMutations.create(ticket);
      final response = await Amplify.API
          .mutate(request: request)
          .response;

      if (response.data == null) {
        print('errors: ' + response.errors.toString());
      }
      return response.data;
    } on ApiException catch (e) {
      print('Mutation failed: $e');
      rethrow;
    }
  }

  // provide the userId created by cognito
  Future<Officer?> addOfficer(String userId) async {
    try {
      final officer = Officer(userId: userId);
      final request = ModelMutations.create(officer);
      final response = await Amplify.API
          .mutate(request: request)
          .response;

      if (response.data == null) {
        print('errors: ' + response.errors.toString());
      }
      return response.data;
    } on ApiException catch (e) {
      print('Mutation failed: $e');
      rethrow;
    }
  }
}
