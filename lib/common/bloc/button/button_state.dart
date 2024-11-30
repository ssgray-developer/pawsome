part of 'button_cubit.dart';

@immutable
abstract class ButtonState {}

class ButtonInitial extends ButtonState {}

class ButtonLoading extends ButtonState {}

class ButtonSuccess extends ButtonState {}

class ButtonFailure extends ButtonState {
  final String errorMessage;

  ButtonFailure({required this.errorMessage});
}
