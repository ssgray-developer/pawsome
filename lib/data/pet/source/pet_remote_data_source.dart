import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:pawsome/data/pet/models/pet_model.dart';
import 'package:pawsome/data/pet/models/register_pet_image_req.dart';
import 'package:uuid/uuid.dart';
import '../models/like_adoption_req.dart';
import '../models/nearby_pet_req.dart';

abstract class PetRemoteDataSource {
  Stream<List<PetModel>> listenToPetAdoption(NearbyPetReq nearbyPet);
  Future<Either> registerPet(PetModel pet);
  Future<Either> registerPetImage(RegisterPetImageReq pet);
  Future<Either> retrieveSinglePet(String docId);
  Future<Either> likeAdoptionPost(LikeAdoptionReq likeReq);
}

class PetRemoteDataSourceImpl extends PetRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  PetRemoteDataSourceImpl(this.firebaseFirestore, this.firebaseStorage);

  @override
  Stream<List<PetModel>> listenToPetAdoption(NearbyPetReq nearbyPet) {
    CollectionReference collectionReference =
        firebaseFirestore.collection('registeredPets');
    GeoFirePoint center = nearbyPet.position;
    queryBuilder(Query<Object?> query) {
      if (nearbyPet.petClass != null && nearbyPet.petSpecies != null) {
        return query
            .where('petClass', isEqualTo: nearbyPet.petClass)
            .where('petSpecies', isEqualTo: nearbyPet.petSpecies);
      } else if (nearbyPet.petClass != null && nearbyPet.petSpecies == null) {
        return query.where('petClass', isEqualTo: nearbyPet.petClass);
      } else if (nearbyPet.petClass == null && nearbyPet.petSpecies != null) {
        return query.where('petSpecies', isEqualTo: nearbyPet.petSpecies);
      } else {
        return query;
      }
    }

    GeoPoint geoPointFrom(Object? data) {
      final mapData = data as Map<String, dynamic>;
      return (mapData['location'] as Map<String, dynamic>)['geopoint']
          as GeoPoint;
    }

    final Stream<List<GeoDocumentSnapshot>> stream =
        GeoCollectionReference(collectionReference).subscribeWithinWithDistance(
            center: center,
            radiusInKm: nearbyPet.radius.toDouble(),
            field: 'location',
            strictMode: true,
            queryBuilder: queryBuilder,
            geopointFrom: geoPointFrom);

    return stream.map((geoDocs) {
      return geoDocs.map((geoDoc) {
        final data = geoDoc.documentSnapshot.data() as Map<String, dynamic>;

        // Add the GeoPoint into the location map
        final geoPoint = data['location']['geopoint'] as GeoPoint;
        data['location'] = {
          'geopoint': geoPoint,
        };

        final petModel = PetModel.fromJson(data);
        petModel.setPostId(geoDoc.documentSnapshot.id);
        return petModel;
      }).toList();
    });
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

  @override
  Future<Either> likeAdoptionPost(LikeAdoptionReq likeReq) async {
    try {
      if (likeReq.likes.contains(likeReq.uid)) {
        await firebaseFirestore
            .collection('registeredPets')
            .doc(likeReq.postId)
            .update(
          {
            'likes': FieldValue.arrayRemove([likeReq.uid])
          },
        );
      } else {
        await firebaseFirestore
            .collection('registeredPets')
            .doc(likeReq.postId)
            .update(
          {
            'likes': FieldValue.arrayUnion([likeReq.uid])
          },
        );
      }
      return const Right('Like post successful.');
    } catch (e) {
      return const Left('Failed to retrieve pet details.');
    }
  }
}
