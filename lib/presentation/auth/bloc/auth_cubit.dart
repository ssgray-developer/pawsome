import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawsome/data/auth/models/user_sign_in_req.dart';
import 'package:pawsome/domain/auth/usecases/facebook_sign_in.dart';
import 'package:pawsome/domain/auth/usecases/facebook_sign_out.dart';
import 'package:pawsome/domain/auth/usecases/google_sign_in.dart';
import 'package:pawsome/domain/auth/usecases/google_sign_out.dart';
import 'package:pawsome/domain/auth/usecases/sign_in.dart';
import 'package:pawsome/domain/auth/usecases/sign_out.dart';
import '../../../domain/auth/usecases/listen_to_auth_changes.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ListenToAuthChangesUseCase listenToAuthChangesUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final GoogleSignOutUseCase googleSignOutUseCase;
  final FacebookSignInUseCase facebookSignInUseCase;
  final FacebookSignOutUseCase facebookSignOutUseCase;

  AuthCubit(
      this.listenToAuthChangesUseCase,
      this.signInUseCase,
      this.googleSignInUseCase,
      this.googleSignOutUseCase,
      this.signOutUseCase,
      this.facebookSignInUseCase,
      this.facebookSignOutUseCase)
      : super(AuthInitial()) {
    // listenToAuthChanges();
  }

  // Listen to auth state changes
  void listenToAuthChanges() {
    try {
      listenToAuthChangesUseCase().listen((event) {
        event.fold((message) => emit(AuthError(message)), (user) {
          if (user != null) {
            // Emit the authenticated state with the user
            emit(AuthAuthenticated());
          } else {
            // Emit unauthenticated state if no user
            emit(AuthUnauthenticated());
          }
        });
      });
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> signIn(UserSignInReq user) async {
    try {
      final result = await signInUseCase.call(params: user);

      result.fold(
        (message) => emit(AuthError(message)),
        (_) => emit(AuthAuthenticated()),
      );
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      final result = await signOutUseCase.call();

      result.fold((message) => emit(AuthError(message)),
          (_) => emit(AuthUnauthenticated()));
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      final result = await googleSignInUseCase.call();

      result.fold(
        (message) => emit(AuthUnauthenticated()),
        (_) {
          print('shit');
          emit(AuthAuthenticated());
        },
      );
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> signOutFromGoogle() async {
    try {
      emit(AuthLoading());
      final result = await googleSignOutUseCase.call();

      result.fold((message) => emit(AuthError(message)), (_) async {
        try {
          // Sign out from Firebase
          final result = await signOutUseCase.call();

          // Emit unauthenticated state once both Google and Firebase sign-out are successful
          emit(AuthUnauthenticated());
        } catch (e) {
          // Catch any errors that happen during Firebase sign-out
          emit(AuthError('Failed to sign out: ${e.toString()}'));
        }
      });
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      emit(AuthLoading());
      final result = await facebookSignInUseCase.call();

      result.fold(
        (message) => emit(AuthUnauthenticated()),
        (_) => emit(AuthAuthenticated()),
      );
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> signOutFromFacebook() async {
    try {
      emit(AuthLoading());
      final result = await facebookSignOutUseCase.call();

      result.fold((message) => emit(AuthError(message)), (_) async {
        try {
          // Sign out from Firebase
          final result = await signOutUseCase.call();

          // Emit unauthenticated state once both Google and Firebase sign-out are successful
          emit(AuthUnauthenticated());
        } catch (e) {
          // Catch any errors that happen during Firebase sign-out
          emit(AuthError('Failed to sign out: ${e.toString()}'));
        }
      });
    } catch (e) {
      emit(AuthError('An unknown error occurred: ${e.toString()}'));
    }
  }
}
