import 'package:flutter/material.dart';
import 'package:tabbller/src/functions/common.dart';
import 'package:tabbller/src/functions/data.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';
import 'package:tabbller/src/functions/question.dart';

class HistoryPage extends StatefulWidget implements PreferredSizeWidget {
  const HistoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistoryPageState createState() => _HistoryPageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0A2112),
            Color(0xFF000000),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: SizedBox(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                              alignment: Alignment.centerLeft,
                              width: 30,
                              height: 30,
                              color: Colors.transparent,
                              child: Image.asset(
                                'assets/icons/arrowLeft.png',
                                width: 16,
                                height: 16,
                              ))),
                          const SizedBox(width: 10,),
                        ],
                      ),
                                
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Quiz History",
                        style: TextStyle(
                          color: Color(0xff65C385),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  FirebaseStorageObjectInterface
                          .instance.firebaseStorageObject!.quizHistory.isEmpty
                      ? Expanded( child: Center(
                          child:  
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 120,),
                              Image.asset(
                                'assets/noHistory.png',
                                width: 190,
                                height: 190,
                              ),
                              const SizedBox(height: 25,),
                              const Text(
                                  "Your History Looks Empty",
                                  style: TextStyle(
                                    color: Color(0xffC5C5C5),
                                    fontSize: 14,
                                  ),
                                ),
                              const Text(
                                  "Start doing quizes",
                                  style: TextStyle(
                                    color: Color(0xffC5C5C5),
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          )
                        ))
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 5, bottom: 20),
                          child: ScrollbarTheme(
                            data: ScrollbarThemeData(
                              thumbColor: WidgetStateProperty.all<Color>(
                                  const Color(0xff65C385)),
                            ),
                            child: Scrollbar(
                              thumbVisibility: true,
                              interactive: true,
                              thickness: 5.0,
                              radius: const Radius.circular(10),
                              scrollbarOrientation: ScrollbarOrientation.right,
                              child: ListView.builder(
                                itemCount: FirebaseStorageObjectInterface
                                    .instance
                                    .firebaseStorageObject!
                                    .quizHistory
                                    .length,
                                itemBuilder: (BuildContext context, int index) {
                                  int reversedIndex =
                                      FirebaseStorageObjectInterface
                                              .instance
                                              .firebaseStorageObject!
                                              .quizHistory
                                              .length -
                                          1 -
                                          index;
                                  QuizHistory quizDets =
                                      FirebaseStorageObjectInterface
                                          .instance
                                          .firebaseStorageObject!
                                          .quizHistory[reversedIndex];
                                  return Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xff08190E),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                              border: Border.all(
                                                color: const Color(0xff1D3927),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${intToMonth[quizDets.quizTime.month]} ${quizDets.quizTime.day}  ${quizDets.quizTime.hour % 12 == 0 ? 12 : quizDets.quizTime.hour % 12}:${quizDets.quizTime.minute}${quizDets.quizTime.hour > 11 ? 'PM' : 'AM'}",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xffC5C5C5),
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      quizDets.type.heading
                                                          .substring(
                                                              0,
                                                              quizDets
                                                                      .type
                                                                      .heading
                                                                      .length -
                                                                  5),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xffffffff),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${quizDets.difficulty.toText} (${quizDets.timeInSeconds ~/ 60}m ${quizDets.timeInSeconds % 60}s)",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xffffffff),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      quizDets.type ==
                                                              QuestionType
                                                                  .multiplication
                                                          ? 'Range: ${rangetoString(quizDets.selectedTables!)}'
                                                          : '',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xffC5C5C5),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${quizDets.correctAnswers * 100 ~/ quizDets.totalQuestions} %",
                                                        style: TextStyle(
                                                          color: (quizDets.correctAnswers *
                                                                      100 ~/
                                                                      quizDets
                                                                          .totalQuestions) <=
                                                                  30
                                                              ? const Color(
                                                                  0xFFDC4646)
                                                              : (quizDets.correctAnswers *
                                                                              100 ~/
                                                                              quizDets
                                                                                  .totalQuestions) >
                                                                          30 &&
                                                                      (quizDets.correctAnswers *
                                                                              100 ~/
                                                                              quizDets
                                                                                  .totalQuestions) <
                                                                          70
                                                                  ? const Color(
                                                                      0xFFD5B543)
                                                                  : const Color(
                                                                      0xff65C385),
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "(${quizDets.correctAnswers}/${quizDets.totalQuestions})",
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xffffffff),
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ));
                                },
                              ),
                            ),
                          ),
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

String rangetoString(List<int> selectedTables) {
  selectedTables.sort();
  List<String> returnStrings = [];
  int? num1;
  int? num2;
  for (int number in selectedTables) {
    if (num1 == null) {
      num1 = number;
      num2 = number;
    } else if (number == num2! + 1) {
      num2 = num2 + 1;
    } else {
      returnStrings.add(num1 == num2 ? '$num1' : '$num1-$num2');
      num1 = number;
      num2 = number;
    }
  }
  returnStrings.add(num1 == num2 ? '$num1' : '$num1-$num2');
  return returnStrings.join(', ');
}
