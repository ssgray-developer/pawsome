import 'package:connectivity_plus_platform_interface/src/enums.dart';
import 'package:dartz/dartz.dart';
import 'package:pawsome/domain/connectivity/repository/connectivity_repository.dart';

import '../../../service_locator.dart';
import '../source/connectiviy_service.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  @override
  Future<Either> checkConnectivity() async {
    return await sl<ConnectivityService>().checkConnectivity();
  }
}
