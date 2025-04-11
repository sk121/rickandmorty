import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

abstract class CharacterDetailState extends Equatable {
  const CharacterDetailState();

  @override
  List<Object> get props => [];
}

class CharacterDetailInitial extends CharacterDetailState {}

class CharacterDetailLoading extends CharacterDetailState {}

class CharacterDetailLoaded extends CharacterDetailState {
  final Character character; 

  const CharacterDetailLoaded({required this.character});

  @override
  List<Object> get props => [character];
}

class CharacterDetailError extends CharacterDetailState {
  final String message;

  const CharacterDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
