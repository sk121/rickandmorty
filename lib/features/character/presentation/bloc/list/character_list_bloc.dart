import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/exceptions.dart'; 
import '../../../domain/repositories/character_repository.dart';
import 'character_list_event.dart';
import 'character_list_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';


class CharacterListBloc extends Bloc<CharacterListEvent, CharacterListState> {
  final CharacterRepository repository;

  CharacterListBloc({required this.repository}) : super(CharacterListInitial()) {
    on<FetchCharacterList>(_onFetchCharacterList);
  }

  Future<void> _onFetchCharacterList(
    FetchCharacterList event,
    Emitter<CharacterListState> emit,
  ) async {
    emit(CharacterListLoading());
    try {
      final characters = await repository.getCharacters();
      emit(CharacterListLoaded(characters: characters));
    } on ServerException {
      emit(const CharacterListError(message: SERVER_FAILURE_MESSAGE));
    } catch (e) {
      
      emit(CharacterListError(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}
