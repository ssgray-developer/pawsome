import 'package:dartz/dartz.dart';
import 'package:pawsome/domain/app/repository/app.dart';
import '../../../core/usecase/usecase.dart';

class LoadTranslationsUseCase implements UseCase<Either, String> {
  final AppRepository appRepository;

  LoadTranslationsUseCase(this.appRepository);

  @override
  Future<Either> call({String? params}) async {
    return await appRepository.loadTranslations(params!);
  }
}
