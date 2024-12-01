import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_sign_in_req.dart';

abstract class AuthFirebaseService {
  Stream<User?> listenToAuthChanges();
  Future<Either> getUser();
  Future<Either> signOut();
  Future<Either> signIn(UserSignInReq user);
  Future<Either> signInWithGoogle();
  Future<Either> signOutFromGoogle();
  Future<Either> signInWithFacebook();
  Future<Either> signOutFromFacebook();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FacebookAuth facebookAuth;

  AuthFirebaseServiceImpl(
      this.googleSignIn, this.firebaseAuth, this.facebookAuth);

  @override
  Future<Either> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Either> signOut() async {
    try {
      await firebaseAuth.signOut();
      return const Right('Sign out successfully.');
    } catch (e) {
      return const Left('An unknown error has occurred.');
    }
  }

  @override
  Future<Either> signIn(UserSignInReq user) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      return const Right('Sign in was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'Invalid email.';
      } else if (e.code == 'user-disabled') {
        message = 'User account is disabled.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password.';
      } else if (e.code == 'user-token-expired') {
        message = 'User session is expired.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'user-disabled') {
        message = 'User account is disabled.';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many attempts. Try again later.';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Email/password sign-in is not enabled.';
      } else {
        message = 'An unknown error occurred: ${e.message}';
      }
      return Left(message);
    }
  }

  @override
  Stream<User?> listenToAuthChanges() {
    return firebaseAuth.authStateChanges();
  }

  @override
  Future<Either> signInWithGoogle() async {
    try {
      print('shit1');
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      print('shit2');

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      print('shit3');

      OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      print('shit4');

      await firebaseAuth.signInWithCredential(oAuthCredential);

      print('shit5');
      return Right(googleSignInAccount);
    } catch (e) {
      return const Left('Google sign in failure');
    }
  }

  @override
  Future<Either> signOutFromGoogle() async {
    try {

      await googleSignIn.signOut();
      return const Right('Google sign out successful');

    } catch (e) {
      return const Left('Google sign out failure');
    }
  }

  @override
  Future<Either> signInWithFacebook() async {
    try {
      LoginResult loginResult =
          await facebookAuth.login(permissions: ["public_profile", "email"]);

      if (loginResult.status == LoginStatus.success) {
        Map userData = await facebookAuth.getUserData();
        return Right(userData);
      } else if (loginResult.status == LoginStatus.cancelled) {
        return const Left('Facebook login has been cancelled');
      } else if (loginResult.status == LoginStatus.cancelled) {
        return const Left('Facebook login has been cancelled');
      } else if (loginResult.status == LoginStatus.operationInProgress) {
        return const Left('Logging in with Facebook');
      } else {
        return const Left('Facebook login has failed');
      }
    } catch (e) {
      return const Left('An unknown error has occurred');
    }
  }

  @override
  Future<Either> signOutFromFacebook() async {
    try {
      await facebookAuth.logOut();
      return const Right('Facebook sign out successfully.');
    } catch (e) {
      return const Left('An unknown error has occurred.');
    }
  }
}
