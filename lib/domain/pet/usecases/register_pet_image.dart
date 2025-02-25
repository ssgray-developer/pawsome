
import 'package:dartz/dartz.dart';
import 'package:pawsome/data/pet/models/register_pet_image_req.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/pet.dart';

class RegisterPetImageUseCase implements UseCase<Either, RegisterPetImageReq> {
  final PetRepository petRepository;

  RegisterPetImageUseCase(this.petRepository);

  @override
  Future<Either> call({RegisterPetImageReq? params}) async {
    return await petRepository.registerPetImage(params!);
  }
}
