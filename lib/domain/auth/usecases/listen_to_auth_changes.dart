import 'package:dartz/dartz.dart';
import 'package:pawsome/core/usecase/stream_usecase.dart';
import 'package:pawsome/core/utils/no_params.dart';
import '../repository/auth.dart';

class ListenToAuthChangesUseCase implements StreamUseCase<Either, NoParams> {
  final AuthRepository repository;

  ListenToAuthChangesUseCase(this.repository);

  @override
  Stream<Either> call({NoParams params = const NoParams()}) {
    return repository
        .listenToAuthChanges()
        .map(
          (user) => Right(user),
        )
        .handleError((error) {
      return Left(error.toString());
    });
  }
}
