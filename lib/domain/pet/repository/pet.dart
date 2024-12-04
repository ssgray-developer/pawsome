import 'package:dartz/dartz.dart';

import '../../../data/pet/models/nearby_pet_req.dart';

abstract class PetRepository {
  Stream<Either> listenToPetAdoption(NearbyPetReq params);
}
