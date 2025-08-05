import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/article.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Article> _articles = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    final String data = await rootBundle.loadString('assets/articles.json');
    final List<dynamic> list = json.decode(data) as List<dynamic>;
    setState(() {
      _articles = list.map((e) => Article.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Article> results = _articles
        .where((a) =>
            a.id.toLowerCase().contains(_query.toLowerCase()) ||
            a.texte.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Rechercher un article...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final article = results[index];
              return ListTile(
                title: Text(article.id),
                subtitle: Text(article.texte),
              );
            },
          ),
        ),
      ],
    );
  }
}
