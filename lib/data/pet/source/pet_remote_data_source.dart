import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:pawsome/data/pet/models/pet_model.dart';
import 'package:pawsome/data/pet/models/register_pet_image_req.dart';
import 'package:uuid/uuid.dart';
import '../models/nearby_pet_req.dart';

abstract class PetRemoteDataSource {
  Stream<Either> listenToPetAdoption(NearbyPetReq nearbyPet);
  Future<Either> registerPet(PetModel pet);
  Future<Either> registerPetImage(RegisterPetImageReq pet);
}

class PetRemoteDataSourceImpl extends PetRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  PetRemoteDataSourceImpl(this.firebaseFirestore, this.firebaseStorage);

  @override
  Stream<Either> listenToPetAdoption(NearbyPetReq nearbyPet) {
    try {
      CollectionReference collectionReference =
          firebaseFirestore.collection('registeredPets');
      GeoPoint location =
          GeoPoint(nearbyPet.position.latitude, nearbyPet.position.longitude);
      GeoFirePoint center = GeoFirePoint(location);
      queryBuilder(Query<Object?> query) {
        return query.where('petClass', isEqualTo: nearbyPet.pet);
      }

      GeoPoint geopointFrom(Object? data) {
        // Safely cast `data` to `Map<String, dynamic>` inside the function
        final mapData = data as Map<String, dynamic>;
        return mapData['geo']['geopoint'] as GeoPoint;
      }

      Stream stream = GeoCollectionReference(collectionReference)
          .subscribeWithinWithDistance(
              center: center,
              radiusInKm: nearbyPet.radius.toDouble(),
              field: 'location',
              strictMode: true,
              queryBuilder: queryBuilder,
              geopointFrom: geopointFrom);

      return stream.map((event) => Right<String, dynamic>(event));
    } catch (e) {
      return Stream.value(Left<String, dynamic>('Error: $e'));
    }
  }

  @override
  Future<Either> registerPet(PetModel pet) async {
    try {
      String postId = const Uuid().v1();

      await firebaseFirestore
          .collection('registeredPets')
          .doc(postId)
          .set(pet.toJson());
      return const Right('Pet registered successfully.');
    } catch (e) {
      return const Left('Google sign out failure');
    }
  }

  @override
  Future<Either> registerPetImage(RegisterPetImageReq pet) async {
    try {
      String postId = const Uuid().v1();

      Reference ref = firebaseStorage
          .ref()
          .child('registeredPets')
          .child(pet.userUid)
          .child('$postId.jpg');

      UploadTask uploadTask = ref.putData(pet.image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return Right(downloadUrl);
    } catch (e) {
      return const Left('Failed to upload pet image.');
    }
  }
}
