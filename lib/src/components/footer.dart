import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:tabbller/src/pages/difficulty.dart';
import 'package:tabbller/src/functions/question.dart';
import 'package:tabbller/src/components/rangeSelect.dart';

class BottomButtons extends StatefulWidget {
  final int tIndex;
  final VoidCallback rebuild;
  final Function(BuildContext, int, List<int>) onShowHeatMap;

  const BottomButtons({
    required this.tIndex,
    required this.rebuild,
    required this.onShowHeatMap,
    super.key,
  });

  @override
  State<BottomButtons> createState() => _BottomButtonsState();
}

class _BottomButtonsState extends State<BottomButtons> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    List<int> tablestoshow = List.generate(25, (index) {
      return index + 1;
    });
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 65,
            height: 45,
          ),
          // Quiz button
          Expanded(
           child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: AnimatedScale(
              scale: _isPressed ? 0.9 : 1.0, // Shrink to 90% on press
              duration: const Duration(milliseconds: 100), // Quick animation
              curve: Curves.easeInOut,
                child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF138A3C),
                            Color(0xFF124925),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                        ),
                        onPressed: () async {widget.tIndex == 0 ? _showRangeSelection(context) :
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DifficultyPage(
                                type: QuestionType.values[widget.tIndex == 3
                                    ? 4
                                    : widget.tIndex == 4
                                        ? 3
                                        : widget.tIndex],
                                selectedTables: [],
                              ),
                            ),
                          );
                          widget.rebuild();
                        },
                        child: const Text(
                          'Take Quiz',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    )),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () => widget.onShowHeatMap(context, widget.tIndex, tablestoshow),
            
            child: Image.asset(
              'assets/icons/heatMap.png',
              width: 45,
              height: 45,
              fit: BoxFit.contain,
            ),
          ),
        ],
      )
    );

    
  }

  void _showRangeSelection(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const RangeSelectionDialog();
      }
    );
  }
  
}
