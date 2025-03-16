import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawsome/domain/app/usecases/get_original_text.dart';
import 'package:pawsome/domain/app/usecases/load_translations.dart';

class ReverseLookupCubit extends Cubit {
  final LoadTranslationsUseCase loadTranslationsUseCase;
  final GetOriginalTextUseCase getOriginalTextUseCase;
  ReverseLookupCubit(this.loadTranslationsUseCase, this.getOriginalTextUseCase)
      : super(null);

  Future<void> loadTranslations(String languageCode) async {
    final revisedLanguageCode = languageCode.replaceAll('_', '-');
    await loadTranslationsUseCase.call(params: revisedLanguageCode);
  }

  Future<String> getOriginalText(String text) async {
    return await getOriginalTextUseCase.call(params: text);
  }
}
