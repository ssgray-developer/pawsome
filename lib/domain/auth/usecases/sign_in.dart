import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../../data/auth/models/user_sign_in_req.dart';
import '../repository/auth.dart';

class SignInUseCase implements UseCase<Either, UserSignInReq> {
  final AuthRepository authRepository;

  SignInUseCase(this.authRepository);

  @override
  Future<Either> call({UserSignInReq? params}) async {
    return await authRepository.signIn(params!);
  }
}
