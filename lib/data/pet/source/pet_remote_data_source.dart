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
  Stream<Either<String, List<PetModel>>> listenToPetAdoption(
      NearbyPetReq nearbyPet);
  Future<Either> registerPet(PetModel pet);
  Future<Either> registerPetImage(RegisterPetImageReq pet);
  Future<Either> retrieveSinglePet(String docId);
}

class PetRemoteDataSourceImpl extends PetRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  PetRemoteDataSourceImpl(this.firebaseFirestore, this.firebaseStorage);

  @override
  Stream<Either<String, List<PetModel>>> listenToPetAdoption(
      NearbyPetReq nearbyPet) {
    try {
      CollectionReference collectionReference =
          firebaseFirestore.collection('registeredPets');
      GeoFirePoint center = nearbyPet.position;
      queryBuilder(Query<Object?> query) {
        return query.where('petClass', isEqualTo: nearbyPet.pet);
      }

      GeoPoint geoPointFrom(Object? data) {
        final mapData = data as Map<String, dynamic>;
        // print(mapData);
        return (mapData['location'] as Map<String, dynamic>)['geopoint']
            as GeoPoint;
      }

      Stream<List<GeoDocumentSnapshot>> stream =
          GeoCollectionReference(collectionReference)
              .subscribeWithinWithDistance(
                  center: center,
                  radiusInKm: nearbyPet.radius.toDouble(),
                  field: 'location',
                  strictMode: true,
                  queryBuilder: queryBuilder,
                  geopointFrom: geoPointFrom);

      return stream.map((event) {
        return Right(
          event.map((snapshot) {
            // Ensure data is retrieved as a Map<String, dynamic>
            final documentData = snapshot.documentSnapshot.data();
            return PetModel.fromJson(documentData);
          }).toList(),
        );
      });
    } catch (e) {
      // Return an error message wrapped in Left
      return Stream.value(Left<String, List<PetModel>>('Error: $e'));
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
      return Right(postId);
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

  @override
  Future<Either> retrieveSinglePet(String docId) async {
    try {
      DocumentSnapshot snapshot =
          await firebaseFirestore.collection('registeredPets').doc(docId).get();
      return Right(snapshot.data());
    } catch (e) {
      return const Left('Failed to retrieve pet details.');
    }
  }
}
