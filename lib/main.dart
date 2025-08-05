import 'package:flutter/material.dart';
import 'pages/menu_page.dart';
import 'pages/search_page.dart';
import 'pages/quiz_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Révision Code Civil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/search': (_) => const SearchPage(),
        '/quiz': (_) => const QuizPage(),
      },
      home: const MenuPage(),
    );
  }
}
