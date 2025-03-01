import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawsome/core/usecase/stream_usecase.dart';
import 'package:pawsome/core/utils/no_params.dart';
import '../repository/auth.dart';

class ListenToAuthChangesUseCase implements StreamUseCase<User?, NoParams> {
  final AuthRepository authRepository;

  ListenToAuthChangesUseCase(this.authRepository);

  @override
  Stream<User?> call({NoParams params = const NoParams()}) {
    return authRepository.listenToAuthChanges().map((user) => user);
  }
}
