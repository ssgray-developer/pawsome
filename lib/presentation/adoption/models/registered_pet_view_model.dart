import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawsome/domain/pet/entity/registered_pet.dart';

class RegisteredPetViewModel {
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

  RegisteredPetViewModel({
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

  factory RegisteredPetViewModel.fromEntity(RegisteredPet entity) {
    return RegisteredPetViewModel(
        postId: entity.postId,
        uid: entity.uid,
        photoUrl: entity.photoUrl,
        gender: entity.gender,
        name: entity.name,
        age: entity.age,
        petClass: entity.petClass,
        petSpecies: entity.petSpecies,
        petPrice: entity.petPrice,
        description: entity.description,
        location: entity.location,
        date: entity.date,
        owner: entity.owner,
        ownerUid: entity.ownerUid,
        ownerEmail: entity.ownerEmail,
        ownerPhotoUrl: entity.ownerPhotoUrl,
        likes: entity.likes);
  }
}
