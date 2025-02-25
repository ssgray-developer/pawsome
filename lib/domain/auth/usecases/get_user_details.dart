import 'package:dartz/dartz.dart';
import 'package:pawsome/core/utils/no_params.dart';
import 'package:pawsome/domain/auth/entity/user.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/auth.dart';

class GetUserDetailsUseCase implements UseCase<Either, NoParams> {
  final AuthRepository authRepository;

  GetUserDetailsUseCase(this.authRepository);

  @override
  Future<Either<String,UserEntity>> call({NoParams? params}) async {
    return await authRepository.getUserDetails();
  }
}
