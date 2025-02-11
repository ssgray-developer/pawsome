import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_values.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey globalKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool? enableInteractiveSelection;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final FormFieldValidator validator;
  final double? letterSpacing;
  final bool obscureText;
  final String labelText;
  final Widget? suffixIcon;
  final VoidCallback? onEditingComplete;
  const AuthForm({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.validator,
    this.enableInteractiveSelection,
    required this.textInputAction,
    required this.textInputType,
    this.letterSpacing,
    required this.obscureText,
    required this.labelText,
    this.suffixIcon,
    required this.globalKey,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: globalKey,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enableInteractiveSelection: enableInteractiveSelection,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        validator: validator,
        style: TextStyle(letterSpacing: letterSpacing, color: AppColors.black),
        maxLines: 1,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelStyle: TextStyle(
            fontSize: AppSize.s20,
            letterSpacing: AppSize.s0,
            color: Colors.grey[600]!,
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(12.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey, width: 2),
              borderRadius: BorderRadius.circular(12.0)),
          errorStyle: TextStyle(color: AppColors.red),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.red, width: 2),
              borderRadius: BorderRadius.circular(12.0)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.red, width: 2),
              borderRadius: BorderRadius.circular(12.0)),
          suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
              vertical: AppSize.s16, horizontal: AppSize.s10),
        ),
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
