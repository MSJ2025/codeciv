import 'package:flutter/material.dart';
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Code Civil'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Recherche'),
              Tab(text: 'Quiz'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SearchPage(),
            QuizPage(),
          ],
        ),
      ),
    );
  }
}
