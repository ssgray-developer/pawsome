import 'package:dartz/dartz.dart';
import 'package:pawsome/data/pet/models/like_adoption_req.dart';
import 'package:pawsome/data/pet/models/register_pet_image_req.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';

import '../../../data/pet/models/nearby_pet_req.dart';

abstract class PetRepository {
  Stream<List<PetEntity>> listenToPetAdoption(NearbyPetReq nearbyPetReq);
  Future<Either> registerPet(PetEntity pet);
  Future<Either> registerPetImage(RegisterPetImageReq registerReq);
  Future<Either> retrieveSinglePet(String docId);
  Future<Either> likeAdoptionPost(LikeAdoptionReq likeReq);
}
