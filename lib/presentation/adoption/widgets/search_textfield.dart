import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/common/animal_list.dart';

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
      child: Autocomplete(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return (birdSpecies +
                      catSpecies +
                      dogSpecies +
                      ferretSpecies +
                      fishSpecies +
                      horseSpecies +
                      guineaPigSpecies +
                      iguanaSpecies +
                      mouseRatSpecies +
                      otterSpecies +
                      rabbitSpecies +
                      tortoiseSpecies)
                  .where((element) => element != 'unknown')
                  .map((element) => context.tr(element));
            }
            return (birdSpecies +
                    catSpecies +
                    dogSpecies +
                    ferretSpecies +
                    fishSpecies +
                    horseSpecies +
                    guineaPigSpecies +
                    iguanaSpecies +
                    mouseRatSpecies +
                    otterSpecies +
                    rabbitSpecies +
                    tortoiseSpecies)
                .where((String pet) =>
                    pet != 'unknown' &&
                    pet
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()))
                .map((element) => context.tr(element));
          },
          onSelected: (String selection) {},
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: 280,
                  constraints: const BoxConstraints(
                    maxHeight: 300, // Increased height of dropdown
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0), // Taller list items
                          child: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextField(
              focusNode: focusNode,
              controller: textEditingController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: _isFocused ? '' : "e.g: Golden Retriever",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: Icon(Icons.search_rounded),
                ),
                prefixIconColor: Colors.black,
                filled: true,
                // To fill the background with a color
                fillColor: Colors.grey.shade100,
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
            );
          }),
    );
  }
}
