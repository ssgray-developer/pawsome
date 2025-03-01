import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/auth/models/user_sign_in_req.dart';
import '../entity/user.dart';

abstract class AuthRepository {
  Stream<User?> listenToAuthChanges();
  Future<Either> getUserDetails();
  Future<Either> signOut();
  Future<Either> signIn(UserSignInReq user);
  Future<Either> signInWithGoogle();
  Future<Either> signOutFromGoogle();
  Future<Either> signInWithFacebook();
  Future<Either> signOutFromFacebook();
  Future<Either> saveAuthProvider(String provider);
  Future<Either> getAuthProvider();
  Future<Either> sendPasswordResetEmail(String email);
  Future<Either> registerUser(UserEntity user);
}
