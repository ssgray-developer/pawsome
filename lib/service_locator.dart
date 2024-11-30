import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pawsome/data/auth/source/auth_firebase_service.dart';
import 'package:pawsome/domain/auth/usecases/listen_to_auth_changes.dart';
import 'package:pawsome/presentation/auth/bloc/auth_cubit.dart';
import 'package:pawsome/presentation/bloc/connectivity_cubit.dart';
import 'data/auth/repository/auth_repository_impl.dart';
import 'data/connectivity/repository/connectivity_repository_impl.dart';
import 'domain/auth/repository/auth.dart';
import 'domain/auth/usecases/facebook_sign_in.dart';
import 'domain/auth/usecases/facebook_sign_out.dart';
import 'domain/auth/usecases/google_sign_in.dart';
import 'domain/auth/usecases/google_sign_out.dart';
import 'domain/auth/usecases/sign_in.dart';
import 'domain/auth/usecases/sign_out.dart';
import 'domain/connectivity/repository/connectivity_repository.dart';
import 'domain/connectivity/usecase/check_connectivity.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Repository

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<ConnectivityRepository>(ConnectivityRepositoryImpl());

  // Cubit
  sl.registerFactory<AuthCubit>(
      () => AuthCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => ConnectivityCubit());

  // Usecases
  sl.registerLazySingleton<ListenToAuthChangesUseCase>(
      () => ListenToAuthChangesUseCase(sl()));
  sl.registerLazySingleton<SignInUseCase>(() => SignInUseCase());
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(sl()));
  sl.registerLazySingleton<CheckConnectivityUseCase>(
      () => CheckConnectivityUseCase());
  sl.registerLazySingleton<GoogleSignInUseCase>(() => GoogleSignInUseCase());
  sl.registerLazySingleton<GoogleSignOutUseCase>(() => GoogleSignOutUseCase());
  sl.registerLazySingleton<FacebookSignInUseCase>(
      () => FacebookSignInUseCase());
  sl.registerLazySingleton<FacebookSignOutUseCase>(
      () => FacebookSignOutUseCase());

  //Data Sources
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // External
  sl.registerSingleton<AuthFirebaseService>(
      AuthFirebaseServiceImpl(sl(), sl(), sl()));
}
