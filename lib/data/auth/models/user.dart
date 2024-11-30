import 'dart:convert';
import 'package:pawsome/domain/auth/entity/user.dart';

class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final List chatId;
  final String username;
  final List petList;
  final List missingPetList;

  UserModel(
      {required this.email,
      required this.uid,
      this.photoUrl = '',
      required this.chatId,
      required this.username,
      required this.petList,
      required this.missingPetList});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"],
      uid: json["uid"],
      photoUrl: json["photoUrl"],
      chatId: List.of(json["chatId"])
          .map((i) => i /* can't generate it properly yet */)
          .toList(),
      username: json["username"],
      petList: List.of(json["petList"])
          .map((i) => i /* can't generate it properly yet */)
          .toList(),
      missingPetList: List.of(json["missingPetList"])
          .map((i) => i /* can't generate it properly yet */)
          .toList(),
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
      "missingPetList": jsonEncode(missingPetList),
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
        missingPetList: missingPetList);
  }
}
