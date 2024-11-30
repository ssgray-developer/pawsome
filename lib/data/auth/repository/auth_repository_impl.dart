import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/auth/repository/auth.dart';
import '../../../service_locator.dart';
import '../models/user_sign_in_req.dart';
import '../source/auth_firebase_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Either> signOut() async {
    return await sl<AuthFirebaseService>().signOut();
  }

  @override
  Future<Either> signIn(UserSignInReq user) async {
    return await sl<AuthFirebaseService>().signIn(user);
  }

  @override
  Stream<User?> listenToAuthChanges() {
    return sl<AuthFirebaseService>().listenToAuthChanges();
  }

  @override
  Future<Either> signInWithGoogle() async {
    return await sl<AuthFirebaseService>().signInWithGoogle();
  }

  @override
  Future<Either> signOutFromGoogle() async {
    return await sl<AuthFirebaseService>().signOutFromGoogle();
  }

  @override
  Future<Either> signInWithFacebook() async {
    return await sl<AuthFirebaseService>().signInWithFacebook();
  }

  @override
  Future<Either> signOutFromFacebook() async {
    return await sl<AuthFirebaseService>().signOutFromFacebook();
  }
}
