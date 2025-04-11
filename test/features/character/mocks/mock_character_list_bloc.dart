import 'package:bloc_test/bloc_test.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/list/character_list_bloc.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/list/character_list_event.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/list/character_list_state.dart';

// Create a mock class for the Bloc using bloc_test's MockBloc
class MockCharacterListBloc extends MockBloc<CharacterListEvent, CharacterListState> 
  implements CharacterListBloc {}
