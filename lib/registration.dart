import 'package:amplify_flutter/amplify_flutter.dart';

class Registration {
  final String plate;
  final String email;
  final TemporalDateTime? start;
  final TemporalDateTime? end;
  final bool verified;

  Registration(this.plate, this.email, this.start, this.end, this.verified);
}