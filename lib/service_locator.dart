import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pawsome/app/app_update_cubit.dart';
import 'package:pawsome/data/app/source/app_local_data_source.dart';
import 'package:pawsome/data/auth/source/auth_local_data_source.dart';
import 'package:pawsome/data/auth/source/auth_remote_data_source.dart';
import 'package:pawsome/data/location/repository/location_repository_impl.dart';
import 'package:pawsome/data/location/source/location_service.dart';
import 'package:pawsome/data/pet/repository/pet_repository_impl.dart';
import 'package:pawsome/data/pet/source/pet_service.dart';
import 'package:pawsome/domain/app/repository/app.dart';
import 'package:pawsome/domain/app/usecases/remote_version_check.dart';
import 'package:pawsome/domain/auth/usecases/get_auth_provider.dart';
import 'package:pawsome/domain/auth/usecases/listen_to_auth_changes.dart';
import 'package:pawsome/domain/auth/usecases/send_password_reset_email.dart';
import 'package:pawsome/domain/auth/usecases/save_auth_provider.dart';
import 'package:pawsome/domain/location/repository/location.dart';
import 'package:pawsome/domain/location/usecases/get_location.dart';
import 'package:pawsome/domain/pet/repository/pet.dart';
import 'package:pawsome/domain/pet/usecases/listen_to_pet_adoption.dart';
import 'package:pawsome/presentation/adoption/bloc/adoption_cubit.dart';
import 'package:pawsome/presentation/adoption/bloc/pet_list_view_selection_cubit.dart';
import 'package:pawsome/presentation/auth/bloc/auth_cubit.dart';
import 'package:pawsome/presentation/bloc/connectivity_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/app/repository/app_repository_impl.dart';
import 'data/app/source/app_remote_data_source.dart';
import 'data/auth/repository/auth_repository_impl.dart';
import 'data/connectivity/repository/connectivity_repository_impl.dart';
import 'domain/app/usecases/local_version_check.dart';
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
  //Data Sources
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);
  sl.registerLazySingleton<SharedPreferencesAsync>(
      () => SharedPreferencesAsync());
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // External
  sl.registerSingleton<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(sl(), sl(), sl()));
  sl.registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl(sl()));
  sl.registerSingleton<PetService>(PetServiceImpl(sl()));
  sl.registerSingleton<LocationService>(LocationServiceImpl());
  sl.registerSingleton<AppLocalDataSource>(AppLocalDataSourceImpl());
  sl.registerSingleton<AppRemoteDataSource>(AppRemoteDataSourceImpl(sl()));

  // Repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()));
  sl.registerSingleton<ConnectivityRepository>(ConnectivityRepositoryImpl());
  sl.registerSingleton<PetRepository>(PetRepositoryImpl(sl()));
  sl.registerSingleton<LocationRepository>(LocationRepositoryImpl(sl()));
  sl.registerSingleton<AppRepository>(AppRepositoryImpl(sl(), sl()));

  // Cubit
  sl.registerFactory<AuthCubit>(() =>
      AuthCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => ConnectivityCubit());
  sl.registerFactory(() => PetListViewSelectionCubit());
  sl.registerFactory(() => AdoptionCubit(sl(), sl()));
  sl.registerFactory(() => AppUpdateCubit(sl(), sl()));

  // Usecases
  sl.registerLazySingleton<ListenToAuthChangesUseCase>(
      () => ListenToAuthChangesUseCase(sl()));
  sl.registerLazySingleton<SignInUseCase>(() => SignInUseCase(sl()));
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(sl()));
  sl.registerLazySingleton<CheckConnectivityUseCase>(
      () => CheckConnectivityUseCase());
  sl.registerLazySingleton<GoogleSignInUseCase>(
      () => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton<GoogleSignOutUseCase>(
      () => GoogleSignOutUseCase(sl()));
  sl.registerLazySingleton<FacebookSignInUseCase>(
      () => FacebookSignInUseCase(sl()));
  sl.registerLazySingleton<FacebookSignOutUseCase>(
      () => FacebookSignOutUseCase(sl()));
  sl.registerLazySingleton<ListenToPetAdoptionUseCase>(
      () => ListenToPetAdoptionUseCase(sl()));
  sl.registerLazySingleton<GetLocationUseCase>(() => GetLocationUseCase(sl()));
  sl.registerLazySingleton<SaveAuthProviderUseCase>(
      () => SaveAuthProviderUseCase(sl()));
  sl.registerLazySingleton<GetAuthProviderUseCase>(
      () => GetAuthProviderUseCase(sl()));
  sl.registerLazySingleton<RemoteVersionCheckUseCase>(
      () => RemoteVersionCheckUseCase(sl()));
  sl.registerLazySingleton<LocalVersionCheckUseCase>(
      () => LocalVersionCheckUseCase(sl()));
  sl.registerLazySingleton<SendPasswordResetEmailUseCase>(
      () => SendPasswordResetEmailUseCase(sl()));
}
