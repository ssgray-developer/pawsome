part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthPasswordResetEmailSent extends AuthState {
  final String message;
  AuthPasswordResetEmailSent(this.message);
}

class AuthPasswordResetEmailError extends AuthState {
  final String message;
  AuthPasswordResetEmailError(this.message);
}
