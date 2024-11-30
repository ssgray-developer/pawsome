import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/usecase/usecase.dart';

part 'button_state.dart';

class ButtonCubit extends Cubit<ButtonState> {
  ButtonCubit() : super(ButtonInitial());

  Future<void> execute({dynamic params, required UseCase usecase}) async {
    emit(ButtonLoading());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold((error) {
        emit(ButtonFailure(errorMessage: error));
      }, (data) {
        emit(ButtonSuccess());
      });
    } catch (e) {
      emit(ButtonFailure(errorMessage: e.toString()));
    }
  }
}
