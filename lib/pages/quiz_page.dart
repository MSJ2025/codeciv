import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  const Question(this.text, this.options, this.correctIndex);
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> _questions = [];

  int _current = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  bool _showResult = false;

  final List<Color> _colors = const [
    Colors.blue,
    Colors.deepPurple,
    Colors.teal,
    Colors.orange,
  ];

  Color get _currentColor => _colors[_current % _colors.length];

  @override
  void initState() {
    super.initState();
    _loadQuestions().then((value) {
      setState(() {
        _questions = value;
      });
    });
  }

  Future<List<Question>> _loadQuestions() async {
    final data = await rootBundle.loadString('assets/quiz_questions.json');
    final List<dynamic> jsonList = json.decode(data) as List<dynamic>;
    return jsonList
        .map((e) => Question(
              e['text'] as String,
              List<String>.from(e['options'] as List),
              e['correctIndex'] as int,
            ))
        .toList();
  }

  void _choose(int index) {
    if (_answered) return;
    setState(() {
      _selected = index;
      _answered = true;
      if (index == _questions[_current].correctIndex) {
        _score++;
      }
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      if (_current < _questions.length - 1) {
        setState(() {
          _current++;
          _selected = null;
          _answered = false;
        });
      } else {
        setState(() {
          _showResult = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_showResult) {
      final int percent = (_score / _questions.length * 100).round();
      Color color;
      String emoji;
      if (percent >= 80) {
        color = Colors.green;
        emoji = '🎉';
      } else if (percent >= 50) {
        color = Colors.orange;
        emoji = '🙂';
      } else {
        color = Colors.red;
        emoji = '😞';
      }
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_currentColor, _currentColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Score : $percent%',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: color),
              ),
              Text(
                emoji,
                style: const TextStyle(fontSize: 64),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_current];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_currentColor, _currentColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: ValueKey(_current),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                question.text,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...List.generate(question.options.length, (index) {
              final isSelected = _selected == index;
              final isCorrect = index == question.correctIndex;
              Color? color;
              if (_answered) {
                if (isCorrect) {
                  color = Colors.green;
                } else if (isSelected) {
                  color = Colors.red;
                }
              }
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: color ?? Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () => _choose(index),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(question.options[index]),
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Question ${_current + 1}/${_questions.length}'),
            ),
          ],
        ),
      ),
    );
  }
}
