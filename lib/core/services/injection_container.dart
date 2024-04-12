import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_clean/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:tdd_clean/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_clean/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_clean/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_clean/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_clean/src/authentication/presentation/cubit/authentication_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
  // app logic
    ..registerFactory(() => AuthenticationCubit(
          createUser: sl(),
          getUsers: sl(),
        ))

    // use case
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    // repository
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))

    // data source
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthRemoteDataSrcImpl(sl()))

    // external dependency
    ..registerLazySingleton(http.Client.new);
}
