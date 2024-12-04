import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PetItem {
  final String name;
  final String value;
  final String imagePath;
  final Color borderColor;
  final Color boxColor;

  PetItem({
    required this.name,
    required this.value,
    required this.imagePath,
    required this.borderColor,
    required this.boxColor,
  });
}
