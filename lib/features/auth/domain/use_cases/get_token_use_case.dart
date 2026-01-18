import 'package:tasky_app/features/auth/data/data_sources/local/auth_local_data_source.dart';

class GetTokenUseCase {
  final AuthLocalDataSource localDataSource;

  GetTokenUseCase({required this.localDataSource});

  Future<String?> call() async {
    return await localDataSource.getToken();
  }
}
