import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_strings.dart';
import '../bloc/adoption_cubit.dart';

class DistanceFilter extends StatefulWidget {
  const DistanceFilter({super.key});

  @override
  State<DistanceFilter> createState() => _DistanceFilterState();
}

class _DistanceFilterState extends State<DistanceFilter> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Center(
            child: Text(
              '${context.read<AdoptionCubit>().distance} ${context.tr(AppStrings.km)}',
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          iconStyleData: const IconStyleData(icon: SizedBox.shrink()),
          buttonStyleData: ButtonStyleData(
            height: 55,
            width: 160,
            // padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250, // Optional: limit dropdown height
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(12), // Rounded corners for dropdown
              color: Colors.white, // Dropdown background color
            ),
            elevation: 8, // Optional: shadow effect
            offset: const Offset(0, -5), // Optional: adjust dropdown position
          ),
          items: distanceItem
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: (String? value) {
            context.read<AdoptionCubit>().filterDistance(value!);
            setState(() {});
          },
        ),
      ),
    );
  }
}
