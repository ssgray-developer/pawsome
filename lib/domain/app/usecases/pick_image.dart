import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawsome/domain/app/repository/app.dart';

import '../../../core/usecase/usecase.dart';
import '../../../core/utils/no_params.dart';

class PickImageUseCase implements UseCase<Either, NoParams> {
  final AppRepository appRepository;

  PickImageUseCase(this.appRepository);

  @override
  Future<Either<String, XFile>> call({NoParams? params}) async {
    return await appRepository.pickImage();
  }
}
