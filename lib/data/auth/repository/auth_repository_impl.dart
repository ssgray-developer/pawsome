import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawsome/data/auth/source/auth_local_data_source.dart';
import '../../../domain/auth/repository/auth.dart';
import '../models/user_sign_in_req.dart';
import '../source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource, this.authLocalDataSource);

  @override
  Future<Either> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Either> signOut() async {
    return await authRemoteDataSource.signOut();
  }

  @override
  Future<Either> signIn(UserSignInReq user) async {
    return await authRemoteDataSource.signIn(user);
  }

  @override
  Stream<User?> listenToAuthChanges() {
    return authRemoteDataSource.listenToAuthChanges();
  }

  @override
  Future<Either> signInWithGoogle() async {
    return await authRemoteDataSource.signInWithGoogle();
  }

  @override
  Future<Either> signOutFromGoogle() async {
    return await authRemoteDataSource.signOutFromGoogle();
  }

  @override
  Future<Either> signInWithFacebook() async {
    return await authRemoteDataSource.signInWithFacebook();
  }

  @override
  Future<Either> signOutFromFacebook() async {
    return await authRemoteDataSource.signOutFromFacebook();
  }

  @override
  Future<Either> getAuthProvider() async {
    return await authLocalDataSource.getAuthProvider();
  }

  @override
  Future<Either> saveAuthProvider(String provider) async {
    return await authLocalDataSource.saveAuthProvider(provider);
  }
}
