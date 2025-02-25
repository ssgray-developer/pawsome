import 'dart:typed_data';

class PetRegistrationReq {
  final Uint8List file;
  final String gender;
  final String name;
  final String age;
  final String petClass;
  final String species;
  final String currency;
  final String price;
  final String reason;

  PetRegistrationReq(
      {required this.file,
      required this.gender,
      required this.name,
      required this.age,
      required this.petClass,
      required this.species,
      required this.currency,
      required this.price,
      required this.reason});
}
