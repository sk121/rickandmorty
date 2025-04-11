import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart'; 
import '../models/character_model.dart';
import 'character_remote_data_source.dart';

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final http.Client client;
  final String _baseUrl = 'https://rickandmortyapi.com/api';

  CharacterRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CharacterModel>> getCharacters() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/character'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => CharacterModel.fromJson(json)).toList();
    } else {
      throw ServerException(); 
    }
  }

  @override
  Future<CharacterModel> getCharacterDetail(int id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/character/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return CharacterModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(); 
    }
  }
}
