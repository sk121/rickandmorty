import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../domain/repositories/character_repository.dart';
import 'character_detail_event.dart';
import 'character_detail_state.dart';


const String SERVER_FAILURE_MESSAGE = 'Server Failure';

class CharacterDetailBloc extends Bloc<CharacterDetailEvent, CharacterDetailState> {
  final CharacterRepository repository;

  CharacterDetailBloc({required this.repository}) : super(CharacterDetailInitial()) {
    on<FetchCharacterDetail>(_onFetchCharacterDetail);
  }

  Future<void> _onFetchCharacterDetail(
    FetchCharacterDetail event,
    Emitter<CharacterDetailState> emit,
  ) async {
    emit(CharacterDetailLoading());
    try {
      final character = await repository.getCharacterDetail(event.id);
      emit(CharacterDetailLoaded(character: character));
    } on ServerException {
      emit(const CharacterDetailError(message: SERVER_FAILURE_MESSAGE));
    } catch (e) {
      emit(CharacterDetailError(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}
