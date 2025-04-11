import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../injection_container.dart';
import '../bloc/detail/character_detail_bloc.dart';
import '../bloc/detail/character_detail_event.dart';
import '../bloc/detail/character_detail_state.dart';
import '../../domain/entities/character.dart'; 

class CharacterDetailScreen extends StatelessWidget {
  final int characterId;

  const CharacterDetailScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CharacterDetailBloc>()..add(FetchCharacterDetail(id: characterId)),
      child: BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state is CharacterDetailLoaded ? state.character.name : 'Loading...'),
              
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, CharacterDetailState state) {
    if (state is CharacterDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CharacterDetailLoaded) {
      final character = state.character;
      return SingleChildScrollView( // Allow scrolling for long content
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: CachedNetworkImageProvider(character.image),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailItem('Name', character.name),
            _buildDetailItem('Status', character.status),
            _buildDetailItem('Species', character.species),
            if (character.type.isNotEmpty) _buildDetailItem('Type', character.type),
            _buildDetailItem('Gender', character.gender),
            _buildDetailItem('Origin', character.origin.name),
            _buildDetailItem('Last Known Location', character.location.name),
            const SizedBox(height: 10),
            Text(
              'Episodes (${character.episode.length}):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 5),
            
            Text(
              character.episode.take(5).map((e) => e.split('/').last).join(', ') +
              (character.episode.length > 5 ? ', ...' : ''),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
             _buildDetailItem('Created', character.created.toLocal().toString().split(' ')[0]), 
          ],
        ),
      );
    } else if (state is CharacterDetailError) {
      return Center(
        child: Text('Failed to load character details: ${state.message}'),
      );
    } else {
      return const Center(child: Text('Loading details...'));
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black87), // Default text style
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
