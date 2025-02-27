import 'package:dartz/dartz.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/pet.dart';

class RetrieveSinglePetUseCase implements UseCase<Either, String> {
  final PetRepository petRepository;

  RetrieveSinglePetUseCase(this.petRepository);

  @override
  Future<Either> call({String? params}) async {
    return await petRepository.retrieveSinglePet(params!);
  }
}
