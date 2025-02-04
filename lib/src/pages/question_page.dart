import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tabbller/src/components/warning.dart';
import 'package:tabbller/src/functions/common.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';
import 'package:tabbller/src/functions/question.dart';
import 'package:tabbller/src/pages/results.dart';

class ContainerKeys {
  final int qno;
  final bool answerSelected;

  ContainerKeys({required this.qno, required this.answerSelected});
}

class QuestionPage extends StatefulWidget {
  final QuestionType type;
  final Difficulty difficulty;
  final List<int>? selectedTables;
  const QuestionPage(
      {required this.type,
      required this.difficulty,
      this.selectedTables,
      super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int qno = 0;
  int attemptedQno = 0;
  int correctAnswers = 0;
  late Timer timer;
  late int time;
  late Question question;
  bool answerSelected = false;
  List<int> selectedAnswerIndex = [];
  int timeTaken = 0;
  int? inputNumber;
  // int noOfCorrectAnswered = 0;
  bool dialogueOpen = false;
  bool _isPressed = false;

  final TextEditingController _controller = TextEditingController();

  final GlobalKey<_ShakeAnimationState> shakeKey =
      GlobalKey<_ShakeAnimationState>();

  @override
  void initState() {
    time = widget.difficulty.timeVal;
    question = Question.makeQuestion(
      widget.type,
      QuestionRange
          .values[Random().nextInt(widget.type == QuestionType.cube ? 4 : 5)],
      widget.difficulty,
      widget.type == QuestionType.multiplication ? widget.selectedTables : [],
    );
    if (widget.type == QuestionType.multiplication &&
        widget.selectedTables == []) {
      throw (ArgumentError(
          'selectedTables required when type is multiplication'));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (qno == 0) {
        showDialogTimer(context);
      }
    });
    super.initState();
  }

  Future<void> showDialogTimer(BuildContext context) async {
    await quizTimer(context);
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (!mounted) return;
        if (time == 0) {
          setState(() {
            answerSelected = true;
            attemptedQno = attemptedQno + 1;
            if (question.type == QuestionType.primeNo &&
                question.difficulty == Difficulty.hard) {
              primeHardLevelChange();
            } else if (question.difficulty == Difficulty.hard) {
              if (question.solution.contains(_controller.value.text == ""
                  ? -1
                  : int.parse(_controller.value.text))) {
                correctAnswers = correctAnswers + 1;
                FirebaseStorageObjectInterface.instance.firebaseStorageObject!
                    .learningProgresses[question.type.intVal]
                    .changeProgress(question, true);
              } else {
                FirebaseStorageObjectInterface.instance.firebaseStorageObject!
                    .learningProgresses[question.type.intVal]
                    .changeProgress(question, false);
              }
            } else {
              FirebaseStorageObjectInterface.instance.firebaseStorageObject!
                  .learningProgresses[question.type.intVal]
                  .changeProgress(question, false);
            }
            nextQuestion();
          });
        } else {
          setState(() {
            time--;
          });
        }
      },
    );
  }

  void primeHardLevelChange() {
    Set<int> answers =
        Set.from(selectedAnswerIndex.map((index) => question.options[index]));
    if (setEquals(answers, question.solution.toSet())) {
      // SystemSound.play(SystemSoundType.click);
      correctAnswers = correctAnswers + 1;
    } else {
      // HapticFeedback.lightImpact();
    }
    for (int answer in question.solution) {
      if (answers.contains(answer)) {
        FirebaseStorageObjectInterface
            .instance.firebaseStorageObject!.learningProgresses[4]
            .changeProgress(question, true, answer);
      } else {
        FirebaseStorageObjectInterface
            .instance.firebaseStorageObject!.learningProgresses[4]
            .changeProgress(question, false, answer);
      }
    }
  }

  void nextQuestion() {
    timeTaken = timeTaken + widget.difficulty.timeVal - time;
    timer.cancel();
    Question newQuestion = Question.makeQuestion(
        widget.type,
        QuestionRange
            .values[Random().nextInt(widget.type == QuestionType.cube ? 4 : 5)],
        widget.difficulty,
        widget.type == QuestionType.multiplication
            ? widget.selectedTables
            : []);
    Future.delayed(const Duration(milliseconds: 2000), () async {
      while (dialogueOpen) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() {
        answerSelected = false;
        selectedAnswerIndex = [];
        // noOfCorrectAnswered = 0;
        inputNumber = null;
        question = newQuestion;
        _controller.clear();
        qno = qno + 1;
        time = question.time;
        startTimer();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          shakeKey.currentState?.shake();
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismisses the keyboard
          },
          child: Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   toolbarHeight: 50,
            //   scrolledUnderElevation: 0,
            //   leading: IconButton(
            //     icon: const Icon(Icons.arrow_back, color: Colors.white),
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //   ),
            // ),
            extendBodyBehindAppBar: true,
            extendBody: true,
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: 500,
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        // Container(
                        //     alignment: Alignment.centerLeft,
                        //     child: IconButton(
                        //         onPressed: () {
                        //           Navigator.pop(context);
                        //         },
                        //         icon: const Icon(
                        //           Icons.arrow_back,
                        //           color: Colors.white,
                        //         ))),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.type.heading,
                            style: const TextStyle(
                              color: Color(0xFF65C385),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        HeadingWidget(
                          difficulty: widget.difficulty,
                          qno: qno + 1,
                          time: time,
                          level: question.level,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            // Combine slide and fade animations
                            final fadeAnimation =
                                Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(animation);
                            final inAnimation = Tween<Offset>(
                                    begin: const Offset(0.1, 0),
                                    end: const Offset(0, 0))
                                .animate(animation);
                            final outAnimation = Tween<Offset>(
                                    begin: const Offset(-0.1, 0),
                                    end: const Offset(0, 0))
                                .animate(animation);

                            return FadeTransition(
                              opacity: fadeAnimation,
                              child: SlideTransition(
                                position: child.key == ValueKey(qno)
                                    ? inAnimation
                                    : outAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            key: ValueKey<int>(qno),
                            // alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            // height: 100,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Container(
                                  alignment: Alignment.center,
                                  child: QuestionWidget(
                                    question: question,
                                    type: widget.type,
                                    difficulty: widget.difficulty,
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              widget.difficulty == Difficulty.hard &&
                                      widget.type != QuestionType.primeNo
                                  ? "Type your answer here"
                                  : "Choose the correct option",
                              style: const TextStyle(
                                  fontSize: 16, color: Color(0xFFC5C5C5)),
                            )),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: widget.difficulty == Difficulty.hard &&
                                  widget.type != QuestionType.primeNo
                              ? Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: answerSelected
                                              ? (inputNumber ==
                                                      question.solution.first
                                                  ? const Color(0xFF137D39)
                                                  : const Color(0xFFDC4646))
                                              : const Color(0xFF08190E),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: TextField(
                                            readOnly: answerSelected,
                                            controller: _controller,
                                            keyboardType: TextInputType.number,
                                            onChanged: (inputText) {
                                              setState(() {
                                                try {
                                                  inputNumber =
                                                      int.parse(inputText);
                                                } catch (e) {
                                                  inputNumber = null;
                                                }
                                              });
                                            },
                                            onEditingComplete: () {
                                              setState(() {
                                                if (inputNumber != null &&
                                                    !answerSelected) {
                                                  answerSelected = true;
                                                  attemptedQno =
                                                      attemptedQno + 1;
                                                  if (question.solution
                                                      .contains(inputNumber)) {
                                                    // SystemSound.play(SystemSoundType.click);
                                                    correctAnswers =
                                                        correctAnswers + 1;
                                                    FirebaseStorageObjectInterface
                                                        .instance
                                                        .firebaseStorageObject!
                                                        .learningProgresses[
                                                            question
                                                                .type.intVal]
                                                        .changeProgress(
                                                            question, true);
                                                  } else {
                                                    // HapticFeedback.lightImpact();
                                                    FirebaseStorageObjectInterface
                                                        .instance
                                                        .firebaseStorageObject!
                                                        .learningProgresses[
                                                            question
                                                                .type.intVal]
                                                        .changeProgress(
                                                            question, false);
                                                  }
                                                  nextQuestion();
                                                }
                                              });
                                            },
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 28),
                                            textAlign: TextAlign.center,
                                            decoration: const InputDecoration(
                                                focusedBorder: InputBorder.none,
                                                border: InputBorder.none
                                                // border: OutlineInputBorder(
                                                //   borderRadius: BorderRadius.circular(12)
                                                // ),
                                                // fillColor: answerSelected
                                                // ? (inputNumber == question.solution
                                                //         ? const Color(0xFF137D39)
                                                //         : const Color(0xFFDC4646)
                                                //       )
                                                // :const Color(0xFF08190E),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Visibility(
                                        visible: answerSelected &&
                                            inputNumber !=
                                                question.solution.first,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xFF137D39)),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                          ),
                                          // width: ,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              children: [
                                                const Text(
                                                  "Correct Answer:",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 0,
                                                ),
                                                Text(
                                                  question.solution.first
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 28),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 22,
                                    crossAxisSpacing: 22,
                                    childAspectRatio: 1.7,
                                  ),
                                  itemCount: question.options.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        // Combine slide and fade animations
                                        final fadeAnimation =
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(animation);
                                        return FadeTransition(
                                          opacity: fadeAnimation,
                                          child: child,
                                        );
                                      },
                                      child: GestureDetector(
                                        key: ValueKey<bool>(answerSelected),
                                        onTap: () {
                                          if (!answerSelected) {
                                            if (question.type !=
                                                    QuestionType.primeNo ||
                                                question.difficulty !=
                                                    Difficulty.hard) {
                                              setState(() {
                                                if (question.solution.contains(
                                                    question.options[index])) {
                                                  // SystemSound.play(SystemSoundType.click);
                                                  correctAnswers =
                                                      correctAnswers + 1;
                                                  FirebaseStorageObjectInterface
                                                      .instance
                                                      .firebaseStorageObject!
                                                      .learningProgresses[
                                                          question.type.intVal]
                                                      .changeProgress(
                                                          question, true);
                                                } else {
                                                  // HapticFeedback.lightImpact();
                                                  FirebaseStorageObjectInterface
                                                      .instance
                                                      .firebaseStorageObject!
                                                      .learningProgresses[
                                                          question.type.intVal]
                                                      .changeProgress(
                                                          question, false);
                                                }
                                                selectedAnswerIndex.add(index);
                                                answerSelected = true;
                                                attemptedQno = attemptedQno + 1;
                                              });
                                              nextQuestion();
                                            } else {
                                              setState(() {
                                                if (question.solution.contains(
                                                    question.options[index])) {
                                                  // noOfCorrectAnswered = noOfCorrectAnswered + 1;
                                                  // if(noOfCorrectAnswered == question.solution.length){
                                                  // // answerSelected = true;
                                                  // // nextQuestion();
                                                  // } else {
                                                  // }
                                                } else {
                                                  // HapticFeedback.lightImpact();
                                                  answerSelected = true;
                                                  attemptedQno =
                                                      attemptedQno + 1;
                                                  primeHardLevelChange();
                                                  nextQuestion();
                                                }
                                                selectedAnswerIndex.add(index);
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12)),
                                              color: answerSelected
                                                  ? (question.solution.contains(
                                                          question
                                                              .options[index])
                                                      ? const Color(0xFF137D39)
                                                      : selectedAnswerIndex
                                                              .contains(index)
                                                          ? const Color(
                                                              0xFFDC4646)
                                                          : const Color(
                                                              0xFF08190E))
                                                  : selectedAnswerIndex
                                                          .contains(index)
                                                      ? question.solution
                                                              .contains(question
                                                                      .options[
                                                                  index])
                                                          ? const Color(
                                                              0xFF137D39)
                                                          : const Color(
                                                              0xFFDC4646)
                                                      : const Color(
                                                          0xFF08190E)),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(1),
                                            child: Text(
                                              question.type ==
                                                          QuestionType
                                                              .primeNo &&
                                                      [0, 1].contains(question
                                                          .options[index])
                                                  ? question.options[index] == 0
                                                      ? "No"
                                                      : "Yes"
                                                  : question.options[index]
                                                      .toString(),
                                              style: const TextStyle(
                                                fontSize: 28,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              // const SizedBox(height: 24,),
              height: 100,
              // color: const Color(0xFF000000),
              color: Colors.transparent,
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: qno < 10,
                      child: ShakeAnimation(
                        key: shakeKey,
                        child: const Text(
                          "Attend atleast 10 questions to end quiz",
                          style: TextStyle(
                            color: Color(0xFFC5C5C5),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTapDown: (_) => setState(() => _isPressed = true),
                      onTapUp: (_) => setState(() => _isPressed = false),
                      onTapCancel: () => setState(() => _isPressed = false),
                      onTap: () async {
                        if (attemptedQno >= 10) {
                          // timer.cancel();
                          dialogueOpen = true;
                          await quizExitPopup(context, () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultsPage(
                                  type: widget.type,
                                  difficulty: widget.difficulty,
                                  noAttempted: attemptedQno,
                                  noCorrect: correctAnswers,
                                  timeTaken: timeTaken,
                                  selectedTables:
                                      widget.type == QuestionType.multiplication
                                          ? widget.selectedTables
                                          : null,
                                ),
                              ),
                            );
                          });
                          dialogueOpen = false;
                          // if(!answerSelected) startTimer();
                        } else {
                          shakeKey.currentState?.shake();
                        }
                      },
                      child: AnimatedScale(
                        scale: _isPressed ? 0.9 : 1.0, // Shrink to 90% on press
                        duration:
                            Duration(milliseconds: 100), // Quick animation
                        curve: Curves.easeInOut,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          width: 160,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: attemptedQno < 10
                                      ? const Color(0xFFC5C5C5)
                                      : const Color(0xFFDC4646))),
                          child: Text(
                            "Stop Quiz",
                            style: TextStyle(
                              color: attemptedQno < 10
                                  ? const Color(0xFFC5C5C5)
                                  : const Color(0xFFDC4646),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 12,),
                  ],
                ),
                // const SizedBox(height: 24,),
              ),
            ),
          ),
        ));
  }
}

class HeadingWidget extends StatelessWidget {
  final Difficulty difficulty;
  final int qno;
  final int time;
  final Level? level;

  const HeadingWidget(
      {required this.difficulty,
      required this.qno,
      required this.time,
      this.level,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  difficulty.toText,
                  style: const TextStyle(
                    color: Color(0xFFC5C5C5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Q. $qno",
                  style: const TextStyle(
                    color: Color(0xFFC5C5C5),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                if (level != null)
                  Visibility(
                    visible: level != null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorMap[level!.intVal == 0
                                  ? 1
                                  : level!.intVal]!, // Circular border color
                              width: 1, // Border width
                            ),
                          ),
                          child: Text(
                            '${level!.intVal == 0 ? 1 : level!.intVal}',
                            style: TextStyle(
                              fontSize: 15, // Text size
                              color: colorMap[level!.intVal == 0
                                  ? 1
                                  : level!.intVal], // Text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: level!.intVal >= difficulty.maxLevel.intVal,
                          child: Text(
                            "You've hit the highest level in ${difficulty.name} mode",
                            style: const TextStyle(
                                color: Color(0xFFC5C5C5), fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: TimerWidget(time: time),
          ),
        ],
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  final int time;
  const TimerWidget({required this.time, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      SizedBox(
        height: 50,
        width: 50,
        child: Image.asset(
          'assets/icons/TimerIcon.png',
          fit: BoxFit.contain,
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 8, right: 2),
        child: Text(
          "$time",
          style: const TextStyle(fontSize: 19, color: Colors.white),
        ),
      ),
    ]);
  }
}

class QuestionWidget extends StatelessWidget {
  final QuestionType type;
  final Question question;
  final Difficulty difficulty;
  const QuestionWidget(
      {required this.type,
      required this.question,
      required this.difficulty,
      super.key});

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      QuestionType.multiplication => Text(
          "${question.numA} x ${question.numB} =",
          style: const TextStyle(fontSize: 44, color: Colors.white),
        ),
      QuestionType.cube => Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: '${question.numA}',
                  style: const TextStyle(
                    fontSize: 44,
                    color: Colors.white,
                  )),
              WidgetSpan(
                child: Transform.translate(
                  offset: const Offset(2, -24),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const TextSpan(
                  text: ' =',
                  style: TextStyle(
                    fontSize: 44,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      QuestionType.square => Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: '${question.numA}',
                  style: const TextStyle(
                    fontSize: 44,
                    color: Colors.white,
                  )),
              WidgetSpan(
                child: Transform.translate(
                  offset: const Offset(2, -24),
                  child: const Text(
                    '2',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const TextSpan(
                  text: ' =',
                  style: TextStyle(
                    fontSize: 44,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      QuestionType.primeNo => Text(
          question.difficulty == Difficulty.easy
              ? "Is ${question.numA} a prime number?"
              : "Which of these are prime",
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      QuestionType.power => Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: '${question.numB}',
                  style: const TextStyle(
                    fontSize: 44,
                    color: Colors.white,
                  )),
              WidgetSpan(
                child: Transform.translate(
                  offset: const Offset(2, -24),
                  child: Text(
                    '${question.numA}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const TextSpan(
                  text: ' =',
                  style: TextStyle(
                    fontSize: 44,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
    };
  }
}

Future<void> quizExitPopup(
    BuildContext context, void Function() exitFunction) async {
  await showDialog(
    context: context,
    // barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return popDialogue(
          onConfirm: () {
            Navigator.pop(context);
            exitFunction();
          },
          onCancel: () {
            Navigator.pop(context);
          },
          accept: 'Yes',
          reject: 'No',
          message: 'Do you want to quit the quiz at this stage?',
        );
      });
    },
  );
}

Future<void> quizTimer(BuildContext context) async {
  Timer? timer;
  int time = 3;
  await showDialog(
    context: context,
    // barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        timer ??= Timer.periodic(const Duration(seconds: 1), (timerState) {
          time = time - 1;
          if (time == 0) {
            timer!.cancel();
            Navigator.pop(context);
          }
          setState(() {});
        });
        return PopScope(
            canPop: false,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.zero, // Full screen without padding
                child: SizedBox(
                  width: MediaQuery.of(context).size.width, // Full width
                  height: MediaQuery.of(context).size.height, // Full height
                  child: Stack(
                    children: [
                      // Background blur effect
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.black
                              .withOpacity(0.5), // Semi-transparent overlay
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Center(
                              child: Text(
                                "Get Ready. Your Quiz Starts in...",
                                style: TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                // Combine slide and fade animations
                                final fadeAnimation =
                                    Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(animation);
                                return FadeTransition(
                                  opacity: fadeAnimation,
                                  child: child,
                                );
                              },
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Transform.scale(
                                      //   scale: 3.2,
                                      //   child: const CircularProgressIndicator(
                                      //     valueColor: AlwaysStoppedAnimation<Color>(
                                      //         Color(0xFFC5C5C5),),
                                      //     strokeWidth:
                                      //         1.0,
                                      //   ),
                                      // ),

                                      Text(
                                        key: ValueKey<int>(time),
                                        time == 0 ? " " : time.toString(),
                                        style: const TextStyle(
                                            color: Color(0xFFC5C5C5),
                                            fontSize: 80,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ]),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 30,
                            // )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
      });
    },
  );
}

class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double translationalDistance;
  final int noOfVibrations;
  final double scaleFactor;

  const ShakeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.noOfVibrations = 3,
    this.translationalDistance = 3.0,
    this.scaleFactor = 1.15,
  });

  @override
  _ShakeAnimationState createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> shakeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Define the shake animation
    shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -widget.translationalDistance),
          weight: 1),
      ...List.generate(
          widget.noOfVibrations,
          (index) => [
                TweenSequenceItem(
                    tween: Tween(
                        begin: -1 * widget.translationalDistance,
                        end: widget.translationalDistance),
                    weight: 1),
                TweenSequenceItem(
                    tween: Tween(
                        begin: widget.translationalDistance,
                        end: -1 * widget.translationalDistance),
                    weight: 1)
              ]).expand((element) => element),
      TweenSequenceItem(
          tween: Tween(begin: -1 * widget.translationalDistance, end: 0.0),
          weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 4),
    ]).animate(_controller);
    scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: widget.scaleFactor), // Scale up
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(
            begin: widget.scaleFactor, end: widget.scaleFactor), // Scale up
        weight: widget.noOfVibrations + 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.scaleFactor, end: 1.0), // Scale down
        weight: 4,
      ),
    ]).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  void shake() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
            offset: Offset(shakeAnimation.value, 0),
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: widget.child,
            ));
      },
      child: widget.child,
    );
  }
}

class FadePageRoute extends PageRouteBuilder {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
