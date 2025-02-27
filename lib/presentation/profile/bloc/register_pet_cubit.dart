import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pawsome/data/pet/models/register_pet_image_req.dart';
import 'package:pawsome/domain/auth/usecases/get_user_details.dart';
import 'package:pawsome/domain/location/usecases/get_location.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';
import 'package:pawsome/domain/pet/usecases/register_pet.dart';
import 'package:pawsome/domain/pet/usecases/register_pet_image.dart';
import 'package:pawsome/domain/pet/usecases/retrieve_single_pet.dart';

import '../../../data/pet/models/pet_registration_req.dart';

part 'register_pet_state.dart';

class RegisterPetCubit extends Cubit<RegisterPetState> {
  final RegisterPetUseCase registerPetUseCase;
  final RegisterPetImageUseCase registerPetImageUseCase;
  final GetUserDetailsUseCase getUserDetailsUseCase;
  final GetLocationUseCase getLocationUseCase;
  final RetrieveSinglePetUseCase retrieveSinglePetUseCase;
  RegisterPetCubit(
      this.registerPetUseCase,
      this.registerPetImageUseCase,
      this.getUserDetailsUseCase,
      this.getLocationUseCase,
      this.retrieveSinglePetUseCase)
      : super(RegisterPetInitial());

  Future<void> registerPet(PetRegistrationReq petRegistrationReq) async {
    try {
      emit(RegisterPetLoading());
      final locationResult = await getLocationUseCase.call();
      locationResult.fold((message) => emit(RegisterPetError(message)),
          (location) async {
        final userResult = await getUserDetailsUseCase.call();
        userResult.fold((message) => emit(RegisterPetError(message)),
            (user) async {
          final petImageUrlResult = await registerPetImageUseCase.call(
              params: RegisterPetImageReq(
                  image: petRegistrationReq.file, userUid: user.uid));
          petImageUrlResult.fold((message) => emit(RegisterPetError(message)),
              (url) async {
            final pet = PetEntity(
                photoUrl: url,
                gender: petRegistrationReq.gender,
                name: petRegistrationReq.name,
                age: petRegistrationReq.age,
                petClass: petRegistrationReq.petClass,
                petSpecies: petRegistrationReq.species,
                petPrice: petRegistrationReq.price,
                reason: petRegistrationReq.reason,
                location: location,
                date: Timestamp.now().toDate(),
                owner: user.username,
                ownerUid: user.uid,
                ownerEmail: user.email,
                ownerPhotoUrl: user.photoUrl,
                likes: []);
            final registrationResult =
                await registerPetUseCase.call(params: pet);
            registrationResult.fold(
                (message) => emit(RegisterPetError(message)), (docId) async {
              final docIdResult =
                  await retrieveSinglePetUseCase.call(params: docId);
              docIdResult.fold((message) => emit(RegisterPetError(message)),
                  (pet) => emit(RegisterPetSuccessful(pet)));
            });
          });
        });
      });
    } catch (e) {
      // emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }
}
