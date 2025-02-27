part of 'adoption_cubit.dart';

@immutable
abstract class AdoptionState {}

class AdoptionLoading extends AdoptionState {}

class AdoptionSuccess extends AdoptionState {
  final List<PetModel> pets;

  AdoptionSuccess(this.pets);
}

class AdoptionError extends AdoptionState {
  final String error;

  AdoptionError(this.error);
}
