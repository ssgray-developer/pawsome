import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/auth/repository/auth.dart';
import '../models/user_sign_in_req.dart';
import '../source/auth_firebase_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseService authFirebaseService;

  AuthRepositoryImpl(this.authFirebaseService);

  @override
  Future<Either> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Either> signOut() async {
    return await authFirebaseService.signOut();
  }

  @override
  Future<Either> signIn(UserSignInReq user) async {
    return await authFirebaseService.signIn(user);
  }

  @override
  Stream<User?> listenToAuthChanges() {
    return authFirebaseService.listenToAuthChanges();
  }

  @override
  Future<Either> signInWithGoogle() async {
    return await authFirebaseService.signInWithGoogle();
  }

  @override
  Future<Either> signOutFromGoogle() async {
    return await authFirebaseService.signOutFromGoogle();
  }

  @override
  Future<Either> signInWithFacebook() async {
    return await authFirebaseService.signInWithFacebook();
  }

  @override
  Future<Either> signOutFromFacebook() async {
    return await authFirebaseService.signOutFromFacebook();
  }
}
