import 'package:get_it/get_it.dart';
import 'package:tasky_app/features/auth/data/auth_service.dart';
import 'package:tasky_app/core/services/api_service.dart';
import 'package:tasky_app/core/services/todo_service.dart';
import 'package:tasky_app/core/services/upload_service.dart';
import 'package:tasky_app/features/auth/logic/auth_cubit.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // ================= Dio & Api Services =================
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // ================= Feature Services =================
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<TodoService>(() => TodoService());
  getIt.registerLazySingleton<UploadService>(() => UploadService());

  // ================= Cubits =================
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthService>()));
}
