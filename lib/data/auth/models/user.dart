import 'dart:convert';
import 'package:pawsome/domain/auth/entity/user.dart';

class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final List chatId;
  final String username;
  final List petList;
  final bool isSuspended;

  UserModel(
      {required this.email,
      required this.uid,
      this.photoUrl = '',
      required this.chatId,
      required this.username,
      required this.petList,
      required this.isSuspended});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"],
      uid: json["uid"],
      photoUrl: json["photoUrl"],
      chatId: json["chatId"],
      username: json["username"],
      petList: json["petList"],
      isSuspended: json["isSuspended"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "uid": uid,
      "photoUrl": photoUrl,
      "chatId": jsonEncode(chatId),
      "username": username,
      "petList": jsonEncode(petList),
    };
  }
}

extension UserXModel on UserModel {
  UserEntity toEntity() {
    return UserEntity(
        email: email,
        uid: uid,
        photoUrl: photoUrl,
        chatId: chatId,
        username: username,
        petList: petList,
        isSuspended: isSuspended);
  }
}
