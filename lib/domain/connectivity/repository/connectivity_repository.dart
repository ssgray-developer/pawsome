import 'package:dartz/dartz.dart';

abstract class ConnectivityRepository {
  Future<Either> checkConnectivity();
}
