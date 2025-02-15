import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      email: snap["email"],
      uid: snap["uid"],
      photoUrl: snap["photoUrl"],
      chatId: snap["chatId"],
      username: snap["username"],
      petList: snap["petList"],
      isSuspended: snap["isSuspended"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "uid": uid,
      "photoUrl": photoUrl,
      "chatId": chatId,
      "username": username,
      "petList": chatId,
      "isSuspended": isSuspended
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
