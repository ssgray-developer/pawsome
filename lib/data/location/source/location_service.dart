import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationService {
  Future<Either> getLocation();
}

class LocationServiceImpl extends LocationService {
  late bool serviceEnabled;
  late LocationPermission permission;

  @override
  Future<Either> getLocation() async {
    // Test if location services are enabled.
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

    Position position = await Geolocator.getCurrentPosition();
    return Right(position);
  }
}
