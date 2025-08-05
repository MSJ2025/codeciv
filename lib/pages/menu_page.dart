import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'search_page.dart';
import 'quiz_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<dynamic> _articles = [];
  Map<String, dynamic>? _current;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    final data = await rootBundle.loadString('assets/code_civil.json');
    final List<dynamic> list = json.decode(data) as List<dynamic>;
    setState(() {
      _articles = list;
      _current = _pickRandom();
    });
  }

  Map<String, dynamic>? _pickRandom() {
    if (_articles.isEmpty) return null;
    final index = Random().nextInt(_articles.length);
    return _articles[index] as Map<String, dynamic>;
  }

  void _refresh() {
    setState(() {
      _current = _pickRandom();
    });
  }

  void _goToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchPage()),
    );
  }

  void _goToQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QuizPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = _current;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Nouvel article',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (article != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['numero'] as String? ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      if ((article['titre'] as String?)?.isNotEmpty ?? false)
                        Text(
                          article['titre'] as String,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        article['texte'] as String? ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                )
              else
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: _goToSearch,
                  icon: const Icon(Icons.search),
                  label: const Text('Recherche'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: _goToQuiz,
                  icon: const Icon(Icons.quiz),
                  label: const Text('Quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

