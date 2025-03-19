import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:pawsome/data/pet/models/like_adoption_req.dart';
import 'package:pawsome/data/pet/models/nearby_pet_req.dart';
import 'package:pawsome/domain/location/usecases/get_distance_between.dart';
import 'package:pawsome/domain/location/usecases/get_location.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';
import 'package:pawsome/domain/pet/usecases/like_adoption_post.dart';
import 'package:pawsome/domain/pet/usecases/listen_to_pet_adoption.dart';
import 'package:flutter/material.dart';
part 'adoption_state.dart';

class AdoptionCubit extends Cubit<AdoptionState> {
  final ListenToPetAdoptionUseCase listenToPetAdoptionUseCase;
  final GetLocationUseCase getLocationUseCase;
  final GetDistanceBetweenUseCase getDistanceBetweenUseCase;
  final LikeAdoptionPostUseCase likeAdoptionPostUseCase;

  int distance = 5;
  late GeoFirePoint position;
  String? pet;
  String? petSpecies;
  StreamSubscription? subscription;

  AdoptionCubit(this.listenToPetAdoptionUseCase, this.getLocationUseCase,
      this.getDistanceBetweenUseCase, this.likeAdoptionPostUseCase)
      : super(AdoptionLoading());

  Future<void> adoptionStream() async {
    subscription?.cancel();

    final locationResult = await updateLocation();

    locationResult.fold(
      (failure) {
        if (!isClosed) emit(AdoptionError(failure));
      },
      (_) {
        subscription = listenToPetAdoptionUseCase(
                params: NearbyPetReq(
                    position: position, radius: distance, pet: pet))
            .listen((data) {
          if (data.isEmpty) {
            emit(AdoptionEmpty());
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

  Future<String> getDistanceBetween(GeoPoint geoPoint) async {
    final distance = await getDistanceBetweenUseCase.call(params: geoPoint);
    return distance;
  }

  Future<Either> likeAdoptionPost(LikeAdoptionReq likeReq) async {
    final result = await likeAdoptionPostUseCase.call(params: likeReq);
    return result.fold(
      (failure) => Left(failure),
      (_) {
        return Right(position);
      },
    );
  }

  void filterPet(String? petSpecies) {
    pet = petSpecies;
    adoptionStream();
  }

  void filterDistance(String distanceSelected) {
    distance = int.parse(distanceSelected);
    adoptionStream();
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
