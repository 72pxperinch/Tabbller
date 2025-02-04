import 'package:flutter/material.dart';
import 'package:tabbller/src/functions/common.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';

class HeatMultiplicationTable extends StatefulWidget {
  HeatMultiplicationTable({
    super.key,
    required this.heatMap,
  });

  final bool heatMap;

  @override
  _HeatMultiplicationTableState createState() =>
      _HeatMultiplicationTableState();
}

class _HeatMultiplicationTableState extends State<HeatMultiplicationTable>
    with TickerProviderStateMixin {
  late TransformationController _controller;
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;
  late ScrollController _horizontalScrollController;
  late ScrollController _verticalScrollController;
  late AnimationController fadeAnimationController;
  late Animation<double> opacity;
  late double width;
  late double height;
  bool isVisible = false;

  void initFunction() {
    _controller = TransformationController();
    _horizontalScrollController = ScrollController();
    _verticalScrollController = ScrollController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _controller.addListener(_onTransformationChange);

    fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: fadeAnimationController, curve: Curves.easeIn));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _setInitialState();
      await Future.delayed(const Duration(milliseconds: 10));
      if (!mounted) return;
      fadeAnimationController.forward();
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() {
        isVisible = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void _onTransformationChange() {
    final translation = _controller.value.getTranslation();
    _horizontalScrollController.jumpTo(-translation.x);
    _verticalScrollController.jumpTo(-translation.y);
  }

  void _setInitialState() {
    final zoom = Matrix4.identity()..scale(5.0);
    _controller.value = zoom;
  }

  void _snapToNearestGrid() {
    final translation = _controller.value.getTranslation();
    final currentScale = _controller.value.getMaxScaleOnAxis();

    final gridWidth = (width / 25);

    final maxTranslationX = (width * 4 / 5);
    final maxTranslationY = ((width - 2 * 24 / 5) * 25 / 25 + 48 / 5) * 4 / 5;

    double snappedX = ((translation.x / 5) / gridWidth).round() * gridWidth;
    double snappedY = ((translation.y / 5) / gridWidth).round() * gridWidth;

    snappedX = snappedX.clamp(-maxTranslationX as num, 0).toDouble();
    snappedY = snappedY.clamp(-maxTranslationY as num, 0).toDouble();

    final snappedMatrix = Matrix4.identity()
      ..scale(currentScale)
      ..translate(snappedX, snappedY);

    _animation = Matrix4Tween(
      begin: _controller.value,
      end: snappedMatrix,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward(from: 0.0);
    _animationController.addListener(() {
      _controller.value = _animation.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    width = (deviceWidth - 60) > 400 ? 400 : (deviceWidth - 60);
    width = width * 5 / 6;
    height = (width - 2 * (25 - 1) / 5) * 25 / 25 + 48 / 5;
    return SizedBox(
      width: 400,
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Horizontal number list
            SizedBox(
              height: (width / 5) - 2,
              width: width,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: 25,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              width: (width / 5) - 2,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF08190E),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Vertical number list
                SizedBox(
                  width: (width / 5) - 3,
                  height: width,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _verticalScrollController,
                    itemCount: 25,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            height: (width * 5 - 2 * (25 - 1)) / 25,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF08190E),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                // Main grid
                Stack(
                  children: [
                    SizedBox(
                      width: width,
                      height: width,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        width: width,
                        height: height,
                        child: InteractiveViewer(
                          interactionEndFrictionCoefficient: 1e-100,
                          boundaryMargin: EdgeInsets.only(
                            top: 20 / 5,
                            left: 20 / 5,
                            right: 20 / 5,
                            bottom: (20 / 5) + (height - width) / 5,
                          ),
                          minScale: 5,
                          maxScale: 5,
                          transformationController: _controller,
                          onInteractionEnd: (details) => _snapToNearestGrid(),
                          child: const FullTableWidget(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        FadeTransition(
          opacity: opacity,
          child: Visibility(
            visible: !isVisible,
            child: Container(
              width: ((width - 8) / 5) * 6 + 15,
              height: ((width - 8) / 5) * 6 + 15,
              color: const Color(0xFF040C07),
              // color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformationChange);
    _controller.dispose();
    _animationController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }
}

class FullTableWidget extends StatelessWidget {
  const FullTableWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<int> selectedTables = List.generate(25, (index) => index + 1);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.antiAlias,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 25,
        childAspectRatio: 1,
        mainAxisSpacing: 2 / 5,
        crossAxisSpacing: 2 / 5,
      ),
      itemCount: 25 * 25,
      itemBuilder: (context, index) {
        int multiplier = (index ~/ 25) + 1;
        int tableIndex = index % 25;

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

        cellColor = colorMap[colorCode];

        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8 / 5, vertical: 12 / 5),
          decoration: BoxDecoration(
            color: cellColor,
            borderRadius: BorderRadius.circular(6 / 5),
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

class ScaleClipper extends CustomClipper<Rect> {
  final double startX;
  final double startY;
  final double width;
  final double height;

  ScaleClipper({
    required this.startX,
    required this.startY,
    required this.width,
    required this.height,
  });

  @override
  Rect getClip(Size size) {
    final double clipX = size.width * startX;
    final double clipY = size.height * startY;
    final double clipWidth = size.width * width;
    final double clipHeight = size.height * height;

    return Rect.fromLTWH(clipX, clipY, clipWidth, clipHeight);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
