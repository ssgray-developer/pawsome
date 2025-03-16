import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:pawsome/data/location/source/location_remote_data_source.dart';
import 'package:pawsome/domain/location/repository/location.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;

  LocationRepositoryImpl(this.locationService);

  @override
  Future<Either<String, GeoFirePoint>> getPosition() async {
    return await locationService.getLocation();
  }

  @override
  String getDistanceBetween(GeoPoint geoPoint) {
    return locationService.getDistanceBetween(geoPoint);
  }
}
