import 'package:dartz/dartz.dart';
import 'package:pawsome/data/pet/models/pet_model.dart';
import 'package:pawsome/data/pet/models/register_pet_image_req.dart';
import 'package:pawsome/data/pet/source/pet_remote_data_source.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';
import 'package:pawsome/domain/pet/repository/pet.dart';

import '../models/nearby_pet_req.dart';

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource petRemoteDataSource;

  PetRepositoryImpl(this.petRemoteDataSource);

  @override
  Stream<List<PetEntity>> listenToPetAdoption(NearbyPetReq nearbyPet) {
    return petRemoteDataSource.listenToPetAdoption(nearbyPet).map((petModels) {
      // Use the extension to convert each PetModel to PetEntity
      return petModels.map((petModel) => petModel.toEntity()).toList();
    });
  }

  @override
  Future<Either> registerPet(PetEntity pet) async {
    try {
      PetModel petModel = pet.toModel();
      return await petRemoteDataSource.registerPet(petModel);
    } catch (e) {
      return Left('Error: $e');
    }
  }

  @override
  Future<Either> registerPetImage(RegisterPetImageReq pet) async {
    try {
      return await petRemoteDataSource.registerPetImage(pet);
    } catch (e) {
      return Left('Error: $e');
    }
  }

  @override
  Future<Either> retrieveSinglePet(String docId) async {
    try {
      final result = await petRemoteDataSource.retrieveSinglePet(docId);
      return result.fold((error) => Left(error),
          (data) => Right(PetModel.fromJson(data).toEntity()));
    } catch (e) {
      return Left('Error: $e');
    }
  }
}
