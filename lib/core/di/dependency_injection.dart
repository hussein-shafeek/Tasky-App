import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/features/home/data/data_sources/remote/tasks_remote_data_source.dart';
import 'package:tasky_app/features/home/data/data_sources/remote/tasks_remote_data_source_impl.dart';
import 'package:tasky_app/features/home/data/repositories/tasks_repository_impl.dart';
import 'package:tasky_app/features/home/domain/repositories/tasks_repository.dart';
import 'package:tasky_app/features/home/domain/use_cases/get_task_by_id_usecase.dart';
import 'package:tasky_app/features/home/domain/use_cases/get_tasks_usecase.dart';
import 'package:tasky_app/features/home/presentation/cubit/get_tasks_cubit.dart';
import 'package:tasky_app/features/home/presentation/cubit/task_cubit_old.dart';
import 'package:tasky_app/core/services/todo_service.dart';
import 'package:tasky_app/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:tasky_app/features/auth/data/data_sources/local/auth_shared_local_data_source.dart';
import 'package:tasky_app/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:tasky_app/features/auth/data/data_sources/remote/auth_remote_data_source_impl.dart';
import 'package:tasky_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:tasky_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:tasky_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tasky_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:tasky_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/profile/data/data_sources/remote/profile_remote_data_source.dart';
import 'package:tasky_app/features/profile/data/data_sources/remote/profile_remote_data_source_impl.dart';
import 'package:tasky_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:tasky_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tasky_app/features/profile/domain/use_cases/get_profile_usecase.dart';
import 'package:tasky_app/features/profile/presentation/cubit/profile_cubit.dart';
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
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(authRepo: getIt.get<AuthRepo>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(authRepo: getIt.get<AuthRepo>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(authRepo: getIt.get<AuthRepo>()),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: getIt.get<LoginUseCase>(),
      registerUseCase: getIt.get<RegisterUseCase>(),
      logoutUseCase: getIt.get<LogoutUseCase>(),
    ),
  );

  ///?
  getIt.registerLazySingleton<TodoService>(() => TodoService());

  getIt.registerFactory<TaskCubitOld>(
    () => TaskCubitOld(getIt.get<TodoService>()),
  );
  //Remote Data Source
  getIt.registerLazySingleton<TasksRemoteDataSource>(
    () => TasksRemoteDataSourceImpl(apiConsumer: getIt<ApiConsumer>()),
  );

  //Repository
  getIt.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(
      remoteDataSource: getIt.get<TasksRemoteDataSource>(),
    ),
  );

  //UseCase
  getIt.registerLazySingleton<GetTasksUseCase>(
    () => GetTasksUseCase(getIt.get<TasksRepository>()),
  );
  getIt.registerLazySingleton<GetTaskByIdUseCase>(
    () => GetTaskByIdUseCase(getIt.get<TasksRepository>()),
  );

  //Cubit
  getIt.registerFactory<GetTasksCubit>(
    () => GetTasksCubit(
      getTasksUseCase: getIt<GetTasksUseCase>(),
      getTaskByIdUseCase: getIt<GetTaskByIdUseCase>(),
    ),
  );

  //Profile
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiConsumer: getIt<ApiConsumer>()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt<ProfileRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(repository: getIt<ProfileRepository>()),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getProfileUseCase: getIt<GetProfileUseCase>()),
  );
}
