import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Listen for focus changes
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30.0),
      child: TextField(
        focusNode: _focusNode,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: _isFocused ? '' : "e.g: Golden Retriever",
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Icon(Icons.search_rounded),
          ),
          prefixIconColor: Colors.black,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.social_distance_rounded)),
          ),
          suffixIconColor: Colors.black,
          filled: true,
          // To fill the background with a color
          fillColor: Colors.white,
          // White background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded corners
            borderSide: BorderSide.none, // Remove the border line
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(30.0),
          //   // Rounded corners on focus
          //   borderSide: BorderSide(
          //     color: AppColors.primary, // Color when focused
          //     width: 1.0, // Border width when focused
          //   ),
          // ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            // Rounded corners when enabled
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
