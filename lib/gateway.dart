import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:parkr/models/ModelProvider.dart';
import 'package:parkr/user.dart';

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
      final ticket = Ticket(id: licenseOrg, createdAt: TemporalDateTime.now());
      final request = ModelMutations.create(ticket);
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

  Future<Officer?> addAdmin(String userId) async {
    try {
      final admin = Officer(id: userId, role: "admin");
      final request = ModelMutations.create(admin);
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
  Future<Organization?> addOrganization(String orgId) async {
    try {
      final org = Organization(id: orgId);
      final request = ModelMutations.create(org);
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
  Future<Officer?> getOfficerByID(String id) async {
    try {
      final request = ModelQueries.get(Officer.classType, id);
      final response = await Amplify.API.query(request: request).response;
      Officer? officer = response.data;
      if (officer == null) {
        print('errors: ' + response.errors.toString());
        return null;
      }
      print("Query: " + officer.toString());
      return officer;
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return null;
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

// Future<List<ParkingPermit>?> queryParkingPermits(String license) async {
//   final licenseOrg = license.trim().replaceAll("-", "") + "-" + "unb";
//   const getTodo = 'getParkingPermits';
//   String graphQLDocument = '''query GetParkingPermits(\$id: ID!) {
//     $getParkingPermit(licenseOrg: "jjt495-unb", termStart: "false") {
//         termEnd
//         termStart
//         passType
//       }
//     }''';
//   try {
//     final request = ModelQueries.list(ParkingPermit.classType,
//         where: QueryField(fieldName: fieldName));
//     final response = await Amplify.API.query(request: request).response;
//     if (response.data == null) {
//       print('errors: ' + response.errors.toString());
//     }
//     return response.data;
//   } on ApiException catch (e) {
//     print('Query failed: $e');
//   }
// }
}
