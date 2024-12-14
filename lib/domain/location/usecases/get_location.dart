import 'package:dartz/dartz.dart';
import 'package:pawsome/core/utils/no_params.dart';
import 'package:pawsome/domain/location/repository/location.dart';
import '../../../core/usecase/usecase.dart';

class GetLocationUseCase implements UseCase<Either, NoParams> {
  final LocationRepository locationRepository;

  GetLocationUseCase(this.locationRepository);

  @override
  Future<Either> call({NoParams? params}) async {
    return await locationRepository.getPosition();
  }
}
