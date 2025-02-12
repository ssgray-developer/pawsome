import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../../data/auth/models/user_sign_in_req.dart';
import '../repository/auth.dart';

class SendPasswordResetEmailUseCase implements UseCase<Either, String> {
  final AuthRepository authRepository;

  SendPasswordResetEmailUseCase(this.authRepository);

  @override
  Future<Either> call({String? params}) async {
    return await authRepository.sendPasswordResetEmail(params!);
  }
}
