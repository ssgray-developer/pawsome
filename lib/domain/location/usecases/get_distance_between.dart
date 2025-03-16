import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawsome/domain/location/repository/location.dart';
import '../../../core/usecase/usecase.dart';

class GetDistanceBetweenUseCase implements UseCase<String, GeoPoint> {
  final LocationRepository locationRepository;

  GetDistanceBetweenUseCase(this.locationRepository);

  @override
  Future<String> call({GeoPoint? params}) async {
    return await locationRepository.getDistanceBetween(params!);
  }
}
