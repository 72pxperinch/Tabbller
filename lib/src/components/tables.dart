import 'package:flutter/material.dart';

import 'package:tabbller/src/components/tableCells.dart';
import 'package:tabbller/src/functions/data.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({
    super.key,
    required this.tIndex,
    required this.heatMap,
  });
  final int tIndex;
  final bool heatMap;

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    constrainedWidth = (deviceWidth - 60) > 375 ? 375 : (deviceWidth - 80);

    return 
    Column(
      children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        SizedBox(
          width: constrainedWidth,
          height: constrainedWidth + 10,
          child: TableCells(
            heatMap: widget.heatMap,
            tIndex: widget.tIndex,
            width: constrainedWidth,
          ),
        ),
      ])
    ]);
  }
}
