import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pawsome/data/auth/models/user.dart';
import '../models/user_sign_in_req.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> listenToAuthChanges();
  Future<Either> getUserDetails();
  Future<Either> signOut();
  Future<Either> signIn(UserSignInReq user);
  Future<Either> signInWithGoogle();
  Future<Either> signOutFromGoogle();
  Future<Either> signInWithFacebook();
  Future<Either> signOutFromFacebook();
  Future<Either> sendPasswordResetEmail(String email);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FacebookAuth facebookAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteDataSourceImpl(this.googleSignIn, this.firebaseAuth,
      this.facebookAuth, this.firebaseFirestore);

  @override
  Future<Either> getUserDetails() async {
    try {
      String userID = firebaseAuth.currentUser?.uid ?? '';
      if (userID.isEmpty) return const Left('User is not logged in.');
      DocumentSnapshot snapshot =
          await firebaseFirestore.collection('users').doc(userID).get();
      return Right(snapshot);
    } catch (e) {
      return const Left('An unknown error has occurred.');
    }
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
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await firebaseAuth.signInWithCredential(oAuthCredential);

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

  @override
  Future<Either> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right('Password reset email sent!');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message =
            'The email address you entered is invalid. Please check the format and try again.';
      } else if (e.code == 'missing-android-pkg-name') {
        message =
            'There seems to be an issue with the Android app setup. Please try again later.';
      } else if (e.code == 'missing-continue-uri') {
        message =
            'We couldn’t complete the password reset request. Please try again later.';
      } else if (e.code == 'missing-ios-bundle-id') {
        message =
            'There seems to be an issue with the iOS app setup. Please try again later.';
      } else if (e.code == 'invalid-continue-uri') {
        message =
            'There was an issue with the password reset link. Please request a new link or try again.';
      } else if (e.code == 'unauthorized-continue-uri') {
        message =
            'The link you followed is not authorized. Please try again or contact support.';
      } else if (e.code == 'user-not-found') {
        message =
            'No account found with this email. Please check your email or sign up.';
      } else {
        message = 'Error sending password reset email: ${e.message}';
      }
      return Left(message);
    }
  }
}
