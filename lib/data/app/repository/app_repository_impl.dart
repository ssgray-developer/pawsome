import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawsome/domain/app/repository/app.dart';
import '../source/app_local_data_source.dart';
import '../source/app_remote_data_source.dart';

class AppRepositoryImpl implements AppRepository {
  final AppRemoteDataSource appRemoteDataSource;
  final AppLocalDataSource appLocalDataSource;
  AppRepositoryImpl(this.appRemoteDataSource, this.appLocalDataSource);

  @override
  Future<Either> remoteVersionCheck() async {
    return await appRemoteDataSource.versionCheck();
  }

  @override
  Future<Either> localVersionCheck() async {
    return await appLocalDataSource.versionCheck();
  }

  @override
  Future<Either<String, XFile>> pickImage() async {
    return await appLocalDataSource.pickImage();
  }

  @override
  Future<Either> retrieveLostData() async {
    return await appLocalDataSource.retrieveLostData();
  }

  @override
  Future<Either> cropImage(String imagePath) async {
    return await appLocalDataSource.cropImage(imagePath);
  }
}
