import 'package:dartz/dartz.dart';
import 'package:pawsome/domain/app/repository/app.dart';

import '../../../core/usecase/usecase.dart';
import '../../../core/utils/no_params.dart';

class RetrieveLostDataUseCase implements UseCase<Either, NoParams> {
  final AppRepository appRepository;

  RetrieveLostDataUseCase(this.appRepository);

  @override
  Future<Either> call({NoParams? params}) async {
    return await appRepository.retrieveLostData();
  }
}
