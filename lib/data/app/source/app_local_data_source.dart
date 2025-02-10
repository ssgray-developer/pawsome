import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class AppLocalDataSource {
  Future<Either> versionCheck();
}

class AppLocalDataSourceImpl extends AppLocalDataSource {
  @override
  Future<Either> versionCheck() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;
      final buildVersion = packageInfo.buildNumber;
      return Right(appVersion);
    } catch (e) {
      return const Left('An unknown error has occurred.');
    }
  }
}
