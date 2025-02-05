import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<Either> saveAuthProvider(String provider);
  Future<Either> getAuthProvider();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferencesAsync sharedPreferencesAsync;

  AuthLocalDataSourceImpl(this.sharedPreferencesAsync);

  @override
  Future<Either> saveAuthProvider(String provider) async {
    try {
      await sharedPreferencesAsync.setString('authProvider', provider);
      return const Right('Auth provider saved successfully.');
    } catch (e) {
      return const Left('Unable to save auth provider.');
    }
  }

  @override
  Future<Either> getAuthProvider() async {
    try {
      final result = await sharedPreferencesAsync.getString('authProvider');
      return Right(result);
    } catch (e) {
      return const Left('Unable to retrieve auth provider.');
    }
  }
}
