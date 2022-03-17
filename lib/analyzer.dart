import 'package:parkr/registration.dart';

isValid(Registration reg)
{
  return {
    'haspass': false,
    'invalidLot': false,
    'blocking': false,
    'multiple': false,
    'alt': false
  };
}