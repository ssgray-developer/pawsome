import 'package:dartz/dartz.dart';
import 'package:pawsome/core/utils/no_params.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/auth.dart';

class SignOutUseCase implements UseCase<Either, NoParams> {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<Either> call({NoParams? params}) async {
    return await repository.signOut();
  }
}
