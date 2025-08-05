import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? _selected;
  bool _answered = false;

  final String question = "Quel est l'âge de la majorité civile en France ?";
  final List<String> options = ['16 ans', '18 ans', '21 ans'];
  final int correctIndex = 1;

  void _choose(int index) {
    if (_answered) return;
    setState(() {
      _selected = index;
      _answered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            question,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...List.generate(options.length, (index) {
          final isSelected = _selected == index;
          final isCorrect = index == correctIndex;
          Color? color;
          if (_answered) {
            if (isCorrect) {
              color = Colors.green;
            } else if (isSelected) {
              color = Colors.red;
            }
          }
          return ListTile(
            title: Text(options[index]),
            tileColor: color,
            onTap: () => _choose(index),
          );
        })
      ],
    );
  }
}
