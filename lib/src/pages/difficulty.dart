import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tabbller/src/functions/common.dart';
import 'package:tabbller/src/functions/question.dart';
import 'package:tabbller/src/pages/question_page.dart';

class DifficultyPage extends StatefulWidget {
  final QuestionType type;
  final List<int>? selectedTables;
  const DifficultyPage({required this.type, this.selectedTables, super.key});

  @override
  State<DifficultyPage> createState() => DifficultyPageState();
}

class DifficultyPageState extends State<DifficultyPage> {
  final List<bool> _isPressed = List.filled(3, false);
  @override
  void initState() {
    if (widget.type == QuestionType.multiplication &&
        widget.selectedTables == []) {
      throw (ArgumentError(
          'selectedTables required when type is multiplication'));
    }
    super.initState();
  }

  Color backgroundColors = const Color(0xFFB4C1B6);
  List<Color> barColor = [
    const Color(0xFF137D39),
    const Color(0xFF7B7D13),
    const Color(0xFF7D1313)
  ];
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
              Color(0xFF0A2112), // Start color
              Color(0xFF000000), // End color
            ],
            begin: Alignment.topCenter, // Start gradient from the top
            end: Alignment.bottomCenter, // End gradient at the bottom
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SizedBox(width: width, child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              'assets/icons/arrowLeft.png',
                              width: 16,
                              height: 16,
                            )),
                        // const SizedBox(
                        //   width: 10,
                        // )
                      ],
                    ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.type.heading,
                        style: const TextStyle(
                          color: Color(0xFF65C385),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            infoDialogue(context);
                          },
                          child: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          )),
                    ]
                ),
                const SizedBox(
                  height: 32,
                ),
                const Center(
                    child: Text(
                  "Answer correctly to level up: Upto Level 2 (easy), upto Level 4 (medium), Level 5 (hard). A wrong answer resets you to level 1.",
                  style: TextStyle(color: Color(0xFFC5C5C5), fontSize: 11),
                )),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(5, (index) {
                      return OutlinedNumberWidget(
                        number: index + 1,
                      );
                    })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(5, (index) {
                      if (index % 2 == 0) {
                        return Text(
                          ['Learning', 'Reviewing', 'Mastered'][index ~/ 2],
                          style: TextStyle(
                            fontSize: 15, // Text size
                            color: colorMap[index + 1], // Text color
                            fontWeight: FontWeight.normal,
                          ),
                        );
                      } else {
                        return const SizedBox(width: 9);
                      }
                    })
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                // if (widget.type == QuestionType.multiplication)
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Image.asset(
                //       'assets/icons/note.png',
                //       width: 25,
                //       height: 25,
                //     ),
                //     const SizedBox(
                //       width: 5,
                //     ),
                //     const Expanded(
                //       child: Text(
                //         "Note: Questions for the quiz will be generated from the range selected for learning in the home screen",
                //         style: TextStyle(
                //             color: Color(0xFFC5C5C5), fontSize: 11),
                //       ),
                //     )
                //   ],
                // ),
                // if (widget.type == QuestionType.multiplication)
                // const SizedBox(
                //   height: 32,
                // ),
                const Center(
                  child: Text(
                    "Choose Difficulty",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ...List.generate(3, (index) {
                  return GestureDetector(
                    onTapDown: (_) => setState(() => _isPressed[index] = true),
                    onTapUp: (_) => setState(() => _isPressed[index] = false),
                    onTapCancel: () => setState(() => _isPressed[index] = false),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionPage(
                                  type: widget.type,
                                  selectedTables: widget.type ==
                                          QuestionType.multiplication
                                      ? widget.selectedTables
                                      : [],
                                  difficulty: Difficulty.values[index],
                                )),
                      );
                    },
                    child: AnimatedScale(
                      scale: _isPressed[index] ? 0.95 : 1.0, // Shrink to 90% on press
                      duration: const Duration(milliseconds: 100), // Quick animation
                      curve: Curves.easeInOut,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 30),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 16),
                        decoration: const BoxDecoration(
                            color: Color(0xFF1D3927),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: 
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Difficulty.values[index].toText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.timer_outlined,
                                        color: Color(0xFFD2F7DE),
                                        size: 14,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                        child: Text(
                                          '${widget.type == QuestionType.primeNo && index == 3 ? 15 : Difficulty.values[index].timeVal.toString()} sec/qn',
                                          style: const TextStyle(
                                            color: Color(0xFFD2F7DE),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ) 
            ),
        ),
      ),
    );
  }
}

class OutlinedNumberWidget extends StatelessWidget {
  final int number;
  const OutlinedNumberWidget({required this.number, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorMap[number]!, // Circular border color
          width: 1, // Border width
        ),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 15, // Text size
          color: colorMap[number], // Text color
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

void infoDialogue(BuildContext context) {
  const textHelper = {
    0: [
      "Answer correctly once to move from level 1 to",
      "level 2.",
    ],
    1: [
      "Answer correctly each time to move from.",
      "level 1 to level 4, then stop at level 4.",
    ],
    2: [
      "Answer correctly at level 1 to jump straight to",
      "level 4, then once more to reach level 5.",
    ],
  };
  showDialog(
    context: context,
    // barrierDismissible: true,
    builder: (BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;
      return StatefulBuilder(builder: (context, setState) {
        return Scaffold(
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
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: width,
                      decoration: const BoxDecoration(
                        color: Color(0xFF08190E),
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      margin: const EdgeInsets.only(left: 30, right: 30, top: 90),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Image.asset(
                                  'assets/icons/close.png',
                                  width: 12,
                                  height: 12,
                                  color: Colors.white,
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          ...List.generate(3, (index) {
                            return [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  children: [Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Difficulty.values[index].toText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${textHelper[index]![0]} ${textHelper[index]![1]}',
                                  style: const TextStyle(
                                      color: Color(0xFFC5C5C5), fontSize: 12),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                // fit: BoxFit.fill,
                                child: Image.asset(
                                  'assets/DifficultyPage_$index.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),

                                  ],
                                ),
                                ),
                              
                            ];
                          }).expand((x) => x),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: const Text(
                              "In every case a wrong answer resets you to level 1.",
                              style: TextStyle(
                                  color: Color(0xFFC5C5C5), fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}
