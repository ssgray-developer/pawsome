import 'package:dartz/dartz.dart';

abstract class AppRepository {
  Future<Either> remoteVersionCheck();
  Future<Either> localVersionCheck();
}
