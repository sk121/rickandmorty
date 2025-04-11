import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'features/character/presentation/pages/character_list_screen.dart'; 
import 'features/character/presentation/bloc/list/character_list_bloc.dart'; 
import 'features/character/presentation/bloc/list/character_list_event.dart'; 
import 'injection_container.dart' as di; 
import 'injection_container.dart'; 

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
  await di.init(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App', 
      theme: ThemeData(  
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => sl<CharacterListBloc>()..add(FetchCharacterList()), 
        child: const CharacterListScreen(), 
      ),
    );
  }
}
