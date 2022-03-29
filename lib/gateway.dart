import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:parkr/displayable_exception.dart';
import 'package:parkr/models/ModelProvider.dart';
import 'package:parkr/user.dart';

import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:location/location.dart';


class Gateway {
  static final Gateway _instance = Gateway._privateConstructor();

  Gateway._privateConstructor();

  factory Gateway() {
    return _instance;
  }

  Future<EmailTicketResponse?> emailTicket(
      String emailAddress, String emailBody) async {
    const graphqlDocument = '''
    mutation SendEmailMutation(\$emailAddress:AWSEmail!, \$emailBody:String!) {
      emailTicket(emailAddress: \$emailAddress, emailBody: \$emailBody) {
        messageId
        error
        message
      }
    }''';

    final sendEmailRequest = GraphQLRequest<String>(
        document: graphqlDocument,
        variables: <String, String>{
          'emailAddress': emailAddress,
          'emailBody': emailBody
        });

    final response =
        await Amplify.API.mutate(request: sendEmailRequest).response;
    if (response.data != null) {
      Map<String, dynamic> jsonData = json.decode(response.data as String);
      return EmailTicketResponse.fromJson(jsonData);
    }
    return null;
  }

  Future<Tickets?> administerTicket(String license, String ticketType) async {
    // TODO: accept org in a better way
    // TODO: also send an email to parker
    final licenseOrg = license.trim().replaceAll("-", "") + "-" + CurrentUser().getOrg();
    try {
      final request = ModelQueries.get(Tickets.classType, licenseOrg);
      final response = await Amplify.API.query(request: request).response;
      Tickets? tickets = response.data;
      if (tickets == null) {
        // No tickets associated with license plate, create a row
        if (kDebugMode) {
          print('errors (response): ' + response.errors.toString());
        }
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
          if (kDebugMode) {
            print(
                'errors (createResponse): ' + createResponse.errors.toString());
          }
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
        if (kDebugMode) {
          print('errors (mutationResponse): ' +
              mutationResponse.errors.toString());
        }
      }
      return mutationResponse.data;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Mutation failed: $e');
      }
      rethrow;
    }
  }

  Future<Officer?> _addOfficer(String userId, String name, String role, {String? orgID=null}) async {
    try {
      Organization org;
      if(orgID == null) {
        Officer currentOfficer = CurrentUser().officer;
        org = currentOfficer.organization!;
      } else {
        final request = ModelQueries.get(Organization.classType, orgID);
        final response = await Amplify.API.query(request: request).response;
        if(response.data == null)
        {
          throw DisplayableException("Cannot find organization identifier: $orgID");
        }
        org = response.data!;
      }
      final officer = Officer(
          id: userId,
          role: role,
          name: name,
          organization: org,
          confirmed: false,
      );
      final request = ModelMutations.create(officer);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data == null) {
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
      }
      return response.data;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Mutation failed: $e');
      }
      rethrow;
    }
  }

  Future<Officer?> confirmOfficer() async {
    Officer officer = CurrentUser().officer;
    try {
      final request = ModelMutations.delete(officer);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data == null) {
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Mutation failed: $e');
      }
    }

    try {
      Officer updated = Officer(
        id: (await CurrentUser().get()).userId,
        name: officer.name,
        role: officer.role,
        organization: officer.organization,
        confirmed: true,
      );

      final request = ModelMutations.create(updated);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data == null) {
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
      }
      return response.data;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Mutation failed: $e');
      }
      rethrow;
    }

  }

  Future<Officer?> addOfficer(String userId, String fullName) async {
    return await _addOfficer(userId, fullName, "officer");
  }

  Future<Officer?> addAdmin(String userId, String fullName, String oId) async {
    return await _addOfficer(userId, fullName, "admin", orgID: oId);
  }

  Future<Officer?> removeOfficer(String userId) async {
    try {
      final request = ModelMutations.deleteById(Officer.classType, userId);
      final response = await Amplify.API.mutate(request: request).response;
      if (response.data == null) {
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
      }
      return response.data;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Mutation failed: $e');
      }
      rethrow;
    }
  }

  Future<Organization?> addOrganization(String orgId) async {
    try {
      final org = Organization(id: orgId);
      final request = ModelMutations.create(org);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data == null) {
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
      }
      return response.data;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Mutation failed: $e');
      }
      rethrow;
    }
  }

  Future<Officer?> getOfficerByID(String id) async {
    try {
      final request = ModelQueries.get(Officer.classType, id);
      final response = await Amplify.API.query(request: request).response;
      Officer? officer = response.data;
      if (officer == null) {
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
        return null;
      }
      if (kDebugMode) {
        print("Query: " + officer.toString());
      }
      return officer;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
    }
    return null;
  }

  Future<List<Officer?>?> listOfficers() async {
    try {
      final request = ModelQueries.list(Officer.classType);
      final response = await Amplify.API.query(request: request).response;
      if (response.data == null) {
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
        return null;
      } else {
        return response.data?.items;
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
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
            TemporalDateTime(DateTime.parse("2023-02-10T20:03:33.604760000Z")),
        passType: 'student');
    final List<ParkingPermit> passes = List.filled(1, pass, growable: true);
    try {
      ParkingPermits permits = ParkingPermits(
          id: '$license-' + CurrentUser().getOrg(),
          permits: passes,
          firstName: firstName,
          lastName: lastName,
          emailAddress: email);
      final request = ModelMutations.create(permits);
      final response = await Amplify.API.mutate(request: request).response;

      ParkingPermits? created = response.data;
      if (created == null) {
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
        return null;
      }
      if (kDebugMode) {
        print('Mutation result: ' + created.toString());
      }
      return created;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Mutation failed: $e');
      }
    }
    return null;
  }

  Future<ParkingPermits?> queryParkingPermits(String license) async {
    final licenseOrg = license.trim().replaceAll("-", "") + "-" + CurrentUser().getOrg();
    if (kDebugMode) {
      print(licenseOrg);
    }
    try {
      final request = ModelQueries.get(ParkingPermits.classType, licenseOrg);
      final response = await Amplify.API.query(request: request).response;
      ParkingPermits? passes = response.data;
      if (passes == null) {
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
        return null;
      }
      if (kDebugMode) {
        print("Query: " + (passes.permits?.elementAt(0).toString() ?? ''));
      }
      return passes;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
    }
    return null;
  }

  Future<Object?> addParkingLot(List<GeoCoord> coords, String name) async {
    final ParkingLot lot = ParkingLot(name: name, coords: coords);
    GraphQLRequest<Organization> request;
    GraphQLResponse<Organization> response;
    try {
      Organization? organization = await getOrganization(CurrentUser().getOrg());
      if (organization?.parkingLots == null) {
        final List<ParkingLot> lots = List.filled(1, lot, growable: true);
        organization?.parkingLots = lots;
      }
      else {
        organization?.parkingLots?.add(lot);
      }
      if (organization != null) {
        request = ModelMutations.update(organization);
        response = await Amplify.API.mutate(request: request).response;
        return "Success";
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Mutation failed: $e');
      }
    }
  }

  Future<Object?> removeParkingLots() async {
    GraphQLRequest<Organization> request;
    GraphQLResponse<Organization> response;
    try {
      Organization? organization = await getOrganization(CurrentUser().getOrg());
      if (organization?.parkingLots == null) {
        return "Success";
      }
      else {
        if (organization?.parkingLots != null) {
          organization?.parkingLots = <ParkingLot>[];
        }
      }
      if (organization != null) {
        request = ModelMutations.update(organization);
        response = await Amplify.API.mutate(request: request).response;
        return "Success";
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Mutation failed: $e');
      }
    }
  }

  Future<Organization?> getOrganization(String org) async {
    try {
      final request = ModelQueries.get(Organization.classType, org);
      final response = await Amplify.API.query(request: request).response;
      Organization? organization = response.data;
      if (organization == null) {
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
        return null;
      }
      return organization;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
    }
    return null;
  }

  List<LatLng> convertGeoCoordLatLng(List<GeoCoord>? coords) {
    List<LatLng> polygon = <LatLng>[];
    for (int i=0; i<(coords?.length ?? 0); i++) {
      polygon.add(LatLng(coords?.elementAt(i).latitude ?? 0.0, coords?.elementAt(i).longitude ?? 0.0));
    }
    return polygon;
  }

  Future<Object?> inParkingLot(LocationData? curLocation, String org) async {
    GraphQLRequest<Organization> request;
    GraphQLResponse<Organization> response;
    try {
      Organization? organization = await getOrganization(CurrentUser().getOrg());
      if (organization?.parkingLots != null) {
        for(int i=0; i<(organization?.parkingLots?.length ?? 0); i++) {
          if (PolygonUtil.containsLocation(LatLng(curLocation?.latitude ?? 0.0,
              curLocation?.longitude ?? 0.0), convertGeoCoordLatLng(
              organization?.parkingLots?.elementAt(i).coords), false)) {
            return organization?.parkingLots?.elementAt(i)?.name;
          }
        }
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Mutation failed: $e');
      }
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
        if (kDebugMode) {
          print('errors: ' + response.errors.toString());
        }
        return null;
      }
      cachedKeys = appKeys;
      return appKeys;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
    }
    return null;
  }
}
