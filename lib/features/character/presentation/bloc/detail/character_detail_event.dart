import 'package:equatable/equatable.dart';

abstract class CharacterDetailEvent extends Equatable {
  const CharacterDetailEvent();

  @override
  List<Object> get props => [];
}


class FetchCharacterDetail extends CharacterDetailEvent {
  final int id;

  const FetchCharacterDetail({required this.id});

  @override
  List<Object> get props => [id];
}
