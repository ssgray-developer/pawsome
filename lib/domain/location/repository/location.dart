import 'package:dartz/dartz.dart';

abstract class LocationRepository {
  Future<Either> getPosition();
}
