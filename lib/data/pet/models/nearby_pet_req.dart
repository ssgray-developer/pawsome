import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class NearbyPetReq {
  final GeoFirePoint position;
  final String? pet;
  final int radius;
  NearbyPetReq({required this.position, this.pet, required this.radius});
}
