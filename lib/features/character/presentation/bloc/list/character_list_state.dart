import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

abstract class CharacterListState extends Equatable {
  const CharacterListState();

  @override
  List<Object> get props => [];
}

class CharacterListInitial extends CharacterListState {}

class CharacterListLoading extends CharacterListState {}

class CharacterListLoaded extends CharacterListState {
  final List<Character> characters;

  const CharacterListLoaded({required this.characters});

  @override
  List<Object> get props => [characters];
}

class CharacterListError extends CharacterListState {
  final String message;

  const CharacterListError({required this.message});

  @override
  List<Object> get props => [message];
}
