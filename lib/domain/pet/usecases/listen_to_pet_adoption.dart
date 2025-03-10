import 'package:dartz/dartz.dart';
import 'package:pawsome/core/usecase/stream_usecase.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';
import 'package:pawsome/domain/pet/repository/pet.dart';

import '../../../data/pet/models/nearby_pet_req.dart';

class ListenToPetAdoptionUseCase
    implements StreamUseCase<List<PetEntity>, NearbyPetReq> {
  final PetRepository petRepository;

  ListenToPetAdoptionUseCase(this.petRepository);

  @override
  Stream<List<PetEntity>> call({NearbyPetReq? params}) {
    return petRepository.listenToPetAdoption(params!);
  }
}
