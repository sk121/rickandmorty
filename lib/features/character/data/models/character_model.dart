import '../../domain/entities/character.dart';

class CharacterModel extends Character {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required CharacterLocationModel super.origin, 
    required CharacterLocationModel super.location, 
    required super.image,
    required super.episode,
    required super.url,
    required super.created,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      origin: CharacterLocationModel.fromJson(json['origin']),
      location: CharacterLocationModel.fromJson(json['location']),
      image: json['image'],
      episode: List<String>.from(json['episode']),
      url: json['url'],
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': (origin as CharacterLocationModel).toJson(),
      'location': (location as CharacterLocationModel).toJson(),
      'image': image,
      'episode': episode,
      'url': url,
      'created': created.toIso8601String(),
    };
  }
}


class CharacterLocationModel extends CharacterLocation {
  const CharacterLocationModel({
    required super.name,
    required super.url,
  });

  factory CharacterLocationModel.fromJson(Map<String, dynamic> json) {
    return CharacterLocationModel(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}
