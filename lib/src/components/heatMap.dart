import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tabbller/src/components/heatMultiplication.dart';
import 'package:tabbller/src/components/tables.dart';
import 'package:tabbller/src/functions/data.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';

class HeatMapDialog extends StatefulWidget {
  final int tIndex;
  final List<int> selectedTables;

  const HeatMapDialog(
      {super.key, required this.tIndex, required this.selectedTables});

  @override
  // ignore: library_private_types_in_public_api
  _HeatMapDialogState createState() => _HeatMapDialogState();
}

class _HeatMapDialogState extends State<HeatMapDialog>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  late AnimationController _blurController;
  late Animation<double> _blurAnimation;

  late List<AnimationController> _percentageControllers;
  late List<Animation<double>> percentageAni;

  List<double> heatMapPercentage = [0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: widget.tIndex == 0 ? 1750 : 0), () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    int sum = 0;
    List<Level> levelData = FirebaseStorageObjectInterface
        .instance
        .firebaseStorageObject!
        .learningProgresses[widget.tIndex == 3
            ? 4
            : widget.tIndex == 4
                ? 3
                : widget.tIndex]
        .levelData
        .expand((e) => e)
        .toList();
    for (int i = 0; i < levelData.length; i++) {
      if (widget.tIndex == 3) {
        if (primeNumbers.contains(primeBar[i])) {
          heatMapPercentage[levelData[i].intVal] =
              heatMapPercentage[levelData[i].intVal] + 1;
          sum = sum + 1;
        }
      } else {
        heatMapPercentage[levelData[i].intVal] =
            heatMapPercentage[levelData[i].intVal] + 1;
        sum = sum + 1;
      }
    }

    heatMapPercentage =
        heatMapPercentage.map((val) => val * 100 / sum).toList();
    heatMapPercentage.removeAt(0);
    // heatMapPercentage = heatMapPercentage.reversed.toList();

    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _blurController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _blurAnimation =
        Tween<double>(begin: 0.0, end: 10.0).animate(CurvedAnimation(
      parent: _blurController,
      curve: Curves.easeInOut,
    ));

    _percentageControllers = List.generate(
      heatMapPercentage.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      ),
    );

    percentageAni = List.generate(
      heatMapPercentage.length,
      (index) =>
          Tween<double>(begin: 0, end: heatMapPercentage[index].toDouble())
              .animate(
        CurvedAnimation(
            parent: _percentageControllers[index], curve: Curves.easeOut),
      )..addListener(() {
              setState(() {});
            }),
    );

    for (var controller in _percentageControllers) {
      controller.forward();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slideController.forward();
      _blurController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _blurController.dispose();
    for (var controller in _percentageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<int, Color> colorMap = {
      0: const Color(0xFFDC4646),
      1: const Color(0xFFD57D43),
      2: const Color(0xFFD5B543),
      3: const Color(0xFF89B941),
      4: const Color(0xFF137D39),
    };
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = (deviceWidth - 60) > 400 ? 400 : (deviceWidth - 60);
    width = width * 5 / 6;
    double totalWidth = width - 10;
    return Padding(
      padding: EdgeInsets.zero,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _blurAnimation,
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
              ),
              Transform.translate(
                offset: Offset(0,
                    _slideAnimation.value * MediaQuery.of(context).size.height),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: Text(
                            widget.tIndex == 0
                                ? 'Multiplication Table Heatmap'
                                : widget.tIndex == 1
                                    ? 'Squares Table Heatmap'
                                    : widget.tIndex == 2
                                        ? 'Cubes Table Heatmap'
                                        : widget.tIndex == 3
                                            ? 'Prime Numbers Table Heatmap'
                                            : widget.tIndex == 4
                                                ? 'Powers Table Heatmap'
                                                : 'Heatmap',
                            style: const TextStyle(
                                color: Color(0xFF65C385),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 15),
                            child: widget.tIndex == 0
                                ? FutureBuilder(
                                    future: Future.delayed(
                                            const Duration(milliseconds: 500))
                                        .then<bool>((_) => true),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return HeatMultiplicationTable(
                                          key: ValueKey<int>(widget.tIndex),
                                          heatMap: true,
                                        );
                                      } else {
                                        return Container(
                                          width: ((width - 8) / 5) * 6 + 15,
                                          height: ((width - 8) / 5) * 6 + 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: const Color(0xFF040C07),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : TableWidget(
                                    key: ValueKey<int>(widget.tIndex),
                                    tIndex: widget.tIndex,
                                    heatMap: true,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          child: SizedBox(
                            width: totalWidth + 2,
                            child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Learning',
                                    style: TextStyle(
                                      color: Color(0xFFDC4646),
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Reviewing',
                                    style: TextStyle(
                                      color: Color(0xFFD5B543),
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Mastered',
                                    style: TextStyle(
                                      color: Color(0xFF137D39),
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          height: 10,
                          width: totalWidth + 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white),
                            color: Colors.transparent,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Row(
                              children: List.generate(
                                5,
                                (index) {
                                  return Container(
                                    width: totalWidth *
                                        percentageAni[index].value /
                                        100,
                                    color: colorMap[index],
                                    height: 10,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void showHeatMap(BuildContext context, int tIndex, List<int> selectedTables) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return HeatMapDialog(tIndex: tIndex, selectedTables: selectedTables);
    },
  );
}
