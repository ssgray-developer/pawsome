import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdoptionFormField extends StatefulWidget {
  final GlobalKey globalKey;
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final String hintText;
  final Color color;
  final int maxLines;
  final bool isSeparatorNeeded;
  final bool isTextCentered;
  final bool interactionEnabled;
  final int? maxCharacters;
  final FormFieldValidator validator;
  final VoidCallback? onEditingComplete;
  const AdoptionFormField(
      {super.key,
      required this.globalKey,
      required this.focusNode,
      required this.controller,
      required this.textInputType,
      required this.textInputAction,
      required this.hintText,
      required this.validator,
      required this.color,
      this.maxLines = 1,
      this.isSeparatorNeeded = false,
      this.isTextCentered = false,
      this.interactionEnabled = true,
      this.maxCharacters,
      this.onEditingComplete});

  @override
  State<AdoptionFormField> createState() => _AdoptionFormFieldState();
}

class _AdoptionFormFieldState extends State<AdoptionFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: widget.focusNode.hasFocus
              ? [
                  BoxShadow(
                    color: widget.color,
                    blurRadius: 4,
                    spreadRadius: 4,
                  )
                ]
              : null),
      child: Form(
        key: widget.globalKey,
        child: TextFormField(
          textAlign: widget.isTextCentered ? TextAlign.center : TextAlign.start,
          enableInteractiveSelection: widget.interactionEnabled,
          inputFormatters: widget.isSeparatorNeeded
              ? [
                  ThousandsSeparatorInputFormatter(),
                  FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                  LengthLimitingTextInputFormatter(widget.maxCharacters)
                  // FilteringTextInputFormatter.digitsOnly
                ]
              : null,
          keyboardType: widget.textInputType,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          controller: widget.controller,
          validator: widget.validator,
          // style: const TextStyle(letterSpacing: AppSize.s5),
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: widget.color,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: widget.color,
                width: 2.0,
              ),
            ),
          ),
          onEditingComplete: widget.onEditingComplete,
        ),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
