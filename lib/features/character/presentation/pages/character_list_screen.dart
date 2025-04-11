import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../injection_container.dart';
import '../bloc/list/character_list_bloc.dart';
import '../bloc/list/character_list_event.dart';
import '../bloc/list/character_list_state.dart';
import 'character_detail_screen.dart'; // Import detail screen

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Characters'),
      ),
     
      body: BlocBuilder<CharacterListBloc, CharacterListState>(
        builder: (context, state) {
       

          if (state is CharacterListLoading) {
            return const Center(child: CircularProgressIndicator());
            } else if (state is CharacterListLoaded) {
              return ListView.builder(
                itemCount: state.characters.length,
                itemBuilder: (context, index) {
                  final character = state.characters[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(character.image),
                      radius: 25, 
                    ),
                    title: Text(character.name),
                    subtitle: Text(character.species),
                    onTap: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CharacterDetailScreen(characterId: character.id),
                        ),
                      );
                      // print('Tapped on ${character.name} (ID: ${character.id})'); // Placeholder removed
                    },
                  );
                },
              );
            } else if (state is CharacterListError) {
              return Center(
                child: Text('Failed to load characters: ${state.message}'),
              );
            } else {
              // Initial state or unexpected state
              return const Center(child: Text('Loading characters...'));
            }
          }, 
        ), 
    ); 
  } // 
} // 
