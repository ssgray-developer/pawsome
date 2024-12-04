import 'package:dartz/dartz.dart';
import 'package:pawsome/core/usecase/stream_usecase.dart';
import 'package:pawsome/domain/pet/repository/pet.dart';

import '../../../data/pet/models/nearby_pet_req.dart';

class ListenToPetAdoptionUseCase
    implements StreamUseCase<Either, NearbyPetReq> {
  final PetRepository petRepository;

  ListenToPetAdoptionUseCase(this.petRepository);

  @override
  Stream<Either> call({NearbyPetReq? params}) {
    return petRepository.listenToPetAdoption(params!);
  }
}
