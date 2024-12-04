import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawsome/domain/pet/entity/pet_item.dart';

import '../models/nearby_pet_req.dart';

abstract class PetService {
  Stream<Either> listenToPetAdoption(NearbyPetReq pet);
}

class PetServiceImpl extends PetService {
  final FirebaseFirestore firebaseFirestore;

  PetServiceImpl(this.firebaseFirestore);

  @override
  Stream<Either> listenToPetAdoption(NearbyPetReq pet) {
    try {
      CollectionReference collectionReference =
          firebaseFirestore.collection('registeredPets');
      GeoPoint location =
          GeoPoint(pet.position.latitude, pet.position.longitude);
      GeoFirePoint center = GeoFirePoint(location);
      queryBuilder(Query<Object?> query) {
        return query.where('petClass', isEqualTo: pet);
      }

      GeoPoint geopointFrom(Object? data) {
        // Safely cast `data` to `Map<String, dynamic>` inside the function
        final mapData = data as Map<String, dynamic>;
        return mapData['geo']['geopoint'] as GeoPoint;
      }

      Stream stream = GeoCollectionReference(collectionReference)
          .subscribeWithinWithDistance(
              center: center,
              radiusInKm: pet.radius.toDouble(),
              field: 'location',
              strictMode: true,
              queryBuilder: queryBuilder,
              geopointFrom: geopointFrom);

      return stream.map((event) => Right<String, dynamic>(event));
    } catch (e) {
      return Stream.value(Left<String, dynamic>('Error: $e'));
    }
  }
}
