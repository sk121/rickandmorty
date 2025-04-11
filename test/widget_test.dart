// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart'; 
import 'package:mocktail/mocktail.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart'; 


import 'package:rick_and_morty_app/features/character/presentation/pages/character_list_screen.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/list/character_list_bloc.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/list/character_list_state.dart';
import 'package:rick_and_morty_app/injection_container.dart' as di; 

import 'features/character/mocks/mock_character_list_bloc.dart';

import 'package:http/http.dart' as http;
class MockHttpClient extends Mock implements http.Client {}


void main() {
  final sl = GetIt.instance;
  late MockCharacterListBloc mockCharacterListBloc;

  
  setUpAll(() async {
    
    sl.reset();
    
    await di.init();
    sl.allowReassignment = true; 
    
    sl.registerLazySingleton<http.Client>(() => MockHttpClient());
    await sl.allReady(); 
  });

  // Setup runs before EACH test
  setUp(() {
      
      mockCharacterListBloc = MockCharacterListBloc();
      
      when(() => mockCharacterListBloc.state).thenReturn(CharacterListInitial());
     
      when(() => mockCharacterListBloc.stream).thenAnswer((_) => Stream.value(CharacterListInitial()));
  });

   tearDown(() {
    mockCharacterListBloc.close(); 
  });


  testWidgets('App loads and displays list screen title and initial state', (WidgetTester tester) async {
   
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CharacterListBloc>.value(
          value: mockCharacterListBloc, 
          child: const CharacterListScreen(), // The screen under test
        ),
      ),
    );

    // --- Assert ---
    // Verify AppBar title
    expect(find.text('Rick and Morty Characters'), findsOneWidget);

    // Verify initial state text is shown because we stubbed the state
    expect(find.text('Loading characters...'), findsOneWidget);

    // Verify loading indicator is NOT shown
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Displays loading indicator when state is loading', (WidgetTester tester) async {
    // Arrange
    // Stub the state and stream for the loading case
    when(() => mockCharacterListBloc.state).thenReturn(CharacterListLoading());
    when(() => mockCharacterListBloc.stream).thenAnswer((_) => Stream.value(CharacterListLoading()));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CharacterListBloc>.value(
          value: mockCharacterListBloc,
          child: const CharacterListScreen(),
        ),
      ),
    );
     
     await tester.pump();

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

   
   testWidgets('Displays error message when state is error', (WidgetTester tester) async {
    // Arrange
    const errorMessage = 'Failed to load';
    when(() => mockCharacterListBloc.state).thenReturn(const CharacterListError(message: errorMessage));
    when(() => mockCharacterListBloc.stream).thenAnswer((_) => Stream.value(const CharacterListError(message: errorMessage)));

    
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CharacterListBloc>.value(
          value: mockCharacterListBloc,
          child: const CharacterListScreen(),
        ),
      ),
    );
     await tester.pump();

    // Assert
    expect(find.text('Failed to load characters: $errorMessage'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

}
