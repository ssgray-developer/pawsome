import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawsome/core/utils/functions.dart';
import 'package:pawsome/data/auth/models/user_sign_in_req.dart';
import 'package:pawsome/domain/auth/entity/user.dart';
import 'package:pawsome/domain/auth/usecases/facebook_sign_in.dart';
import 'package:pawsome/domain/auth/usecases/facebook_sign_out.dart';
import 'package:pawsome/domain/auth/usecases/get_auth_provider.dart';
import 'package:pawsome/domain/auth/usecases/get_user_details.dart';
import 'package:pawsome/domain/auth/usecases/google_sign_in.dart';
import 'package:pawsome/domain/auth/usecases/google_sign_out.dart';
import 'package:pawsome/domain/auth/usecases/register_user.dart';
import 'package:pawsome/domain/auth/usecases/save_auth_provider.dart';
import 'package:pawsome/domain/auth/usecases/send_password_reset_email.dart';
import 'package:pawsome/domain/auth/usecases/sign_in.dart';
import 'package:pawsome/domain/auth/usecases/sign_out.dart';
import '../../../core/utils/failure.dart';
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
  final RegisterUserUseCase registerUserUseCase;

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
      this.getUserDetailsUseCase,
      this.registerUserUseCase)
      : super(AuthInitial());

  // Listen to auth state changes
  void listenToAuthChanges() {
    try {
      listenToAuthChangesUseCase().listen((user) async {
        if (user != null) {
          await getUserDetails(user);
        } else {
          emit(AuthUnauthenticated());
        }
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
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      final googleResult = await googleSignInUseCase.call();

      googleResult.fold(
        (message) async {
          emit(AuthError(message));
        },
        (_) async {
          await saveAuthProviderUseCase.call(params: 'google');
        },
      );
    } catch (e) {
      emit(AuthError('An error occurred'));
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

  Future<void> getUserDetails(User user) async {
    if (!isClosed) emit(AuthLoading());
    try {
      final result = await getUserDetailsUseCase.call();
      result.fold(
        (error) async {
          if (error is Failure) {
            emit(AuthError(error.message));
          } else {
            registerUserData(user);
          }
        },
        (retrievedUser) => emit(AuthAuthenticated(retrievedUser)),
      );
    } catch (e) {
      if (!isClosed) emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> registerUserData(User user) async {
    final newUser = UserEntity(
        email: user.email!,
        uid: user.uid,
        chatId: [],
        username: getNameFromEmail(user.email!),
        petList: [],
        isSuspended: false);

    final registrationResult = await registerUserUseCase.call(params: newUser);
    registrationResult.fold((message) => emit(AuthError(message)), (_) => ());
  }

  // Future<bool> checkIfUserDataExists() async {
  //   try {
  //     final result = await getUserDetailsUseCase.call();
  //     return result.fold(
  //       (error) {
  //         if (error is Failure) {
  //           return false;
  //         }
  //         return true;
  //       },
  //       (_) => true,
  //     );
  //   } catch (e) {
  //     return false;
  //   }
  // }

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
