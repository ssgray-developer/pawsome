part of 'connectivity_cubit.dart';

@immutable
abstract class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityLoading extends ConnectivityState {}

class ConnectivityFailure extends ConnectivityState {
  final String errorMessage;
  ConnectivityFailure(this.errorMessage);
}

class ConnectivitySuccess extends ConnectivityState {}
