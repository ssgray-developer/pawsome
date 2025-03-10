import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawsome/data/pet/models/pet_model.dart';

class PetEntity {
  final String photoUrl;
  final String gender;
  final String name;
  final String age;
  final String petClass;
  final String petSpecies;
  final String petPrice;
  final String reason;
  final Map<String, dynamic> location;
  final DateTime? date;
  final String owner;
  final String ownerUid;
  final String ownerEmail;
  final String ownerPhotoUrl;
  final List likes;

  PetEntity({
    required this.photoUrl,
    required this.gender,
    required this.name,
    required this.age,
    required this.petClass,
    required this.petSpecies,
    required this.petPrice,
    required this.reason,
    required this.location,
    required this.date,
    required this.owner,
    required this.ownerUid,
    required this.ownerEmail,
    required this.ownerPhotoUrl,
    required this.likes,
  });

  @override
  String toString() {
    return 'PetEntity(id: $ownerUid, name: $name)';
  }
}

extension PetEntityXModel on PetEntity {
  PetModel toModel() {
    return PetModel(
      photoUrl: photoUrl,
      gender: gender,
      name: name,
      age: age,
      petClass: petClass,
      petSpecies: petSpecies,
      petPrice: petPrice,
      reason: reason,
      location: location,
      date: date != null ? Timestamp.fromDate(date!) : null,
      owner: owner,
      ownerUid: ownerUid,
      ownerEmail: ownerEmail,
      ownerPhotoUrl: ownerPhotoUrl,
      likes: likes,
    );
  }
}
