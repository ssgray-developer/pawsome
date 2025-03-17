import 'package:dartz/dartz.dart';
import 'package:pawsome/data/pet/models/like_adoption_req.dart';
import '../../../core/usecase/usecase.dart';
import '../repository/pet.dart';

class LikeAdoptionPostUseCase implements UseCase<Either, LikeAdoptionReq> {
  final PetRepository petRepository;

  LikeAdoptionPostUseCase(this.petRepository);

  @override
  Future<Either> call({LikeAdoptionReq? params}) async {
    return await petRepository.likeAdoptionPost(params!);
  }
}
