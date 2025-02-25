import 'dart:typed_data';

class RegisterPetImageReq {
  final Uint8List image;
  final String userUid;
  RegisterPetImageReq({required this.image, required this.userUid});
}
