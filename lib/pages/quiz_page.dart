import 'package:flutter/material.dart';

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
  final List<Question> _questions = const [
    Question(
      "Quel est l'âge de la majorité civile en France ?",
      ['16 ans', '18 ans', '21 ans'],
      1,
    ),
    Question(
      "Combien d'articles composait le Code civil en 1804 ?",
      ['36', '228', '2281'],
      2,
    ),
  ];

  int _current = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  bool _showResult = false;

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
      return Center(
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
      );
    }

    final question = _questions[_current];
    return AnimatedSwitcher(
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }
}
