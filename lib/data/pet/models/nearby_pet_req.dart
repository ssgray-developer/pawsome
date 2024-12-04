import 'package:geolocator/geolocator.dart';

class NearbyPetReq {
  Position position;
  String pet;
  int radius;
  NearbyPetReq(
      {required this.position, required this.pet, required this.radius});
}
