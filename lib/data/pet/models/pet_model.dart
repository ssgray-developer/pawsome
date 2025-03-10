import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';

class PetModel {
  final String photoUrl;
  final String gender;
  final String name;
  final String age;
  final String petClass;
  final String petSpecies;
  final String petPrice;
  final String reason;
  final Map<String, dynamic> location;
  final Timestamp? date;
  final String owner;
  final String ownerUid;
  final String ownerEmail;
  final String ownerPhotoUrl;
  final List likes;

  PetModel({
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
    return 'PetModel(id: $ownerUid, name: $name)';
  }

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      photoUrl: json["photoUrl"],
      gender: json["gender"],
      name: json["name"],
      age: json["age"],
      petClass: json["petClass"],
      petSpecies: json["petSpecies"],
      petPrice: json["petPrice"],
      reason: json["reason"],
      location: json["location"],
      date: json["date"],
      owner: json["owner"],
      ownerUid: json["ownerUid"],
      ownerEmail: json["ownerEmail"],
      ownerPhotoUrl: json["ownerPhotoUrl"],
      likes: json["likes"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "photoUrl": photoUrl,
      "gender": gender,
      "name": name,
      "age": age,
      "petClass": petClass,
      "petSpecies": petSpecies,
      "petPrice": petPrice,
      "reason": reason,
      "location": location,
      "date": date ?? FieldValue.serverTimestamp(),
      "owner": owner,
      "ownerUid": ownerUid,
      "ownerEmail": ownerEmail,
      "ownerPhotoUrl": ownerPhotoUrl,
      "likes": likes,
    };
  }
}

extension PetModelToEntity on PetModel {
  PetEntity toEntity() {
    return PetEntity(
      photoUrl: photoUrl,
      gender: gender,
      name: name,
      age: age,
      petClass: petClass,
      petSpecies: petSpecies,
      petPrice: petPrice,
      reason: reason,
      location: location,
      date: date?.toDate(),
      owner: owner,
      ownerUid: ownerUid,
      ownerEmail: ownerEmail,
      ownerPhotoUrl: ownerPhotoUrl,
      likes: likes,
    );
  }
}
