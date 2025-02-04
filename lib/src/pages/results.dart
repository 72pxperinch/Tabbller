import 'package:flutter/material.dart';
import 'package:tabbller/src/functions/common.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';
import 'package:tabbller/src/functions/question.dart';

class ResultsPage extends StatefulWidget {
  final QuestionType type;
  final Difficulty difficulty;
  final int noAttempted;
  final int noCorrect;
  final int timeTaken;
  final List<int>? selectedTables;
  const ResultsPage(
      {required this.type,
      required this.difficulty,
      required this.noAttempted,
      required this.noCorrect,
      required this.timeTaken,
      this.selectedTables,
      super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  void initState() {
    if (FirebaseStorageObjectInterface
            .instance.firebaseStorageObject!.quizHistory.length >=
        QuizHistory.maxHistory) {
      FirebaseStorageObjectInterface.instance.firebaseStorageObject!.quizHistory
          .removeAt(0);
    }
    FirebaseStorageObjectInterface.instance.firebaseStorageObject!.quizHistory.add(
      QuizHistory(
        quizTime: DateTime.now(),
        type: widget.type,
        difficulty: widget.difficulty,
        timeInSeconds: widget.timeTaken,
        correctAnswers: widget.noCorrect,
        totalQuestions: widget.noAttempted,
        selectedTables: widget.selectedTables ?? [],
      )
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
       FirebaseStorageService.instance.updateFirebaseStorageObject(FirebaseUserInterface.instance.docId!, FirebaseStorageObjectInterface.instance.firebaseStorageObject!, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0A2112), // Start color
                Color(0xFF000000), // End color
              ],
              begin: Alignment.topCenter, // Start gradient from the top
              end: Alignment.bottomCenter, // End gradient at the bottom
            ),
          ),
          child: 
            Center(
              child: Stack(children: [
            Positioned(
                top: 0, left: 0, child: SizedBox(width: MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width,
                 child: Image.asset('assets/result.gif')),),
                 SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        size: 120,
                        color: Colors.white,
                      ),
                      const Text(
                        "Well Done!",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 68,
                      ),
                      const Text(
                        "You completed",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFC5C5C5),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${widget.type.heading} (${widget.difficulty.toText})",
                        style: const TextStyle(
                          color: Color(0xFF65C385),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 44),
                      const Text(
                        "Your Score",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFC5C5C5),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "${widget.noCorrect} / ${widget.noAttempted}",
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Time Taken: ${widget.timeTaken ~/ 60}m ${widget.timeTaken % 60}s",
                        style: const TextStyle(
                          color: Color(0xFF65C385),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 44,
                      ),
                      Center(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              width: 160,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white)),
                              child: const Text(
                                "Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            )),
                      ),
                    ],
                  )),
            
          ]))),
    );
  }
}
