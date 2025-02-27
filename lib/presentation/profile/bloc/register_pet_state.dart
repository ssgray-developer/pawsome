part of 'register_pet_cubit.dart';

@immutable
abstract class RegisterPetState {}

class RegisterPetInitial extends RegisterPetState {}

class RegisterPetLoading extends RegisterPetState {}

class RegisterPetSuccessful extends RegisterPetState {
  final PetEntity pet;

  RegisterPetSuccessful(this.pet);
}

class RegisterPetError extends RegisterPetState {
  final String message;

  RegisterPetError(this.message);
}
