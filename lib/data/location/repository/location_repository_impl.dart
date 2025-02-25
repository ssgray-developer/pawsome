import 'package:dartz/dartz.dart';
import 'package:pawsome/data/location/source/location_remote_data_source.dart';
import 'package:pawsome/domain/location/repository/location.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;

  LocationRepositoryImpl(this.locationService);

  @override
  Future<Either> getPosition() async {
    return await locationService.getLocation();
  }
}
