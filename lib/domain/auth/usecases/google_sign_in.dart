import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pawsome/core/utils/no_params.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/auth.dart';

class GoogleSignInUseCase implements UseCase<Either, NoParams> {
  final AuthRepository authRepository;

  GoogleSignInUseCase(this.authRepository);

  @override
  Future<Either> call({NoParams? params}) async {
    return await authRepository.signInWithGoogle();
  }
}
