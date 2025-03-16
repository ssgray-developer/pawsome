import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'shorts_state.dart';

class ShortsCubit extends Cubit<ShortsState> {
  ShortsCubit() : super(ShortsInitial());
}
