import 'package:dartz/dartz.dart';
import 'package:pawsome/core/utils/no_params.dart';
import '../../../core/usecase/usecase.dart';
import '../../../data/auth/models/user_sign_in_req.dart';
import '../repository/auth.dart';

class GetUserDetailsUseCase implements UseCase<Either, NoParams> {
  final AuthRepository authRepository;

  GetUserDetailsUseCase(this.authRepository);

  @override
  Future<Either> call({NoParams? params}) async {
    return await authRepository.getUserDetails();
  }
}
