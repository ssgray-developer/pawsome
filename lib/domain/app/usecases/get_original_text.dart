import 'package:pawsome/domain/app/repository/app.dart';
import '../../../core/usecase/usecase.dart';

class GetOriginalTextUseCase implements UseCase<String, String> {
  final AppRepository appRepository;

  GetOriginalTextUseCase(this.appRepository);

  @override
  Future<String> call({String? params}) async {
    return await appRepository.getOriginalText(params!);
  }
}
