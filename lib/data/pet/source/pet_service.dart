import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../models/nearby_pet_req.dart';

abstract class PetService {
  Stream<Either> listenToPetAdoption(NearbyPetReq nearbyPet);
}

class PetServiceImpl extends PetService {
  final FirebaseFirestore firebaseFirestore;

  PetServiceImpl(this.firebaseFirestore);

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
}
