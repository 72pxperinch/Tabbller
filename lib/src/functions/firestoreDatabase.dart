import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tabbller/src/functions/common.dart';
import 'package:tabbller/src/functions/data.dart';
import 'package:tabbller/src/functions/question.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tabbller/src/pages/noInternet.dart';

enum Level {
  level0,
  level1,
  level2,
  level3,
  level4,
  level5,
}

extension LevelExtension on Level {
  int get intVal {
    switch (this) {
      case Level.level0:
        return 0;
      case Level.level1:
        return 1;
      case Level.level2:
        return 2;
      case Level.level3:
        return 3;
      case Level.level4:
        return 4;
      case Level.level5:
        return 5;
    }
  }

  Level nextLevel(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        switch (this) {
          case Level.level0:
            return Level.level2;
          case Level.level1:
            return Level.level2;
          case Level.level2:
            return Level.level2;
          case Level.level3:
            return Level.level3;
          case Level.level4:
            return Level.level4;
          case Level.level5:
            return Level.level5;
        }
      case Difficulty.medium:
        switch (this) {
          case Level.level0:
            return Level.level2;
          case Level.level1:
            return Level.level2;
          case Level.level2:
            return Level.level3;
          case Level.level3:
            return Level.level4;
          case Level.level4:
            return Level.level4;
          case Level.level5:
            return Level.level5;
        }
      case Difficulty.hard:
        switch (this) {
          case Level.level0:
            return Level.level4;
          case Level.level1:
            return Level.level4;
          case Level.level2:
            return Level.level4;
          case Level.level3:
            return Level.level4;
          case Level.level4:
            return Level.level5;
          case Level.level5:
            return Level.level5;
        }
    }
  }
}

// class PrevResults {
//   QuestionType type;
//   List<int> easy;
//   List<int> medium;
//   List<int> hard;

//   PrevResults({
//     required this.type,
//     List<int>? easyPlaceholder,
//     List<int>? mediumPlaceholder,
//     List<int>? hardPlaceholder,
//   })
//   : easy = easyPlaceholder ?? [],
//     medium = mediumPlaceholder ?? [],
//     hard = hardPlaceholder ?? [];

//   Map<String, dynamic> toMap() {
//     return {
//       'type': type.name,
//       'easy': easy,
//       'medium': medium,
//       'hard': hard,
//     };
//   }

//   static PrevResults fromMap(Map<String, dynamic> map) {
//     return PrevResults(
//       type: QuestionTypeExtension.fromName(map['type']),
//       easyPlaceholder: List<int>.from(map['easy']),
//       mediumPlaceholder: List<int>.from(map['medium']),
//       hardPlaceholder: List<int>.from(map['hard']),
//     );
//   }
// }

class LearningProgress {
  QuestionType type;
  List<List<Level>> levelData;

  LearningProgress({
    required this.type,
    List<List<Level>>? levelDataPlaceholder,
  }) : levelData = levelDataPlaceholder ??
            List.generate(type.tableSize.y, (index) {
              return List.generate(type.tableSize.x, (index) {
                return Level.level0;
              });
            });

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'levelData': levelData.expand((list) {
        return list.map((level) => level.name).toList();
      }).toList(),
    };
  }

  dynamic toMapTablePage() {
    if (type == QuestionType.multiplication) {
      return Map<String, int>.fromIterables(
          List.generate(type.tableSize.x * type.tableSize.y, (index) {
            return "${index ~/ type.tableSize.x + 1}*${index % type.tableSize.x + 1}";
          }),
          List.generate(type.tableSize.x * type.tableSize.y, (index) {
            return levelData[index ~/ type.tableSize.x]
                    [index % type.tableSize.x]
                .intVal;
          }));
    } else {
      return List.generate(type.tableSize.x * type.tableSize.y, (index) {
        return levelData[index ~/ type.tableSize.x][index % type.tableSize.x]
            .intVal;
      });
    }
  }

  static LearningProgress fromMap(Map<String, dynamic> map) {
    QuestionType type = QuestionTypeExtension.fromName(map['type']);
    List levelDataAsAList = (map['levelData'] as List);
    List<List<Level>> levelDataPlaceholder =
        List.generate(type.tableSize.y, (indexRow) {
      return List.generate(type.tableSize.x, (indexCol) {
        return Level.values.firstWhere((value) =>
            value.name ==
            levelDataAsAList[indexRow * type.tableSize.x + indexCol]);
      });
    });
    return LearningProgress(
        type: type, levelDataPlaceholder: levelDataPlaceholder);
  }

  void changeProgress(Question question, bool correct, [int? answer]) {
    if (correct) {
      if (question.type == QuestionType.multiplication) {
        levelData[question.numA! - 1][question.numB! - 1] =
            question.level!.nextLevel(question.difficulty);
        levelData[question.numB! - 1][question.numA! - 1] =
            question.level!.nextLevel(question.difficulty);
      } else if (question.type == QuestionType.power) {
        final int qno = power3.indexOf(question.solution.first);
        levelData[(qno) ~/ question.type.tableSize.x]
                [(qno) % question.type.tableSize.x] =
            question.level!.nextLevel(question.difficulty);
      } else if (question.type == QuestionType.primeNo) {
        int? primeBarIndex;
        if (question.difficulty == Difficulty.hard) {
          primeBarIndex = primeBar.indexOf(answer!);
        } else if (question.difficulty == Difficulty.easy) {
          if (question.solution.contains(0)) return;
          primeBarIndex = primeBar.indexOf(question.numA!);
        } else {
          primeBarIndex = primeBar.indexOf(question.solution.first);
        }
        levelData[primeBarIndex ~/ question.type.tableSize.x]
                [primeBarIndex % question.type.tableSize.x] =
            levelData[primeBarIndex ~/ question.type.tableSize.x]
                    [primeBarIndex % question.type.tableSize.x]
                .nextLevel(question.difficulty);
      } else {
        levelData[(question.numA! - 1) ~/ question.type.tableSize.x]
                [(question.numA! - 1) % question.type.tableSize.x] =
            question.level!.nextLevel(question.difficulty);
      }
    } else {
      if (question.type == QuestionType.multiplication) {
        levelData[question.numA! - 1][question.numB! - 1] = Level.level1;
        levelData[question.numB! - 1][question.numA! - 1] = Level.level1;
      } else if (question.type == QuestionType.power) {
        final int qno = power3.indexOf(question.solution.first);
        levelData[(qno) ~/ question.type.tableSize.x]
            [(qno) % question.type.tableSize.x] = Level.level1;
      } else if (question.type == QuestionType.primeNo) {
        int? primeBarIndex;
        if (question.difficulty == Difficulty.hard) {
          primeBarIndex = primeBar.indexOf(answer!);
        } else if (question.difficulty == Difficulty.easy) {
          if (question.solution.contains(0)) return;
          primeBarIndex = primeBar.indexOf(question.numA!);
        } else {
          primeBarIndex = primeBar.indexOf(question.solution.first);
        }
        levelData[primeBarIndex ~/ question.type.tableSize.x]
            [primeBarIndex % question.type.tableSize.x] = Level.level1;
      } else {
        levelData[(question.numA! - 1) ~/ question.type.tableSize.x]
            [(question.numA! - 1) % question.type.tableSize.x] = Level.level1;
      }
    }
  }
}

class FirebaseStorageObject {
  String userID;
  String? userName;
  String? phoneNumber;
  String? emailID;
  int? timeInAppInSecs;
  bool? showWalkthrough;
  List<QuizHistory> quizHistory;
  List<LearningProgress> learningProgresses;

  FirebaseStorageObject({
    required this.userID,
    this.userName,
    this.emailID,
    this.phoneNumber,
    this.timeInAppInSecs,
    this.showWalkthrough,
    List<QuizHistory>? quizHistoryPlaceholder,
    List<LearningProgress>? learningProgressesPlaceholder,
  })  : quizHistory = quizHistoryPlaceholder ?? [],
        learningProgresses = learningProgressesPlaceholder ??
            List.generate(5, (index) {
              return LearningProgress(type: QuestionType.values[index]);
            });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      'emailID': emailID,
      'phoneNumber': phoneNumber,
      'timeInAppInSecs': timeInAppInSecs,
      'showWalkthrough': showWalkthrough,
      'prevResults':
          quizHistory.map((quizHistory) => quizHistory.toMap()).toList(),
      'learningProgresses': learningProgresses
          .map((learningProgress) => learningProgress.toMap())
          .toList(),
    };
  }

  static FirebaseStorageObject fromMap(Map<String, dynamic> map) {
    return FirebaseStorageObject(
      userID: map['userID'],
      userName: map['userName'],
      emailID: map['emailID'],
      phoneNumber: map['phoneNumber'],
      timeInAppInSecs: map['timeInAppInSecs'],
      showWalkthrough: map['showWalkthrough'],
      quizHistoryPlaceholder: (map['prevResults'] as List)
          .map((e) => QuizHistory.fromMap(e as Map<String, dynamic>))
          .toList(),
      learningProgressesPlaceholder: (map['learningProgresses'] as List)
          .map((e) => LearningProgress.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FirebaseStorageObjectInterface {
  FirebaseStorageObjectInterface._privateConstructor();

  static final FirebaseStorageObjectInterface _instance =
      FirebaseStorageObjectInterface._privateConstructor();

  static FirebaseStorageObjectInterface get instance => _instance;

  FirebaseStorageObject? firebaseStorageObject;
}

class FirebaseStorageService {
  // Step 1: Create a private constructor
  FirebaseStorageService._privateConstructor();

  // Step 2: Provide a static instance of the class
  static final FirebaseStorageService _instance =
      FirebaseStorageService._privateConstructor();

  // Step 3: Provide a getter to access the instance
  static FirebaseStorageService get instance => _instance;

  // Firebase Firestore instance (singleton)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new FirebaseStorageObject
  Future<DocumentReference?> addFirebaseStorageObject(
      FirebaseStorageObject storageObject, BuildContext context) async {
    try {
      checkInternet(context);
      return await _firestore.collection('Users').add(storageObject.toMap());
    } catch (e) {
      // throw(e);
      return null;
    }
  }

  // Read FirebaseStorageObject by userID
  Future<FirebaseStorageObject?> readFirebaseStorageObject(
      String userID, BuildContext context) async {
    try {
      checkInternet(context);
      final snapshot = await _firestore
          .collection('Users')
          .where('userID', isEqualTo: userID)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming we only want the first document that matches the userID
        return FirebaseStorageObject.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error reading storage object: $e');
      return null;
    }
  }

  // Update a FirebaseStorageObject
  Future<void> updateFirebaseStorageObject(
      String docId, FirebaseStorageObject storageObject, BuildContext context) async {
    try {
      checkInternet(context);
      await _firestore
          .collection('Users')
          .doc(docId)
          .update(storageObject.toMap());
      print('Storage object updated successfully');
    } catch (e) {
      print('Error updating storage object: $e');
    }
  }

  // Delete a FirebaseStorageObject
  Future<void> deleteFirebaseStorageObject(String docId, BuildContext context) async {
    try {
      checkInternet(context);
      await _firestore.collection('Users').doc(docId).delete();
      print('Storage object deleted successfully');
    } catch (e) {
      print('Error deleting storage object: $e');
    }
  }

  static Future<void> checkInternet(BuildContext context) async {
    do {
      final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
      if (!connectivityResult.contains(ConnectivityResult.mobile) && !connectivityResult.contains(ConnectivityResult.wifi)) {
        await Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => 
            const NoInternetPage()
          )
        );
        await Future.delayed(const Duration(seconds: 1));
      } else {
        break;
      }
    } while (true);
  }
}

class FirebaseUserInterface {
  FirebaseUserInterface._privateConstructor();

  static final FirebaseUserInterface _instance =
      FirebaseUserInterface._privateConstructor();

  static FirebaseUserInterface get instance => _instance;

  User? userData;
  String? docId;
  String? userName;
}

Future<String?> getDocIdFromUserID(String userID) async {
  try {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Users');
    // Query using the userName field (which holds the phone number)
    QuerySnapshot querySnapshot =
        await collectionRef.where('userID', isEqualTo: userID).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      print("No document found for the username (phone number): $userID");
      return null;
    }
  } catch (e) {
    print("Error retrieving document ID: $e");
    return null;
  }
}