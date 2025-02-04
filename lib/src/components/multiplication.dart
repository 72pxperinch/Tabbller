import 'package:flutter/material.dart';
import 'package:tabbller/src/functions/common.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';

class MultiplicationTable extends StatefulWidget {
  const MultiplicationTable({
    super.key,
  });

  @override
  State<MultiplicationTable> createState() => _MultiplicationTableState();
}

class _MultiplicationTableState extends State<MultiplicationTable> {
  late double width;
  late double height;
  late double cellWidthHeight;
  late List<int> selectedTables;
  late ScrollController gridScrollController;
  late ScrollController listScrollController;
  late int rangeIndex = 0;
  late int prevRangeIndex = 0;

  @override
  void initState() {
    gridScrollController = ScrollController();
    listScrollController = ScrollController();
    gridScrollController.addListener(() {
      listScrollController.jumpTo(gridScrollController.offset);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    width = (deviceWidth - 70) > 400 ? 400 : (deviceWidth - 70);
    width = width * 5 / 6;
    height = width;
    cellWidthHeight = (width - 8) / 5;
    selectedTables = List.generate(5, (index) => rangeIndex * 5 + 1 + index);
    return Column(children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 360),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final easeInOutAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut, 
          );
          final easeInAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeIn, 
          );
          final fadeAnimationIn =
              Tween<double>(begin: 0.0, end: 1.0).animate(easeInAnimation);
          final rightAnimation = Tween<Offset>(
                  begin: const Offset(0.2, 0), end: const Offset(0, 0))
              .animate(easeInOutAnimation);
          final leftAnimation = Tween<Offset>(
                  begin: const Offset(-0.2, 0), end: const Offset(0, 0))
              .animate(easeInOutAnimation);
          return FadeTransition(
            opacity: fadeAnimationIn,
            child: SlideTransition(
              position: child.key == ValueKey(rangeIndex)
                  ? (prevRangeIndex < rangeIndex ? rightAnimation : leftAnimation):
                  (prevRangeIndex < rangeIndex ? leftAnimation : rightAnimation),
              child: child,
            ),
          );

        },
        child: Column(
          key: ValueKey(rangeIndex),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: cellWidthHeight,
                  width: cellWidthHeight,
                ),
                const SizedBox(
                  width: 4,
                ),
                ...List.generate(9, (index) {
                  return index % 2 == 0
                      ? Container(
                          width: cellWidthHeight,
                          height: cellWidthHeight,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D3927),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              selectedTables[index ~/ 2].toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(
                          width: 2,
                        );
                })
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: cellWidthHeight,
                  height: height + 10,
                  child: ListView.builder(
                      // physics: ClampingScrollPhysics(),
                      physics: const NeverScrollableScrollPhysics(),
                      controller: listScrollController,
                      itemCount: 49,
                      itemBuilder: (context, index) {
                        return index % 2 == 0
                            ? Container(
                                width: cellWidthHeight,
                                height: cellWidthHeight,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1D3927),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    (index ~/ 2 + 1).toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(
                                height: 2,
                              );
                      }),
                ),
                const SizedBox(
                  width: 4,
                ),
                SizedBox(
                  width: width,
                  height: height + 10,
                  child: FullTableWidget(
                      scrollController: gridScrollController,
                      selectedTables: selectedTables,
                      cellWidthHeight: cellWidthHeight,
                      heatMap: false)
                )
              ],
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 25,
      ),
      SizedBox(
        width: cellWidthHeight * 6 + 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (rangeIndex > 0) {
                  setState(() {
                    prevRangeIndex = rangeIndex;
                    rangeIndex = rangeIndex - 1;
                  });
                }
              },
              child: Container(
                width: cellWidthHeight,
                height: cellWidthHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rangeIndex == 0
                      ? Colors.transparent
                      : const Color(0xFF1D3927),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.asset(
                  "assets/icons/leftSwitch.png",
                  color:
                      rangeIndex == 0 ? const Color(0xFF535353) : Colors.white,
                  width: 12,
                  height: 12,
                ),
              ),
            ),
            Text(
              "${rangeIndex * 5 + 1} - ${rangeIndex * 5 + 5}",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            GestureDetector(
                onTap: () {
                  if (rangeIndex < 4) {
                    setState(() {
                      prevRangeIndex = rangeIndex;
                      rangeIndex = rangeIndex + 1;
                    });
                  }
                },
                child: Container(
                  width: cellWidthHeight,
                  height: cellWidthHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: rangeIndex == 4
                        ? Colors.transparent
                        : const Color(0xFF1D3927),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Image.asset(
                    "assets/icons/rightSwitch.png",
                    color: rangeIndex == 4
                        ? const Color(0xFF535353)
                        : Colors.white,
                    width: 12,
                    height: 12,
                  ),
                )),
          ],
        ),
      )
    ]);
  }
}

class FullTableWidget extends StatelessWidget {
  const FullTableWidget({
    super.key,
    required this.scrollController,
    required this.selectedTables,
    required this.heatMap,
    required this.cellWidthHeight,
  });

  final ScrollController scrollController;
  final List<int> selectedTables;
  final bool heatMap;
  final double cellWidthHeight;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: IntervalSnapScrollPhysics(snapInterval: cellWidthHeight + 2),
      controller: scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: 5 * 25,
      itemBuilder: (context, index) {
        int multiplier = (index ~/ selectedTables.length) + 1;
        int tableIndex = index % selectedTables.length;

        int result = selectedTables[tableIndex] * multiplier;

        int smaller = selectedTables[tableIndex] < multiplier
            ? selectedTables[tableIndex]
            : multiplier;
        int larger = selectedTables[tableIndex] < multiplier
            ? multiplier
            : selectedTables[tableIndex];
        String normalizedString = "$smaller*$larger";

        int colorCode = FirebaseStorageObjectInterface
                .instance.firebaseStorageObject!.learningProgresses[0]
                .toMapTablePage()[normalizedString] ??
            0;
        Color? cellColor;

        if (heatMap == false) {
          cellColor = const Color(0xFF08190E);
        } else {
          cellColor = colorMap[colorCode];
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: cellColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              "$result",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class IntervalSnapScrollPhysics extends ScrollPhysics {
  final double snapInterval;

  /// Creates physics for snapping at specified intervals.
  const IntervalSnapScrollPhysics({required this.snapInterval, super.parent});

  @override
  IntervalSnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return IntervalSnapScrollPhysics(
      snapInterval: snapInterval,
      parent: buildParent(ancestor),
    );
  }

  double _getPage(ScrollMetrics position) {
    return position.pixels / snapInterval;
  }

  double _getPixels(ScrollMetrics position, double page) {
    return page * snapInterval;
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
