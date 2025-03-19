import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class NearbyPetReq {
  final GeoFirePoint position;
  final String? petClass;
  final String? petSpecies;
  final int radius;
  NearbyPetReq(
      {required this.position,
      this.petClass,
      this.petSpecies,
      required this.radius});
}
