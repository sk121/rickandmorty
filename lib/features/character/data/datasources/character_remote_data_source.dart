import '../models/character_model.dart';

abstract class CharacterRemoteDataSource {

  
 
  Future<List<CharacterModel>> getCharacters();

  
  
  
  Future<CharacterModel> getCharacterDetail(int id);
}
