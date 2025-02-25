part of 'register_pet_cubit.dart';

@immutable
abstract class RegisterPetState {}

class RegisterPetInitial extends RegisterPetState {}

class RegisterPetLoading extends RegisterPetState {}

class RegisterPetSuccessful extends RegisterPetState {}

class RegisterPetFailure extends RegisterPetState {
  final String message;

  RegisterPetFailure(this.message);
}
