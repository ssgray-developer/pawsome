import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class AppRepository {
  Future<Either> remoteVersionCheck();
  Future<Either> localVersionCheck();
  Future<Either<String, XFile>> pickImage();
  Future<Either> retrieveLostData();
  Future<Either> cropImage(String imagePath);
}
