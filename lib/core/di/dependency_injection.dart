import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/core/cubit/task_cubit.dart';
import 'package:tasky_app/core/services/todo_service.dart';
import 'package:tasky_app/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:tasky_app/features/auth/data/data_sources/local/auth_shared_local_data_source.dart';
import 'package:tasky_app/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:tasky_app/features/auth/data/data_sources/remote/auth_remote_data_source_impl.dart';
import 'package:tasky_app/features/auth/data/repositories/auth_repo.dart';
import 'package:tasky_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/view_model/auth_view_model.dart';
import '../api/api_consumer.dart';
import '../api/dio_consumer.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  getIt.registerSingleton<Dio>(Dio());

  //SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // ApiConsumer
  getIt.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: getIt.get<Dio>(), prefs: prefs),
  );

  getIt.registerSingleton<CancelToken>(CancelToken());

  //?  auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiConsumer: getIt.get<ApiConsumer>()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthSharedLocalDataSourceImpl(
      sharedPreferences: getIt.get<SharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      authRemoteDataSource: getIt.get<AuthRemoteDataSource>(),
      localDataSource: getIt.get<AuthLocalDataSource>(),
    ),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(authRepo: getIt.get<AuthRepo>()),
  );

  ///?
  getIt.registerLazySingleton<TodoService>(() => TodoService());

  getIt.registerFactory<TaskCubit>(() => TaskCubit(getIt.get<TodoService>()));
}
