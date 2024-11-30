import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repository/connectivity_repository.dart';

class CheckConnectivityUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<ConnectivityRepository>().checkConnectivity();
  }
}
