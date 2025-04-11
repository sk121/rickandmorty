import '../entities/character.dart';


abstract class CharacterRepository {
  
  Future<List<Character>> getCharacters();

  Future<Character> getCharacterDetail(int id);
}
