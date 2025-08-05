import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import '../models/article.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  List<Article> _articles = [];
  String _query = '';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Article> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();

    _textController.addListener(() {
      final value = _textController.text;
      setState(() => _query = value);
      if (_focusNode.hasFocus) {
        _updateSuggestions(value);
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadArticles() async {
    final String data = await rootBundle.loadString('assets/code_civil.json');
    final List<dynamic> list = json.decode(data) as List<dynamic>;
    setState(() {
      _articles =
          list.map((e) => Article.fromJson(e as Map<String, dynamic>)).toList();
    });
  }

  Future<void> _updateSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    final suggestions = await Future<List<Article>>(() {
      return _articles
          .where((a) =>
              a.numero.toLowerCase().contains(input.toLowerCase()) ||
              a.titre.toLowerCase().contains(input.toLowerCase()) ||
              a.texte.toLowerCase().contains(input.toLowerCase()))
          .take(5)
          .toList();
    });
    if (mounted) {
      setState(() => _suggestions = suggestions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String q = _query.toLowerCase();
    final List<Article> results = _articles
        .where((a) =>
            a.numero.toLowerCase().contains(q) ||
            a.titre.toLowerCase().contains(q) ||
            a.texte.toLowerCase().contains(q))
        .toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: RawAutocomplete<Article>(
                    textEditingController: _textController,
                    focusNode: _focusNode,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return _suggestions;
                    },
                    displayStringForOption: (Article option) => option.numero,
                    onSelected: (Article selection) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _query = selection.numero;
                        _suggestions = [];
                      });
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '🔍 Rechercher un article...',
                          hintStyle:
                              GoogleFonts.poppins(color: Colors.white70),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                        ),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          color: Colors.white,
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(8),
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxHeight: 240),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final Article option =
                                    options.elementAt(index);
                                return ListTile(
                                  title: Text(option.numero),
                                  onTap: () => onSelected(option),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: results.isEmpty && _query.isNotEmpty
                    ? Center(
                        child: Text(
                          'Aucun article trouvé',
                          style: GoogleFonts.poppins(
                              fontSize: 18, color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: results.length,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final article = results[index];
                          return AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 400),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF4facfe),
                                  Color(0xFF00f2fe)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius:
                                  BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                article.numero,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                article.texte,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Ouverture de ${article.numero}',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor:
                                        Colors.blueAccent,
                                    duration:
                                        const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
