import 'package:geolocator/geolocator.dart';

class NearbyPetReq {
  Position position;
  String? pet;
  int radius;
  NearbyPetReq({required this.position, this.pet, required this.radius});
}
