import 'dart:ffi';

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

  Future<Tickets?> administerTicket(String license, String ticketType) async {
    // TODO: accept org in a better way
    // TODO: also send an email to parker
    final licenseOrg = license.trim().replaceAll("-", "") + "-" + "unb";
    try {
      final request = ModelQueries.get(Tickets.classType, licenseOrg);
      final response = await Amplify.API.query(request: request).response;
      Tickets? tickets = response.data;
      if (tickets == null) {
        // No tickets associated with license plate, create a row
        print('errors (response): ' + response.errors.toString());
        final Ticket newTicket =
            Ticket(createdAt: TemporalDateTime.now(), type: ticketType);
        final List<Ticket> newTicketList =
            List.filled(1, newTicket, growable: true);
        final Tickets newTickets =
            Tickets(id: licenseOrg, tickets: newTicketList);
        final createRequest = ModelMutations.create(newTickets);
        final createResponse =
            await Amplify.API.mutate(request: createRequest).response;
        if (createResponse.data == null) {
          print('errors (createResponse): ' + createResponse.errors.toString());
        }
        return createResponse.data;
      }
      // Tickets found with license plate, add ticket to Tickets list
      final Ticket newTicket =
          Ticket(createdAt: TemporalDateTime.now(), type: ticketType);
      tickets.tickets?.add(newTicket);
      final mutationRequest = ModelMutations.update(tickets);
      final mutationResponse =
          await Amplify.API.mutate(request: mutationRequest).response;
      if (mutationResponse.data == null) {
        print(
            'errors (mutationResponse): ' + mutationResponse.errors.toString());
      }
      return mutationResponse.data;
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

  Future<ParkingPermits?> createParkingPermit(
      String license, String firstName, String lastName, String email) async {
    // Only used for inputting passes into database manually
    // Would use existing system to enter passes in real world
    final ParkingPermit pass = ParkingPermit(
        termStart:
            TemporalDateTime(DateTime.parse("2022-02-10T20:03:33.604760000Z")),
        termEnd:
            TemporalDateTime(DateTime.parse("2022-02-10T20:03:33.604760000Z")),
        passType: 'student');
    final List<ParkingPermit> passes = List.filled(1, pass, growable: true);
    try {
      ParkingPermits permits = ParkingPermits(
          id: '$license-unb',
          permits: passes,
          firstName: firstName,
          lastName: lastName,
          emailAddress: email);
      final request = ModelMutations.create(permits);
      final response = await Amplify.API.mutate(request: request).response;

      ParkingPermits? created = response.data;
      if (created == null) {
        print('errors: ' + response.errors.toString());
        return null;
      }
      print('Mutation result: ' + created.toString());
      return created;
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
    return null;
  }

  Future<ParkingPermits?> queryParkingPermits(String license) async {
    try {
      final request = ModelQueries.get(ParkingPermits.classType, license);
      final response = await Amplify.API.query(request: request).response;
      ParkingPermits? passes = response.data;
      if (passes == null) {
        print('errors: ' + response.errors.toString());
        return null;
      }
      print("Query: " + (passes.permits?.elementAt(0)?.toString() ?? ''));
      return passes;
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return null;
  }

  AppKeys? cachedKeys;

  Future<AppKeys?> queryAppKeys({useCached = true}) async {
    if (cachedKeys != null && useCached == true) {
      return cachedKeys;
    }
    try {
      final request = ModelQueries.get(AppKeys.classType, "shared");
      final response = await Amplify.API.query(request: request).response;
      AppKeys? appKeys = response.data;
      if (appKeys == null) {
        print('errors: ' + response.errors.toString());
        return null;
      }
      cachedKeys = appKeys;
      return appKeys;
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return null;
  }
}
