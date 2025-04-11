import '../../../../core/error/exceptions.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_remote_data_source.dart';



class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    
  });

  @override
  Future<List<Character>> getCharacters() async {
    
    try {
      final remoteCharacters = await remoteDataSource.getCharacters();
     
      return remoteCharacters;
    } on ServerException {
     
      rethrow;
    }

  }

  @override
  Future<Character> getCharacterDetail(int id) async {
  
    try {
      final remoteCharacter = await remoteDataSource.getCharacterDetail(id);
      
      return remoteCharacter; 
    } on ServerException {
      rethrow; 
    }
    
  }
}
