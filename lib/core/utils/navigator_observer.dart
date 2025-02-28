import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/bloc/image_picker/image_picker_cubit.dart';
import '../../presentation/profile/pages/pet_adoption_listing.dart';

class MyNavigatorObserver extends NavigatorObserver {
  final GlobalKey<NavigatorState> navigatorKey;

  MyNavigatorObserver(this.navigatorKey);

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    // Ensure that the context is available before using it
    if (navigatorKey.currentContext != null) {
      // Proceed with your logic here
      final context = navigatorKey.currentContext!;

      // Check if the popped route is PetAdoptionListing
      if (route is MaterialPageRoute &&
          route.settings.arguments is PetAdoptionListing) {
        // Call clearImage only when popping PetAdoptionListing
        context.read<ImagePickerCubit>().clearImage();
      }
    }
  }
}
