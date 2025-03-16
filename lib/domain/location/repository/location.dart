import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

abstract class LocationRepository {
  Future<Either<String, GeoFirePoint>> getPosition();
  String getDistanceBetween(GeoPoint geoPoint);
}
