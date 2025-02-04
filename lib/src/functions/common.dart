import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tabbller/src/functions/question.dart';


enum Direction {
  forward,
  reverse,
}

class QuizHistory {
  final DateTime quizTime;
  final QuestionType type;
  final Difficulty difficulty;
  final int timeInSeconds;
  final int correctAnswers;
  final int totalQuestions;
  final List<int>? selectedTables;
  static const maxHistory = 15;

  QuizHistory(
      {required this.quizTime,
      required this.type,
      required this.difficulty,
      required this.timeInSeconds,
      required this.correctAnswers,
      required this.totalQuestions,
      this.selectedTables});

    Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'quizTime': quizTime, 
      'difficulty': difficulty.name,
      'timeInSeconds': timeInSeconds,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'selectedTables': selectedTables,
    };
  }

  static QuizHistory fromMap(Map<String, dynamic> map) {
    return QuizHistory(
      type: QuestionTypeExtension.fromName(map['type']),
      quizTime: map['quizTime'].toDate(),
      difficulty: DifficultyExtension.fromName(map['difficulty']),
      timeInSeconds: map['timeInSeconds'] as int,
      correctAnswers: map['correctAnswers'] as int,
      totalQuestions: map['totalQuestions'] as int,
      selectedTables: map['selectedTables'] != [] 
        ? (map['selectedTables']  as List)
          .map((item) => item as int)
          .toList()
        : []
    );
  }
}

Map<int, Color> colorMap = {
  0: Colors.black.withOpacity(0.6),
  1: const Color(0xFFDC4646),
  2: const Color(0xFFD57D43),
  3: const Color(0xFFD5B543),
  4: const Color(0xFF89B941),
  5: const Color(0xFF137D39),
};