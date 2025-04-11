import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/features/character/domain/entities/character.dart';
import 'package:rick_and_morty_app/features/character/domain/repositories/character_repository.dart';

// Create a mock class for the repository
class MockCharacterRepository extends Mock implements CharacterRepository {}

// Helper function to create a dummy CharacterLocation for tests
CharacterLocation createDummyCharacterLocation({String name = 'Earth', String url = ''}) {
  return CharacterLocation(name: name, url: url);
}

// Helper function to create a dummy Character for tests
Character createDummyCharacter({
  int id = 1,
  String name = 'Rick Sanchez',
  String status = 'Alive',
  String species = 'Human',
  String type = '',
  String gender = 'Male',
  String image = 'image_url',
  List<String> episode = const ['ep1', 'ep2'],
  String url = 'char_url',
}) {
  return Character(
    id: id,
    name: name,
    status: status,
    species: species,
    type: type,
    gender: gender,
    origin: createDummyCharacterLocation(name: 'Origin'),
    location: createDummyCharacterLocation(name: 'Location'),
    image: image,
    episode: episode,
    url: url,
    created: DateTime.now(),
  );
}
