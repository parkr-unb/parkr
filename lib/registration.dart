class Registration {
  final String plate;
  final DateTime start;
  final DateTime end;

  Registration(this.plate, this.start, this.end);
  Registration.basic() : plate = "123", start = DateTime(2000,6,6), end = DateTime(2001,6,6);
}