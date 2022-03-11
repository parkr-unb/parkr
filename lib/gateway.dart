import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:parkr/models/ModelProvider.dart';

class Gateway {
  static final Gateway _instance = Gateway._privateConstructor();

  Gateway._privateConstructor();

  factory Gateway() {
    return _instance;
  }

  // Future<Ticket?> administerTicket(String license) async {
  //   // TODO: accept org in a better way
  //   // TODO: also send an email to parker
  //   final licenseOrg = license.trim().replaceAll("-", "") + "-" + "unb";
  //   try {
  //     final ticket = Ticket(id: licenseOrg, createdAt: TemporalDateTime.now());
  //     final request = ModelMutations.create(ticket);
  //     final response = await Amplify.API.mutate(request: request).response;
  //
  //     if (response.data == null) {
  //       print('errors: ' + response.errors.toString());
  //     }
  //     return response.data;
  //   } on ApiException catch (e) {
  //     print('Mutation failed: $e');
  //     rethrow;
  //   }
  // }

  // provide the userId created by cognito
  Future<Officer?> addOfficer(String userId) async {
    try {
      final officer = Officer(id: userId, role: "officer");
      final request = ModelMutations.create(officer);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data == null) {
        print('errors: ' + response.errors.toString());
      }
      return response.data;
    } on ApiException catch (e) {
      print('Mutation failed: $e');
      rethrow;
    }
  }

  Future<List<Officer?>?> listOfficers() async {
    try {
      final request = ModelQueries.list(Officer.classType);
      final response = await Amplify.API.query(request: request).response;
      if (response.data == null) {
        print('errors: ' + response.errors.toString());
        return null;
      } else {
        return response.data?.items;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      rethrow;
    }
  }

  Future<ParkingPermits?> createParkingPermit(String license, String firstName, String lastName, String email) async {
    final ParkingPermit pass = ParkingPermit(termStart: TemporalDateTime(DateTime.parse("2022-02-10T20:03:33.604760000Z")), termEnd: TemporalDateTime(DateTime.parse("2022-02-10T20:03:33.604760000Z")), passType: 'student');
    final List<ParkingPermit> passes = List.filled(1, pass, growable: false);
    try {
      ParkingPermits permits = ParkingPermits(id: '$license-unb', permits: passes, firstName: firstName, lastName: lastName, emailAddress: email);
      final request = ModelMutations.create(permits);
      final response = await Amplify.API.mutate(request: request).response;

      ParkingPermits? created = response.data;
      if (created == null) {
        print('errors: ' + response.errors.toString());
        return null;
      }
      print('Mutation result: ' + created.toString());
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }

  Future<List<ParkingPermits>?> queryParkingPermits(String license) async {
    // chef's kiss
    try {
      final request = ModelQueries.get(
          ParkingPermits.classType, license);
      final response = await Amplify.API.query(request: request).response;
      ParkingPermits? passes = response.data;
      if (passes == null) {
        print('errors: ' + response.errors.toString());
        return null;
      }
      print("Query: " + (passes.permits?.elementAt(0)?.toString() ?? ''));
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
  }
}
