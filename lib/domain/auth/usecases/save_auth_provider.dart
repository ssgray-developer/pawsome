import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/auth.dart';

class SaveAuthProviderUseCase implements UseCase<Either, String> {
  final AuthRepository authRepository;

  SaveAuthProviderUseCase(this.authRepository);

  @override
  Future<Either> call({String? params}) async {
    return await authRepository.saveAuthProvider(params!);
  }
}