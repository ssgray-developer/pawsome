import 'package:dartz/dartz.dart';
import 'package:pawsome/core/utils/no_params.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/auth.dart';

class GoogleSignOutUseCase implements UseCase<Either, NoParams> {
  final AuthRepository authRepository;

  GoogleSignOutUseCase(this.authRepository);

  @override
  Future<Either> call({NoParams? params}) async {
    return await authRepository.signOutFromGoogle();
  }
}
