import 'package:equatable/equatable.dart';

abstract class CharacterListEvent extends Equatable {
  const CharacterListEvent();

  @override
  List<Object> get props => [];
}

/// Event to trigger fetching the character list.
class FetchCharacterList extends CharacterListEvent {}
