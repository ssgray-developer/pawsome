import 'package:pawsome/data/auth/models/user.dart';

class UserEntity {
  final String email;
  final String uid;
  final String photoUrl;
  final List chatId;
  final String username;
  final List petList;
  final bool isSuspended;

  UserEntity(
      {required this.email,
      required this.uid,
      this.photoUrl = '',
      required this.chatId,
      required this.username,
      required this.petList,
      required this.isSuspended});
}

extension UserXModel on UserEntity {
  UserModel toModel() {
    return UserModel(
        email: email,
        uid: uid,
        photoUrl: photoUrl,
        chatId: chatId,
        username: username,
        petList: petList,
        isSuspended: isSuspended);
  }
}
