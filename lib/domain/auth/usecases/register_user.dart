import 'package:dartz/dartz.dart';
import 'package:pawsome/domain/auth/entity/user.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/auth.dart';

class RegisterUserUseCase implements UseCase<Either, UserEntity> {
  final AuthRepository authRepository;

  RegisterUserUseCase(this.authRepository);

  @override
  Future<Either> call({UserEntity? params}) async {
    return await authRepository.registerUser(params!);
  }
}
