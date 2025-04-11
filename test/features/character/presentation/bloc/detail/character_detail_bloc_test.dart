import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/core/error/exceptions.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/detail/character_detail_bloc.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/detail/character_detail_event.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/detail/character_detail_state.dart';

import '../../../mocks/mock_character_repository.dart'; 

void main() {
  late MockCharacterRepository mockCharacterRepository;
  late CharacterDetailBloc characterDetailBloc;

  const tCharacterId = 1;
  final tCharacter = createDummyCharacter(id: tCharacterId); // Use helper
  final tServerException = ServerException();

  setUp(() {
   
    mockCharacterRepository = MockCharacterRepository();
    characterDetailBloc = CharacterDetailBloc(repository: mockCharacterRepository);
  });

  tearDown(() {
    characterDetailBloc.close();
  });

  test('initial state should be CharacterDetailInitial', () {
    expect(characterDetailBloc.state, CharacterDetailInitial());
  });

  group('FetchCharacterDetail', () {
    blocTest<CharacterDetailBloc, CharacterDetailState>(
      'should emit [CharacterDetailLoading, CharacterDetailLoaded] when data is gotten successfully',
      build: () {
        when(() => mockCharacterRepository.getCharacterDetail(tCharacterId))
            .thenAnswer((_) async => tCharacter);
        return characterDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchCharacterDetail(id: tCharacterId)),
      expect: () => <CharacterDetailState>[
        CharacterDetailLoading(),
        CharacterDetailLoaded(character: tCharacter),
      ],
      verify: (_) {
        verify(() => mockCharacterRepository.getCharacterDetail(tCharacterId)).called(1);
      },
    );

    blocTest<CharacterDetailBloc, CharacterDetailState>(
      'should emit [CharacterDetailLoading, CharacterDetailError] when getting data fails (ServerException)',
      build: () {
        when(() => mockCharacterRepository.getCharacterDetail(tCharacterId))
            .thenThrow(tServerException);
        return characterDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchCharacterDetail(id: tCharacterId)),
      expect: () => <CharacterDetailState>[
        CharacterDetailLoading(),
        const CharacterDetailError(message: SERVER_FAILURE_MESSAGE),
      ],
      verify: (_) {
        verify(() => mockCharacterRepository.getCharacterDetail(tCharacterId)).called(1);
      },
    );

    blocTest<CharacterDetailBloc, CharacterDetailState>(
      'should emit [CharacterDetailLoading, CharacterDetailError] with generic message for other exceptions',
      build: () {
        when(() => mockCharacterRepository.getCharacterDetail(tCharacterId))
            .thenThrow(Exception('Some other error'));
        return characterDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchCharacterDetail(id: tCharacterId)),
      expect: () => <dynamic>[ // Use dynamic list for matcher
        CharacterDetailLoading(),
        isA<CharacterDetailError>().having(
          (e) => e.message,
          'message',
          contains('An unexpected error occurred:'),
        ),
      ],
      verify: (_) {
        verify(() => mockCharacterRepository.getCharacterDetail(tCharacterId)).called(1);
      },
    );
  });
}
