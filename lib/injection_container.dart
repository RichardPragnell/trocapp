import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trocapp/core/network/network_info.dart';
import 'package:trocapp/core/util/input_converter.dart';
import 'package:trocapp/features/explorer/data/datasources/item_local_data_source.dart';
import 'package:trocapp/features/explorer/data/datasources/item_remote_data_source.dart';
import 'package:trocapp/features/explorer/data/repositories/item_repository_impl.dart';
import 'package:trocapp/features/explorer/domain/usecases/get_concrete_item.dart';
import 'package:trocapp/features/explorer/domain/usecases/get_near_item.dart';
import 'package:trocapp/features/explorer/presentation/bloc/bloc.dart';

import 'features/explorer/domain/repositories/item_repository.dart';

// Service locator
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  //Bloc
  sl.registerFactory(
    () => ItemBloc(
      concrete: sl(),
      near: sl(),
      inputConverter: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetConcreteItem(sl()));
  sl.registerLazySingleton(() => GetNearItem(sl()));

  // Repository
  sl.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ItemRemoteDataSource>(
    () => ItemRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ItemLocalDataSource>(
    () => ItemLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
