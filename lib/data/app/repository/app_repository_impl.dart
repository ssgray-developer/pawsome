import 'package:dartz/dartz.dart';
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
}
