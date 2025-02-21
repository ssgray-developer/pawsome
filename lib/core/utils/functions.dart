// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/core/theme/app_colors.dart';

// Future<Uint8List?> pickImage({bool shouldCrop = false}) async {
// final ImagePicker picker = ImagePicker();
// final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//
// if (image != null) {
//   if (shouldCrop) {
//     final croppedImage = await cropImage(image.path);
//     // final bgRemoved = await ApiClient.removeBgApi(croppedImage!);
//     return croppedImage;
//   } else {
//     return await image.readAsBytes();
//   }
// }
// return null;
// }

Future<Uint8List?> cropImage(String imageFilePath) async {
  // CroppedFile? croppedFile = await ImageCropper().cropImage(
  //   sourcePath: imageFilePath,
  //   aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  //   uiSettings: [
  //     AndroidUiSettings(
  //         toolbarTitle: 'Cropper',
  //         toolbarColor: Colors.deepOrange,
  //         toolbarWidgetColor: Colors.white,
  //         initAspectRatio: CropAspectRatioPreset.original,
  //         lockAspectRatio: false),
  //     IOSUiSettings(
  //       title: 'Crop pet image',
  //     ),
  //   ],
  // );
  // if (croppedFile != null) {
  //   return croppedFile.readAsBytes();
  // }
  // return null;
}

// String checkTextType(String message) {
//   try {
//     Uri uri = Uri.parse(message);
//     String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
//     if (typeString == 'jpg') {
//       return 'image';
//     } else {
//       return 'string';
//     }
//   } on FormatException {
//     try {
//       Map _ = json.decode(message);
//
//       return 'location';
//     } on JsonUnsupportedObjectError {
//       return 'string';
//     }
//   }
// }

String k_m_b_generator(int num) {
  if (num > 999 && num < 99999) {
    return "${(num / 1000).toStringAsFixed(1)} K";
  } else if (num > 99999 && num < 999999) {
    return "${(num / 1000).toStringAsFixed(0)} K";
  } else if (num > 999999 && num < 999999999) {
    return "${(num / 1000000).toStringAsFixed(1)} M";
  } else if (num > 999999999) {
    return "${(num / 1000000000).toStringAsFixed(1)} B";
  } else {
    return num.toString();
  }
}

String getName(BuildContext context, String value) {
  if (value.contains('&')) {
    final split = value.split(' & ');
    return '${split[0].tr()} & ${split[1].tr()}';
  } else {
    return context.tr(value);
  }
}

String compareUserId(String firstId, String secondId) {
  List<String> split = [];
  split.add(firstId);
  split.add(secondId);
  split.sort((a, b) => a.compareTo(b));
  String res = '';
  for (var element in split) {
    res += element;
  }
  return res;
}
