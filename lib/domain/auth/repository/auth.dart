import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/auth/models/user_sign_in_req.dart';

abstract class AuthRepository {
  Stream<User?> listenToAuthChanges();
  Future<Either> getUser();
  Future<Either> signOut();
  Future<Either> signIn(UserSignInReq user);
  Future<Either> signInWithGoogle();
  Future<Either> signOutFromGoogle();
  Future<Either> signInWithFacebook();
  Future<Either> signOutFromFacebook();
  Future<Either> saveAuthProvider(String provider);
  Future<Either> getAuthProvider();
}
