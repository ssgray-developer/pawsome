import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawsome/data/auth/models/user_sign_in_req.dart';
import 'package:pawsome/domain/auth/entity/user.dart';
import 'package:pawsome/domain/auth/usecases/facebook_sign_in.dart';
import 'package:pawsome/domain/auth/usecases/facebook_sign_out.dart';
import 'package:pawsome/domain/auth/usecases/get_auth_provider.dart';
import 'package:pawsome/domain/auth/usecases/get_user_details.dart';
import 'package:pawsome/domain/auth/usecases/google_sign_in.dart';
import 'package:pawsome/domain/auth/usecases/google_sign_out.dart';
import 'package:pawsome/domain/auth/usecases/save_auth_provider.dart';
import 'package:pawsome/domain/auth/usecases/send_password_reset_email.dart';
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
  final SaveAuthProviderUseCase saveAuthProviderUseCase;
  final GetAuthProviderUseCase getAuthProviderUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  final GetUserDetailsUseCase getUserDetailsUseCase;

  AuthCubit(
      this.listenToAuthChangesUseCase,
      this.signInUseCase,
      this.googleSignInUseCase,
      this.googleSignOutUseCase,
      this.signOutUseCase,
      this.facebookSignInUseCase,
      this.facebookSignOutUseCase,
      this.saveAuthProviderUseCase,
      this.getAuthProviderUseCase,
      this.sendPasswordResetEmailUseCase,
      this.getUserDetailsUseCase)
      : super(AuthInitial()) {
    // listenToAuthChanges();
  }

  // Listen to auth state changes
  void listenToAuthChanges() {
    try {
      listenToAuthChangesUseCase().listen((event) {
        event.fold((message) => emit(AuthError(message)), (user) async {
          if (user != null) {
            await getUserDetails();
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
        (_) {
          saveAuthProviderUseCase.call(params: 'firebase');
          // emit(AuthAuthenticated());
        },
      );
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> signOut() async {
    try {
      final currentState = state;
      if (currentState is AuthAuthenticated) {
        final authProvider = await getAuthProviderUseCase.call();
        authProvider.fold((message) {}, (result) async {
          switch (result) {
            case 'google':
              // Perform Google sign-out
              await signOutUseCase.call();
              final result = await googleSignOutUseCase.call();
              result.fold((message) => emit(AuthError(message)), (_) async {});
            // break;
            case 'facebook':
              // Perform Facebook sign-out
              await signOutUseCase.call();
              final result = await facebookSignOutUseCase.call();
              result.fold((message) => emit(AuthError(message)), (_) async {});
            // break;
            case 'firebase':
              // Perform Firebase sign-out
              final result = await signOutUseCase.call();
              result.fold((message) => emit(AuthError(message)), (_) async {});
            // break;
            // case AuthProvider.apple:
            // // Perform Apple sign-out
            //   await SignInWithApple.getInstance().signOut();
            //   break;
            default:
              break;
          }
        });
      }
      // emit(AuthUnauthenticated());
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
        (_) async {
          await saveAuthProviderUseCase.call(params: 'google');
          // emit(AuthAuthenticated());
        },
      );
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
        (_) {
          saveAuthProviderUseCase.call(params: 'facebook');
          // emit(AuthAuthenticated());
        },
      );
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final result = await sendPasswordResetEmailUseCase.call(params: email);

      result.fold(
        (message) => emit(AuthPasswordResetEmailError(message)),
        (message) => emit(AuthPasswordResetEmailSent(message)),
      );
    } catch (e) {
      emit(AuthPasswordResetEmailError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> getUserDetails() async {
    emit(AuthLoading());
    try {
      final result = await getUserDetailsUseCase.call();

      result.fold(
        (message) => emit(AuthError(message)),
        (user) => emit(AuthAuthenticated(user)),
      );
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

// Future<void> signOutFromGoogle() async {
//   try {
//     emit(AuthLoading());
//     final result = await googleSignOutUseCase.call();
//
//     result.fold((message) => emit(AuthError(message)), (_) async {
//       try {
//         // Sign out from Firebase
//         final result = await signOutUseCase.call();
//
//         // Emit unauthenticated state once both Google and Firebase sign-out are successful
//         emit(AuthUnauthenticated());
//       } catch (e) {
//         // Catch any errors that happen during Firebase sign-out
//         emit(AuthError('Failed to sign out: ${e.toString()}'));
//       }
//     });
//   } catch (e) {
//     emit(AuthError('An error occurred: ${e.toString()}'));
//   }
// }

  // Future<void> signOutFromFacebook() async {
  //   try {
  //     emit(AuthLoading());
  //     final result = await facebookSignOutUseCase.call();
  //
  //     result.fold((message) => emit(AuthError(message)), (_) async {
  //       try {
  //         // Sign out from Firebase
  //         final result = await signOutUseCase.call();
  //
  //         // Emit unauthenticated state once both Google and Firebase sign-out are successful
  //         emit(AuthUnauthenticated());
  //       } catch (e) {
  //         // Catch any errors that happen during Firebase sign-out
  //         emit(AuthError('Failed to sign out: ${e.toString()}'));
  //       }
  //     });
  //   } catch (e) {
  //     emit(AuthError('An unknown error occurred: ${e.toString()}'));
  //   }
  // }
}
