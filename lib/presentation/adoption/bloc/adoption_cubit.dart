import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:pawsome/data/pet/models/nearby_pet_req.dart';
import 'package:pawsome/domain/location/usecases/get_location.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';
import 'package:pawsome/domain/pet/usecases/listen_to_pet_adoption.dart';
import 'package:flutter/material.dart';
part 'adoption_state.dart';

class AdoptionCubit extends Cubit<AdoptionState> {
  final ListenToPetAdoptionUseCase listenToPetAdoptionUseCase;
  final GetLocationUseCase getLocationUseCase;

  // Internal stream controller for holding the message stream
  // late Stream<List<PetEntity>> petStream = const Stream.empty();
  int distance = 20;
  late GeoFirePoint position;
  String? pet = 'Dog';

  AdoptionCubit(this.listenToPetAdoptionUseCase, this.getLocationUseCase)
      : super(AdoptionLoading());

  Future<void> adoptionStream() async {
    final locationResult = await updateLocation();

    locationResult.fold(
      (failure) {
        if (!isClosed) emit(AdoptionError(failure));
      },
      (_) {
        listenToPetAdoptionUseCase(
                params: NearbyPetReq(
                    position: position, radius: distance, pet: pet))
            .listen((data) {
          if (data.isEmpty) {
            emit(AdoptionLoading());
          } else {
            emit(AdoptionSuccess(data));
          }
        });
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

  // @override
  // Future<void> close() {
  //   // Close the stream properly and perform any necessary cleanup
  //   petStream = const Stream.empty();
  //   return super.close();
  // }
}
