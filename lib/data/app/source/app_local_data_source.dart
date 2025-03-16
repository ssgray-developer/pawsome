import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pawsome/data/reverse_lookup_service.dart';

abstract class AppLocalDataSource {
  Future<Either> versionCheck();
  Future<Either<String, XFile>> pickImage();
  Future<Either> retrieveLostData();
  Future<Either> cropImage(String imagePath);
  Future<String> getOriginalText(String text);
  Future<Either> loadTranslations(String languageCode);
}

class AppLocalDataSourceImpl extends AppLocalDataSource {
  final ImagePicker imagePicker;
  final ImageCropper imageCropper;
  final ReverseLookupService reverseLookupService;

  AppLocalDataSourceImpl(
      this.imagePicker, this.imageCropper, this.reverseLookupService);

  @override
  Future<Either> versionCheck() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;
      final buildVersion = packageInfo.buildNumber;
      return Right(appVersion);
    } catch (e) {
      return const Left('An unknown error has occurred.');
    }
  }

  @override
  Future<Either<String, XFile>> pickImage() async {
    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return Right(pickedFile);
      } else {
        return const Left('No image was selected.');
      }
    } catch (e) {
      return const Left('An unknown error has occurred.');
    }
  }

  @override
  Future<Either> retrieveLostData() async {
    try {
      final LostDataResponse response = await imagePicker.retrieveLostData();
      if (response.isEmpty) {
        return const Left("No lost data found");
      }
      if (response.files != null && response.files!.isNotEmpty) {
        return Right(
            response.files!.first); // Returning the first recovered image
      }
      return Left("Failed to retrieve lost data: ${response.exception}");
    } catch (e) {
      return Left("Error retrieving lost data: $e");
    }
  }

  @override
  Future<Either> cropImage(String imagePath) async {
    try {
      final croppedImage = await imageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              // CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              // CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
            ],
          ),
        ],
      );
      if (croppedImage != null) {
        return Right(await croppedImage.readAsBytes());
      } else {
        return const Left('No image was cropped.');
      }
    } catch (e) {
      return const Left('An unknown error has occurred.');
    }
  }

  @override
  Future<String> getOriginalText(String text) async {
    try {
      final originalText = reverseLookupService.getOriginalText(text);
      return originalText;
    } catch (e) {
      return 'An unknown error has occurred.';
    }
  }

  @override
  Future<Either> loadTranslations(String languageCode) async {
    try {
      reverseLookupService.loadTranslations(languageCode);
      return const Right('Done load file.');
    } catch (e) {
      return const Left('An unknown error has occurred.');
    }
  }
}
