import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/auth/models/user_sign_in_req.dart';
import '../../../service_locator.dart';
import '../repository/auth.dart';

class SignInUseCase implements UseCase<Either, UserSignInReq> {
  @override
  Future<Either> call({UserSignInReq? params}) async {
    return await sl<AuthRepository>().signIn(params!);
  }
}
