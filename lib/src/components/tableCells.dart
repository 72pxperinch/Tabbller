import 'package:flutter/material.dart';
import 'package:tabbller/src/functions/data.dart';

import 'package:tabbller/src/functions/firestoreDatabase.dart';

class TableCells extends StatefulWidget {
  const TableCells({
    super.key,
    required this.heatMap,
    required this.tIndex,
    required this.width,
  });
  final bool heatMap;
  final int tIndex;
  final double width;

  @override
  State<TableCells> createState() => _TableCellsState();
}

class _TableCellsState extends State<TableCells> {
  List<List<int>> levelVals = [];
  List<int> sqrValues = [];
  List<int> cubeValues = [];
  List<int> powerValues = [];
  List<int> primeValues = [];

  @override
  void initState() {
    super.initState();
    sqrValues = FirebaseStorageObjectInterface
        .instance.firebaseStorageObject!.learningProgresses[1]
        .toMapTablePage();

    cubeValues = FirebaseStorageObjectInterface
        .instance.firebaseStorageObject!.learningProgresses[2]
        .toMapTablePage();

    powerValues = FirebaseStorageObjectInterface
        .instance.firebaseStorageObject!.learningProgresses[3]
        .toMapTablePage();

    primeValues = FirebaseStorageObjectInterface
        .instance.firebaseStorageObject!.learningProgresses[4]
        .toMapTablePage();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // shrinkWrap: true,
      physics: const PageScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: _getItemCount(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: widget.tIndex == 3 ? 15 : 5,
          ),
          decoration: BoxDecoration(
            color: widget.heatMap == true
                ? _getTileColor(index)
                : const Color(0xFF08190E),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: ((index < 50
                      ? primeNumbers.contains(primeBar[index])
                      : false) &&
                  (widget.heatMap == false || widget.heatMap == true) &&
                  widget.tIndex == 3)
                  ? const Color(0xFF137D39)
                  : Colors.transparent,
              width: 3,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            child: (widget.tIndex != 3
                ? _buildSquareOrCubeContent(index)
                : _buildPrimeContent(index)),
          ),
        );
      },
    );
  }

  int _getItemCount() {
    if (widget.tIndex == 1) {
      return sqrTopBar.length;
    } else if (widget.tIndex == 2) {
      return cubetopBar.length;
    } else if (widget.tIndex == 3) {
      return primeBar.length;
    } else {
      return 20;
    }
  }

  Color _getTileColor(int index) {
    List<int> values;

    switch (widget.tIndex) {
      case 1:
        values = sqrValues;
        break;
      case 2:
        values = cubeValues;
        break;
      case 4:
        values = powerValues;
        break;
      default:
        values = primeValues;
    }

    switch (values[index]) {
      case 1:
        return const Color(0xFFDC4646);
      case 2:
        return const Color(0xFFD57D43);
      case 3:
        return const Color(0xFFD5B543);
      case 4:
        return const Color(0xFF89B941);
      case 5:
        return const Color(0xFF137D39);
      default:
        return const Color(0xFF000000);
    }
  }

  Widget _buildSquareOrCubeContent(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: widget.tIndex == 4 && power1[index] > 9 ? -12 : -7,
              top: -3,
              child: Text(
                widget.tIndex == 1
                    ? "2"
                    : widget.tIndex == 2
                        ? "3"
                        : widget.tIndex == 4
                            ? "${power1[index]}"
                            : "0",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
            Text(
              "${widget.tIndex == 1 ? sqrTopBar[index] : widget.tIndex == 2 ? cubetopBar[index] : widget.tIndex == 4 ? power2[index] : "0"}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        Text(
          "${widget.tIndex == 1 ? sqrBottomBar[index] : widget.tIndex == 2 ? cubeBottomBar[index] : widget.tIndex == 4 ? power3[index] : "0"}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPrimeContent(int index) {
    return Text(
      "${primeBar[index]}",
      style: TextStyle(
          color: primeNumbers.contains(primeBar[index])
              ? Colors.white
              : const Color(0xFF8A8A8A)),
    );
  }
}
