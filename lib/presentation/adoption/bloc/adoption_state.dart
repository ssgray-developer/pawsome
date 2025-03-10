part of 'adoption_cubit.dart';

@immutable
abstract class AdoptionState {}

class AdoptionLoading extends AdoptionState {}

class AdoptionEmpty extends AdoptionState {}

class AdoptionSuccess extends AdoptionState {
  final List<PetEntity> petList;

  AdoptionSuccess(this.petList);
}

class AdoptionError extends AdoptionState {
  final String error;

  AdoptionError(this.error);
}
