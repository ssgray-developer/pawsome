import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawsome/data/pet/source/pet_remote_data_source.dart';

abstract class LocationService {
  Future<Either<String, GeoFirePoint>> getLocation();
  String getDistanceBetween(GeoPoint geoPoint);
}

class LocationServiceImpl extends LocationService {
  late bool serviceEnabled;
  late LocationPermission permission;
  late Position origin;
  final PetRemoteDataSource petRemoteDataSource;

  LocationServiceImpl(this.petRemoteDataSource);

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

      origin = await Geolocator.getCurrentPosition();

      final GeoFirePoint geoFirePoint =
          GeoFirePoint(GeoPoint(origin.latitude, origin.longitude));

      return Right(geoFirePoint);
    } catch (e) {
      return const Left('Unable to get location.');
    }
  }

  @override
  String getDistanceBetween(GeoPoint geoPoint) {
    try {
      final distance = Geolocator.distanceBetween(geoPoint.latitude,
              geoPoint.longitude, origin.latitude, origin.longitude) /
          1000;
      return distance.toStringAsFixed(1);
    } catch (e) {
      return '0';
    }
  }
}
