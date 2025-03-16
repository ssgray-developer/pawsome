import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/domain/app/usecases/local_version_check.dart';
import 'package:pawsome/domain/app/usecases/remote_version_check.dart';

part 'app_update_state.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  final RemoteVersionCheckUseCase remoteCheckForUpdateUseCase;
  final LocalVersionCheckUseCase localVersionCheckUseCase;
  AppUpdateCubit(
      this.remoteCheckForUpdateUseCase, this.localVersionCheckUseCase)
      : super(AppUpdateInitial());

  Future<void> checkForUpdate() async {
    emit(AppUpdateLoading());
    try {
      final checkUpdate = await remoteCheckForUpdateUseCase.call();
      checkUpdate.fold((message) {
        emit(AppUpdateError(message));
      }, (result) {
        // TODO: Implement local version check and comparison
      });
    } catch (e) {
      emit(AppUpdateError(e.toString()));
    }
  }
}
