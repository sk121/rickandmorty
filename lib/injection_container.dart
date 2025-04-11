import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/character/data/datasources/character_remote_data_source.dart';
import 'features/character/data/datasources/character_remote_data_source_impl.dart';
import 'features/character/data/repositories/character_repository_impl.dart';
import 'features/character/domain/repositories/character_repository.dart';
import 'features/character/presentation/bloc/detail/character_detail_bloc.dart';
import 'features/character/presentation/bloc/list/character_list_bloc.dart';

// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  // Features - Character List & Detail
  _registerCharacterFeature();


  sl.registerLazySingleton(() => http.Client());
}

void _registerCharacterFeature() {
 
  sl.registerFactory(() => CharacterListBloc(repository: sl()));
  sl.registerFactory(() => CharacterDetailBloc(repository: sl()));

  

 
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(remoteDataSource: sl()),
    
  );

  
  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(client: sl()),
  );

  
}
