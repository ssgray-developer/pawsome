import 'package:cloud_firestore/cloud_firestore.dart';

class RegisteredPet {
  final String postId;
  final String uid;
  final String photoUrl;
  final String gender;
  final String name;
  final String age;
  final String petClass;
  final String petSpecies;
  final String petPrice;
  final String description;
  final Map<String, dynamic> location;
  final FieldValue date;
  final String owner;
  final String ownerUid;
  final String ownerEmail;
  final String ownerPhotoUrl;
  final List likes;

  RegisteredPet({
    required this.postId,
    required this.uid,
    required this.photoUrl,
    required this.gender,
    required this.name,
    required this.age,
    required this.petClass,
    required this.petSpecies,
    required this.petPrice,
    required this.description,
    required this.location,
    required this.date,
    required this.owner,
    required this.ownerUid,
    required this.ownerEmail,
    required this.ownerPhotoUrl,
    required this.likes,
  });
}
