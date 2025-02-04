import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tabbller/src/functions/question.dart';
import 'package:tabbller/src/pages/difficulty.dart';



class RangeSelectionDialog extends StatefulWidget {

  const RangeSelectionDialog({
    super.key,
  });

  @override
  State<RangeSelectionDialog> createState() => _RangeSelectionDialogState();
}

class _RangeSelectionDialogState extends State<RangeSelectionDialog>
    with TickerProviderStateMixin {
  
      List<int> selectedTables = [];

  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  late AnimationController _blurController;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _blurController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeIn,
      ),
    );

    _blurAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _blurController,
        curve: Curves.easeIn,
      ),
    );
    _slideController.forward();
    _blurController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _blurController.dispose();
    super.dispose();
  }

  void toggleSelection(int number) {
    setState(() {
      if (number == 0) {
        selectedTables.removeRange(0, selectedTables.length);
      } else if (number == 26) {
        selectedTables.removeRange(0, selectedTables.length);
        selectedTables.addAll(List.generate(25, (index) {
          return (index + 1);
        }));
      } else {
        if (selectedTables.contains(number)) {
          selectedTables.remove(number);
        } else {
          selectedTables.add(number);
        }
      }
      selectedTables.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _blurController,
                    builder: (context, child) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: _blurAnimation.value,
                          sigmaY: _blurAnimation.value,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0x00000000),
                                Color(0xFF000000),
                              ],
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Transform.translate(
                    offset: Offset(
                        0,
                        _slideAnimation.value *
                            MediaQuery.of(context).size.height),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(top: 20, left: 20, right: 20),
                            child: Text(
                              'Choose the numbers for which its tables you would like to isolate and take Quiz',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: 300,
                              height: 300,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  childAspectRatio: 1,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                ),
                                itemCount: 25,
                                itemBuilder: (context, index) {
                                  int number = index + 1;
                                  bool isSelected =
                                      selectedTables.contains(number);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        toggleSelection(number);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF137D39)
                                            : Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          "$number",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _slideController.reverse();
                                    _blurController.reverse();
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/close.png',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              SizedBox(
                                width: 200,
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedTables.length == 25
                                          ? toggleSelection(0)
                                          : toggleSelection(26);
                                    });
                                  },
                                  child: Text(
                                    selectedTables.length == 25
                                        ? 'Deselect All'
                                        : 'Select All',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DifficultyPage(
                                          type: QuestionType.values[0],
                                          selectedTables: selectedTables.isEmpty ? List.generate(25, (index) => index + 1) : selectedTables,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/ok.png',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
