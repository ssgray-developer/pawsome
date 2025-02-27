import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationService {
  Future<Either<String, GeoFirePoint>> getLocation();
}

class LocationServiceImpl extends LocationService {
  late bool serviceEnabled;
  late LocationPermission permission;

  @override
  Future<Either<String, GeoFirePoint>> getLocation() async {
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left('Location services ara disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left('Location permissions ara denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      final position = await Geolocator.getCurrentPosition();

      final GeoFirePoint geoFirePoint =
          GeoFirePoint(GeoPoint(position.latitude, position.longitude));

      return Right(geoFirePoint);
    } catch (e) {
      return const Left('Unable to get location.');
    }
  }
}
