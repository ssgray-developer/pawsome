import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:pawsome/data/pet/models/nearby_pet_req.dart';
import 'package:pawsome/domain/location/usecases/get_location.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';
import 'package:pawsome/domain/pet/usecases/listen_to_pet_adoption.dart';
import 'package:pawsome/data/pet/models/pet_model.dart';
import 'package:flutter/material.dart';
part 'adoption_state.dart';

class AdoptionCubit extends Cubit<AdoptionState> {
  final ListenToPetAdoptionUseCase listenToPetAdoptionUseCase;
  final GetLocationUseCase getLocationUseCase;

  // Internal stream controller for holding the message stream
  late Stream<List<PetEntity>> petStream = const Stream.empty();
  int distance = 5;
  late GeoFirePoint position;

  AdoptionCubit(this.listenToPetAdoptionUseCase, this.getLocationUseCase)
      : super(AdoptionLoading());

  Future<void> adoptionStream() async {
    // Emit loading state first
    emit(AdoptionLoading());

    // Fetch the current location
    final locationResult = await updateLocation();

    locationResult.fold(
      (failure) {
        // If location fetching fails, emit the failure state
        if (!isClosed) emit(AdoptionError(failure));
      },
      (newPosition) {
        // If location fetch is successful, update the position

        // Now start listening to pet adoption stream
        petStream = listenToPetAdoptionUseCase(
                params: NearbyPetReq(position: position, radius: distance))
            .map((either) {
          return either.fold(
            (failure) {
              if (!isClosed) emit(AdoptionError(failure));
              return [];
            },
            (registeredPets) {
              if (registeredPets.isEmpty) {
                return [];
              }
              return registeredPets;
            },
          );
        });

        // Optionally emit success with initial empty list if you want to show
        // initial loading before stream starts emitting results
        if (!isClosed) emit(AdoptionLoading());
      },
    );
  }

  Future<Either<String, GeoFirePoint>> updateLocation() async {
    final result = await getLocationUseCase.call();
    return result.fold(
      (failure) => Left(failure),
      (position) {
        this.position = position;
        return Right(position);
      },
    );
  }

  @override
  Future<void> close() {
    // Close the stream properly and perform any necessary cleanup
    petStream = const Stream.empty();
    return super.close();
  }
}
