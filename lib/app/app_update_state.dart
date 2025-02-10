part of 'app_update_cubit.dart';

@immutable
abstract class AppUpdateState {}

class AppUpdateInitial extends AppUpdateState {}

class AppUpdateLoading extends AppUpdateState {}

class AppUpdateAvailable extends AppUpdateState {}

class AppUpdateNotRequired extends AppUpdateState {}

class AppUpdateError extends AppUpdateState {
  final String message;
  AppUpdateError(this.message);
}
