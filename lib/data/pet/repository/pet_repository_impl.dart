import 'package:dartz/dartz.dart';
import 'package:pawsome/data/pet/source/pet_service.dart';
import 'package:pawsome/domain/pet/repository/pet.dart';

import '../models/nearby_pet_req.dart';

class PetRepositoryImpl implements PetRepository {
  final PetService petService;

  PetRepositoryImpl(this.petService);

  @override
  Stream<Either> listenToPetAdoption(NearbyPetReq pet) {
    return petService.listenToPetAdoption(pet);
  }
}
