import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pawsome/domain/app/usecases/crop_image.dart';
import 'package:pawsome/domain/app/usecases/pick_image.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  final PickImageUseCase pickImageUseCase;
  final CropImageUseCase cropImageUseCase;
  ImagePickerCubit(this.pickImageUseCase, this.cropImageUseCase)
      : super(ImagePickerInitial());

  Future<void> pickImage({required bool shouldCrop}) async {
    final pickedImage = await pickImageUseCase.call();
    pickedImage.fold(
      (message) => (),
      (image) async {
        if (shouldCrop) {
          final croppedImage = await cropImageUseCase.call(params: image.path);
          croppedImage.fold((message) => emit(ImagePickerFailure(message)),
              (image) => emit(ImagePickerSuccess(image)));
        } else {
          emit(ImagePickerSuccess(await image.readAsBytes()));
        }
      },
    );
  }
}
