import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:parkr/analyzerResult.dart';
import 'package:parkr/registration.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/models/ParkingPermits.dart';
import 'package:parkr/models/ParkingPermit.dart';


Future<Registration> isValid(String license) async
{
  ParkingPermits? permits = await Gateway().queryParkingPermits(license);

  for (var p in permits?.permits ?? []) {
    if (analyze(p) == 1)
      {
        return Registration(license, permits?.emailAddress ?? '', p.termStart, p.termEnd, true);
      }
  }
  if (permits != null) {
    if (permits.permits != null) {
      if (permits.permits?.isNotEmpty ?? false) {
        return Registration(
          license, permits.emailAddress, permits.permits?.last.termStart,
            permits.permits?.last.termEnd, false);
      }
    }
  }
  return Registration(license, 'N/A', TemporalDateTime(DateTime(0,0,0,0,0,0,0,0)), TemporalDateTime(DateTime(0,0,0,0,0,0,0,0)), false);

}

int analyze(ParkingPermit permit)
{
  if (permit.termStart.compareTo(TemporalDateTime.now()) <= 0 && permit.termEnd.compareTo(TemporalDateTime.now()) >= 0)
  {
    return 1;
  }
  return 0;
}