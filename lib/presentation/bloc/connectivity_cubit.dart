import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';
import 'package:pawsome/domain/connectivity/repository/connectivity_repository.dart';
import 'package:pawsome/domain/connectivity/usecase/check_connectivity.dart';

import '../../service_locator.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(ConnectivityInitial());

  Future<void> checkConnectivity() async {
    emit(ConnectivityLoading());

    try {
      final result = await sl<CheckConnectivityUseCase>().call();
      result.fold((message) {
        emit(ConnectivityFailure(message));
      }, (_) {
        emit(ConnectivitySuccess());
      });
    } catch (e) {
      emit(ConnectivityFailure("Error checking connectivity: ${e.toString()}"));
    }
  }
}
