import 'package:geolocator/geolocator.dart';

class NearbyPetReq {
  final Position position;
  final String? pet;
  final int radius;
  NearbyPetReq({required this.position, this.pet, required this.radius});
}
