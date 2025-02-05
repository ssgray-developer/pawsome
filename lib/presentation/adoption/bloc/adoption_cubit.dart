import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawsome/data/pet/models/nearby_pet_req.dart';
import 'package:pawsome/domain/location/usecases/get_location.dart';
import 'package:pawsome/domain/pet/usecases/listen_to_pet_adoption.dart';
import 'package:pawsome/data/pet/models/registered_pet_model.dart';
import 'package:flutter/material.dart';
part 'adoption_state.dart';

class AdoptionCubit extends Cubit<AdoptionState> {
  final ListenToPetAdoptionUseCase listenToPetAdoptionUseCase;
  final GetLocationUseCase getLocationUseCase;

  // Internal stream controller for holding the message stream
  late Stream<List<RegisteredPetModel>> petStream = const Stream.empty();
  int distance = 5;
  late Position position;

  AdoptionCubit(this.listenToPetAdoptionUseCase, this.getLocationUseCase)
      : super(AdoptionLoading()) {
    _initializeLocationAndStream();
  }

  Future<void> _initializeLocationAndStream() async {
    // Emit loading state first
    emit(AdoptionLoading());

    // Fetch the current location
    final locationResult = await updateLocation();

    locationResult.fold(
      (failure) {
        // If location fetching fails, emit the failure state
        emit(AdoptionFailure(failure));
      },
      (newPosition) {
        // If location fetch is successful, update the position
        position = newPosition;

        // Now start listening to pet adoption stream
        petStream = listenToPetAdoptionUseCase(
                params: NearbyPetReq(position: position, radius: distance))
            .map((either) {
          return either.fold(
            (failure) {
              // Handle the failure case (you can return an empty list or other handling logic)
              emit(AdoptionFailure(failure));
              return [];
            },
            (registeredPets) {
              // Transform the successful response into a list of RegisteredPetViewModel
              if (registeredPets.isEmpty) {
                return [];
              }
              return registeredPets
                  .map((pets) => RegisteredPetModel.fromJson(
                      pets)) // Mapping each pet data
                  .toList();
            },
          );
        });

        // Optionally emit success with initial empty list if you want to show
        // initial loading before stream starts emitting results
        emit(AdoptionLoading());
      },
    );
  }

  Future<Either<String, Position>> updateLocation() async {
    final result = await getLocationUseCase.call();
    return result.fold(
      (failure) => Left(failure),
      (position) {
        this.position = position;
        return Right(position);
      },
    );
  }

  // Expose the stream to the UI
  // Stream<List<RegisteredPetViewModel>> get petStream => _petStream;
}
