import 'package:dartz/dartz.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/pet.dart';

class RegisterPetUseCase implements UseCase<Either, PetEntity> {
  final PetRepository petRepository;

  RegisterPetUseCase(this.petRepository);

  @override
  Future<Either> call({PetEntity? params}) async {
    return await petRepository.registerPet(params!);
  }
}
