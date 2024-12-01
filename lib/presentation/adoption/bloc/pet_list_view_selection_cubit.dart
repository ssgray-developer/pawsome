import 'package:flutter_bloc/flutter_bloc.dart';

class PetListViewSelectionCubit extends Cubit<int?> {
  PetListViewSelectionCubit() : super(null);

  int? selectedIndex;

  void selectPet(int? index) {
    selectedIndex = index;

    emit(index);
  }
}
