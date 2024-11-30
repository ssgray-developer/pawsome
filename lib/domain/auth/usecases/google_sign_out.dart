import 'package:dartz/dartz.dart';
import 'package:pawsome/core/utils/no_params.dart';
import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repository/auth.dart';

class GoogleSignOutUseCase implements UseCase<Either, NoParams> {
  @override
  Future<Either> call({NoParams? params}) async {
    return await sl<AuthRepository>().signOutFromGoogle();
  }
}
