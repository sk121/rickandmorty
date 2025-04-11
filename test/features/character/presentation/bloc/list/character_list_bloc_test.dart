import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/core/error/exceptions.dart';
import 'package:rick_and_morty_app/features/character/domain/entities/character.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/list/character_list_bloc.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/list/character_list_event.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/list/character_list_state.dart';

import '../../../mocks/mock_character_repository.dart'; 

void main() {
  late MockCharacterRepository mockCharacterRepository;
  late CharacterListBloc characterListBloc;

  // some dummy data for testing
  final tCharacter1 = createDummyCharacter(id: 1, name: 'Rick');
  final tCharacter2 = createDummyCharacter(id: 2, name: 'Morty');
  final tCharacterList = [tCharacter1, tCharacter2];
  final tServerException = ServerException();

  setUp(() {
    mockCharacterRepository = MockCharacterRepository();
    characterListBloc = CharacterListBloc(repository: mockCharacterRepository);
  });

  tearDown(() {
    characterListBloc.close();
  });

  test('initial state should be CharacterListInitial', () {
    expect(characterListBloc.state, CharacterListInitial());
  });

  group('FetchCharacterList', () {
    blocTest<CharacterListBloc, CharacterListState>(
      'should emit [CharacterListLoading, CharacterListLoaded] when data is gotten successfully',
      build: () {
        
        when(() => mockCharacterRepository.getCharacters())
            .thenAnswer((_) async => tCharacterList);
        return characterListBloc;
      },
      act: (bloc) => bloc.add(FetchCharacterList()),
      expect: () => <CharacterListState>[
        CharacterListLoading(),
        CharacterListLoaded(characters: tCharacterList),
      ],
      verify: (_) {
        
        verify(() => mockCharacterRepository.getCharacters()).called(1);
      },
    );

    blocTest<CharacterListBloc, CharacterListState>(
      'should emit [CharacterListLoading, CharacterListError] when getting data fails (ServerException)',
      build: () {
        when(() => mockCharacterRepository.getCharacters())
            .thenThrow(tServerException);
        return characterListBloc;
      },
      act: (bloc) => bloc.add(FetchCharacterList()),
      expect: () => <CharacterListState>[
        CharacterListLoading(),
        const CharacterListError(message: SERVER_FAILURE_MESSAGE),
      ],
      verify: (_) {
        verify(() => mockCharacterRepository.getCharacters()).called(1);
      },
    );

     blocTest<CharacterListBloc, CharacterListState>(
      'should emit [CharacterListLoading, CharacterListError] with generic message for other exceptions',
      build: () {
        when(() => mockCharacterRepository.getCharacters())
            .thenThrow(Exception('Unexpected error'));
        return characterListBloc;
      },
      act: (bloc) => bloc.add(FetchCharacterList()),
      expect: () => <dynamic>[ // Use dynamic list to allow matchers
        CharacterListLoading(),
        // Check that the message contains the generic part and the error string
        isA<CharacterListError>().having(
          (e) => e.message,
          'message',
          contains('An unexpected error occurred:'),
        ),
      ],
      verify: (_) {
        verify(() => mockCharacterRepository.getCharacters()).called(1);
      },
    );
  });
}
