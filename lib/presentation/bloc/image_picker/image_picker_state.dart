part of 'image_picker_cubit.dart';

@immutable
abstract class ImagePickerState {}

class ImagePickerInitial extends ImagePickerState {}

class ImagePickerSuccess extends ImagePickerState {
  final Uint8List image;

  ImagePickerSuccess(this.image);
}

class ImagePickerFailure extends ImagePickerState {
  final String message;

  ImagePickerFailure(this.message);
}
