part of 'adoption_cubit.dart';

@immutable
abstract class AdoptionState {}

class AdoptionLoading extends AdoptionState {}

class AdoptionSuccess extends AdoptionState {
  final List<PetModel> pets;

  AdoptionSuccess(this.pets);
}

class AdoptionFailure extends AdoptionState {
  final String error;

  AdoptionFailure(this.error);
}
