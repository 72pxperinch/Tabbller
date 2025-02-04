import 'dart:math';

import 'package:tabbller/src/functions/data.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';

class TableSize {
  int x;
  int y;

  TableSize({
    required this.x,
    required this.y,
  });
}

enum QuestionType{
  multiplication,
  square,
  cube,
  power,
  primeNo,
}

extension QuestionTypeExtension on QuestionType {
  // String get operator {
  //   switch(this) {
  //     case QuestionType.cube: return '^3';
  //     case QuestionType.multiplication: return '*';
  //     case QuestionType.square: return '^2';
  //     case QuestionType.primeNo: return '';
  //     case QuestionType.power: return '^3';
  //   }
  // }
  String get heading {
    switch(this) {
      case QuestionType.cube: return 'Cubes Quiz';
      case QuestionType.multiplication: return 'Multiplication Table Quiz';
      case QuestionType.square: return 'Squares Quiz';
      case QuestionType.primeNo: return 'Prime Numbers Quiz';
      case QuestionType.power: return 'Powers Quiz';
    }
  }
  TableSize get tableSize {
    switch(this) {
      case QuestionType.cube: return TableSize(x: 5, y: 4);
      case QuestionType.multiplication: return TableSize(x: 25, y: 25);
      case QuestionType.square: return TableSize(x: 5, y: 10);
      case QuestionType.primeNo: return TableSize(x: 5, y: 10);
      case QuestionType.power: return TableSize(x: 5, y: 4);
    }
  }
  int get intVal {
    switch(this) {
      case QuestionType.cube: return 2;
      case QuestionType.multiplication: return 0;
      case QuestionType.square: return 1;
      case QuestionType.primeNo: return 4;
      case QuestionType.power: return 3;
    }
  }

  static QuestionType fromName(String name) {
    return QuestionType.values.firstWhere((e) => e.name == name); 
  }
}

enum Difficulty {
  easy,
  medium,
  hard,
}

extension DifficultyExtension on Difficulty {
  int get nofOptions {
    switch(this) {
      case Difficulty.easy: return 4;
      case Difficulty.medium: return 6;
      case Difficulty.hard: return 0;
    }
  }
  int get timeVal {
    switch(this) {
      case Difficulty.easy: return 20;
      case Difficulty.medium: return 10;
      case Difficulty.hard: return 6;
    }
  }
  int get optionsRange {
    switch(this) {
      case Difficulty.easy: return 20;
      case Difficulty.medium: return 8;
      case Difficulty.hard: return 0;
    }
  }
  String get toText{
    switch(this) {
      case Difficulty.easy: return "Easy";
      case Difficulty.medium: return "Medium";
      case Difficulty.hard: return "Hard";
    }
  }
  Level get maxLevel{
    switch(this) {
      case Difficulty.easy: return Level.level2;
      case Difficulty.medium: return Level.level4;
      case Difficulty.hard: return Level.level5;
    }
  }
  static Difficulty fromName(String name) {
    return Difficulty.values.firstWhere((e) => e.name == name); 
  }
}

enum QuestionRange {
  fives,
  tens,
  fifteens,
  twenties,
  twentyfives,
}

extension QuestionRangeExtension on QuestionRange {
  int get intVal {
    switch(this) {
      case QuestionRange.fives: return 5;
      case QuestionRange.tens: return 10;
      case QuestionRange.fifteens: return 15;
      case QuestionRange.twenties: return 20;
      case QuestionRange.twentyfives: return 25;
    }
  }
}

class Question {
  QuestionType type;
  int? numA;
  int? numB;
  List<int>? numC;
  List<int> options;
  Difficulty difficulty;
  int time;
  List<int> solution;
  Level? level;


  Question({
    required this.type,
    this.numA,
    this.numB,
    this.numC,
    required this.options,
    required this.difficulty,
    required this.time,
    required this.solution,
    required this.level,
  });

  static Question makeQuestion(
    QuestionType type,
    QuestionRange range,
    Difficulty difficulty,
    [List<int>? selectedTables,]
  ) {
    if(type == QuestionType.multiplication && selectedTables == []) {
      throw(ArgumentError('selectedTables required when type is multiplication'));
    }
    switch(type){
      case QuestionType.multiplication:
        int numA = selectedTables![Random().nextInt(selectedTables.length)] ;
        int numB = Random().nextInt(25) + 1; 
        Level level = FirebaseStorageObjectInterface.instance.firebaseStorageObject!.learningProgresses[type.intVal]
          .levelData[numA-1][numB-1];
        return Question(
          type: QuestionType.multiplication, 
          numA: numA,
          numB: numB,
          options: optionGenerator(noOptions: difficulty.nofOptions, solution: [numA * numB], difficulty: difficulty),
          difficulty: difficulty,
          time: difficulty.timeVal,
          solution: [numA * numB],
          level: level,
        );
      case QuestionType.square:
        int numA = Random().nextInt(10) + range.intVal * 2 - 10 + 1;
        Level level = FirebaseStorageObjectInterface.instance.firebaseStorageObject!.learningProgresses[type.intVal]
          .levelData[(numA-1)~/type.tableSize.x][(numA-1)%type.tableSize.x];
        return Question(
          type: QuestionType.square, 
          numA: numA,
          options: optionGenerator(noOptions: difficulty.nofOptions, solution: [numA * numA], difficulty: difficulty),
          difficulty: difficulty,
          time: difficulty.timeVal,
          solution: [numA * numA],
          level: level,
        );
      case QuestionType.cube:
        int numA = Random().nextInt(5) + range.intVal - 5 + 1;
        Level level = FirebaseStorageObjectInterface.instance.firebaseStorageObject!.learningProgresses[type.intVal]
          .levelData[(numA-1)~/type.tableSize.x][(numA-1)%type.tableSize.x];
        return Question(
          type: QuestionType.cube, 
          numA: numA,
          options: optionGenerator(noOptions: difficulty.nofOptions, solution: [numA * numA * numA], difficulty: difficulty),
          difficulty: difficulty,
          time: difficulty.timeVal,
          solution: [numA * numA * numA],
          level: level,
        );
      case QuestionType.power:
        int qno = Random().nextInt(power1.length);
        int numA = power1[qno];
        int numB = power2[qno];
        Level level = FirebaseStorageObjectInterface.instance.firebaseStorageObject!.learningProgresses[type.intVal]
          .levelData[(qno-1)~/type.tableSize.x][(qno-1)%type.tableSize.x];
        return Question(
          type: QuestionType.power,
          numA: numA,
          numB: numB,
          options: optionGenerator(noOptions: difficulty.nofOptions, solution: [pow(numB, numA).toInt()], difficulty: difficulty), 
          difficulty: difficulty,
          time: difficulty.timeVal, 
          solution: [pow(numB, numA).toInt()],
          level: level,
        );

      case QuestionType.primeNo:
        if(difficulty == Difficulty.hard){
          final int noOfCorrectAnswers = Random().nextInt(3) + 2;
          Set<int> numC = {};
          do {
            numC.add(primeNumbers[Random().nextInt(primeNumbers.length)]);
          } while(numC.length < noOfCorrectAnswers);
          List<int> solution = numC.toList();
          List<int> options = optionGeneratorPrime(noOptions: 6, solution: solution, difficulty: difficulty);
          return Question(
            type: QuestionType.primeNo,
            numC: solution,
            options: options, 
            difficulty: difficulty,
            time: difficulty.timeVal, 
            solution: solution,
            level: null,
          );
        } else if(difficulty == Difficulty.medium){
          int numA = primeNumbers[Random().nextInt(primeNumbers.length)];
          return Question(
            type: QuestionType.primeNo,
            numA: numA,
            options: optionGeneratorPrime(noOptions: 4, solution: [numA], difficulty: difficulty), 
            difficulty: difficulty,
            time: difficulty.timeVal, 
            solution: [numA],
            level: null,
          );
        } else {
          int numA = primeBar[Random().nextInt(primeBar.length)];;
          return Question(
            type: QuestionType.primeNo,
            numA: numA,
            options: [1,0], 
            difficulty: difficulty,
            time: difficulty.timeVal, 
            solution: primeNumbers.contains(numA) ? [1] : [0],
            level: null,
          );
        }
    }
  }
}

List<int> optionGenerator({required int noOptions, required List<int> solution, required Difficulty difficulty}){
  if(difficulty == Difficulty.hard) { return []; }
  int lowerBound = solution.first - difficulty.optionsRange * 10> 0 ? solution.first - difficulty.optionsRange * 10 : solution.first % 10;
  int upperBound = solution.first + difficulty.optionsRange * 10;
  if (upperBound - lowerBound + 1 < noOptions) {
    throw Exception('Range is too small to generate the requested number of unique items.');
  }
  Set<int> uniqueIntegers = {};
  for(int sol in solution) {
    uniqueIntegers.add(sol);
  }

  while (uniqueIntegers.length < noOptions) {
    int randomNumber = lowerBound + 10 * Random().nextInt((upperBound - lowerBound + 1) ~/ 10);
    uniqueIntegers.add(randomNumber);
  }
  List<int> uniqueIntegersList = uniqueIntegers.toList();
  uniqueIntegersList.shuffle();

  return uniqueIntegersList;
}

List<int> optionGeneratorPrime({required int noOptions, required List<int> solution, required Difficulty difficulty}){
  Set<int> uniqueIntegers = {};
  for(int sol in solution) {
    uniqueIntegers.add(sol);
  }

  while (uniqueIntegers.length < noOptions) {
    int randomNumber = primeBar[Random().nextInt(primeBar.length)];
    if(!primeNumbers.contains(randomNumber)) uniqueIntegers.add(randomNumber);
  }
  List<int> uniqueIntegersList = uniqueIntegers.toList();
  uniqueIntegersList.shuffle();

  return uniqueIntegersList;
}




// class Quiz {
//   List<Question> questions;
//   QuestionType type;
//   Difficulty difficulty;


//   Quiz({
//     List<Question>? questions,
//     required this.type,
//     required this.difficulty,
//   }) : 
//   questions = questions ?? [];

//   void addQuestion(){
    
//   }
// }


