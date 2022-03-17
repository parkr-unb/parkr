import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:parkr/analyzerResult.dart';
import 'package:parkr/registration.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/models/ParkingPermits.dart';
import 'package:parkr/models/ParkingPermit.dart';


Future<AnalyzerResult> isValid(String license) async
{
  ParkingPermits? permits = await Gateway().queryParkingPermits(license);

  for (var p in permits?.permits ?? []) {
    if (analyze(p) == 1)
      {
        return AnalyzerResult(true, false, false, false, false);
      }
  }
  return AnalyzerResult(false, false, false, false, false);
}

int analyze(ParkingPermit permit)
{
  if (permit.termStart.compareTo(TemporalDateTime.now()) <= 0 && permit.termEnd.compareTo(TemporalDateTime.now()) >= 0)
  {
    return 1;
  }
  return 0;
}