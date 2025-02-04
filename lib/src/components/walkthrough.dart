import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:tabbller/src/components/rangeSelect.dart';
import 'package:tabbller/src/components/walkthroughFirst.dart';
import 'package:tabbller/src/components/walkthroughLast.dart';
import 'package:tabbller/src/components/warning.dart';
import 'package:tabbller/src/functions/question.dart';
import 'package:tabbller/src/pages/difficulty.dart';

class WalkThroughTopOverlay extends StatefulWidget {
  const WalkThroughTopOverlay({super.key, required this.tabelSwitch});

  final Function(int) tabelSwitch;

  @override
  // ignore: library_private_types_in_public_api
  _WalkThroughTopOverlayState createState() => _WalkThroughTopOverlayState();
}

class _WalkThroughTopOverlayState extends State<WalkThroughTopOverlay> {
  int walkThroughProgress = 1;
  int prevWalkThroughProgress = 1;
  double topPaddingHole1 = 150;
  double topPaddingHole2 = 210;

  void onPreviousTap() {
    if (walkThroughProgress > 7 && walkThroughProgress < 10) {
      widget.tabelSwitch(1);
    } else if (walkThroughProgress == 10) {
      widget.tabelSwitch(2);
    } else if (walkThroughProgress == 11) {
      widget.tabelSwitch(4);
    } else if (walkThroughProgress == 12 || walkThroughProgress == 13) {
      widget.tabelSwitch(3);
    } else {
      widget.tabelSwitch(0);
    }
    setState(() {
      prevWalkThroughProgress = walkThroughProgress;
      walkThroughProgress = walkThroughProgress - 1;
    });
  }

  void onNextTap() {
    if (walkThroughProgress > 5 && walkThroughProgress < 8) {
      widget.tabelSwitch(1);
    } else if (walkThroughProgress == 8) {
      widget.tabelSwitch(2);
    } else if (walkThroughProgress == 9) {
      widget.tabelSwitch(4);
    } else if (walkThroughProgress == 10 || walkThroughProgress == 11) {
      widget.tabelSwitch(3);
    } else {
      widget.tabelSwitch(0);
    }
    setState(() {
      prevWalkThroughProgress = walkThroughProgress;
      walkThroughProgress = walkThroughProgress + 1;
    });
  }

  void skipWalkthrough() {
    skipDialogue(context);
    widget.tabelSwitch(0);
  }

  void resetWalkthrough() {
    setState(() {
      prevWalkThroughProgress = walkThroughProgress;
      walkThroughProgress = 1;
    });
    widget.tabelSwitch(0);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height -
        mediaQuery.padding.bottom -
        mediaQuery.padding.top;
    return PopScope(
        canPop: false,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
                child: Stack(
              children: [
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      );
                      final leftAnimation = Tween<Offset>(
                              begin: const Offset(-1, 0),
                              end: const Offset(0, 0))
                          .animate(curvedAnimation);
                      final rightAnimation = Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: const Offset(0, 0))
                          .animate(curvedAnimation);
                      return SlideTransition(
                        position: child.key == ValueKey(walkThroughProgress)
                            ? prevWalkThroughProgress > walkThroughProgress
                                ? leftAnimation
                                : rightAnimation
                            : prevWalkThroughProgress > walkThroughProgress
                                ? rightAnimation
                                : leftAnimation,
                        child: child,
                      );
                    },
                    child: Stack(key: ValueKey(walkThroughProgress), children: [
                      Container(color: Colors.transparent),
                      walkThroughProgress == 1
                          ? SizedBox(
                              width: width,
                              height: height,
                              child: walkthroughFirst(
                                onNextTap: onNextTap,
                                onPreviousTap: onPreviousTap,
                                skipWalkthrough: skipWalkthrough,
                              ),
                            )
                          : walkThroughProgress == 2
                              ? Stack(
                                  children: [
                                    BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5, sigmaY: 5),
                                        child: Container(
                                          width: width,
                                          height: height,
                                          color: Colors.black.withOpacity(0.25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 30),
                                                child: GestureDetector(
                                                  onTap: onPreviousTap,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30),
                                                    decoration:
                                                        const BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF0A2112),
                                                          Color(0xFF000000),
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                100),
                                                        bottomRight:
                                                            Radius.circular(
                                                                100),
                                                      ),
                                                    ),
                                                    width:
                                                        width / 2 - width / 20,
                                                    height: height,
                                                    child: const Center(
                                                      child: Text(
                                                          "Tap here to view previous page",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 30),
                                                  child: GestureDetector(
                                                    onTap: onNextTap,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              40),
                                                      decoration:
                                                          const BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xFF0A2112),
                                                            Color(0xFF000000),
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  100),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  100),
                                                        ),
                                                      ),
                                                      width: width / 2 -
                                                          width / 20,
                                                      height: height,
                                                      child: const Center(
                                                        child: Text(
                                                          "Tap here to view next page",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ))
                                  ],
                                )
                              : walkThroughProgress == 3
                                  ? Stack(
                                      children: [
                                        BlurredOverlay(
                                          hole1OffsetX: width / 2,
                                          hole1OffsetY: topPaddingHole1,
                                          hole1Width:
                                              width > 500 ? 460 : width - 40,
                                          hole1Height: 70,
                                          hole2OffsetX: width / 2,
                                          hole2OffsetY: (width - 70) > 400
                                              ? (400 * 5 / 6 +
                                                          (400 * 5 / 6 - 8) /
                                                              5 +
                                                          34) /
                                                      2 +
                                                  topPaddingHole2
                                              : ((width - 70) * 5 / 6 +
                                                          ((width - 70) *
                                                                      5 /
                                                                      6 -
                                                                  8) /
                                                              5 +
                                                          34) /
                                                      2 +
                                                  topPaddingHole2,
                                          hole2Width: (width - 70) > 400
                                              ? 400 * 5 / 6 +
                                                  (400 * 5 / 6 - 8) / 5 +
                                                  24
                                              : (width - 70) * 5 / 6 +
                                                  ((width - 70) * 5 / 6 - 8) /
                                                      5 +
                                                  24,
                                          hole2Height: (width - 70) > 400
                                              ? 400 * 5 / 6 +
                                                  (400 * 5 / 6 - 8) / 5 +
                                                  34
                                              : (width - 70) * 5 / 6 +
                                                  ((width - 70) * 5 / 6 - 8) /
                                                      5 +
                                                  34,
                                        ),
                                        Positioned(
                                            top: 55,
                                            left: width > 500
                                                ? (width - 480) / 2
                                                : 25,
                                            child: SizedBox(
                                              width: width - 60,
                                              child: const Text(
                                                "See what you want to learn.",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            )),
                                        Positioned(
                                          top: topPaddingHole1,
                                          left: width > 500
                                              ? (width - 480) / 2 + 480 / 12
                                              : (width - 20) / 12 + 25,
                                          child: Image.asset(
                                            'assets/icons/tap.png',
                                            width: 60,
                                            height: 90,
                                          ),
                                        ),
                                      ],
                                    )
                                  : walkThroughProgress == 4
                                      ? Stack(children: [
                                          BlurredOverlay(
                                            hole1OffsetX: width > 500
                                                ? (width - 480) / 2 + 480 / 12
                                                : (width - 20) / 12 + 25,
                                            hole1OffsetY: topPaddingHole1,
                                            hole1Width: width > 500
                                                ? 480 / 6
                                                : (width - 20) / 6,
                                            hole1Height: 70,
                                            hole2OffsetX: width / 2,
                                            hole2OffsetY: (width - 70) > 400
                                                ? (400 * 5 / 6 +
                                                            (400 * 5 / 6 - 8) /
                                                                5 +
                                                            34) /
                                                        2 +
                                                    topPaddingHole2
                                                : ((width - 70) * 5 / 6 +
                                                            ((width - 70) *
                                                                        5 /
                                                                        6 -
                                                                    8) /
                                                                5 +
                                                            34) /
                                                        2 +
                                                    topPaddingHole2,
                                            hole2Width: (width - 70) > 400
                                                ? 400 * 5 / 6 +
                                                    (400 * 5 / 6 - 8) / 5 +
                                                    24
                                                : (width - 70) * 5 / 6 +
                                                    ((width - 70) * 5 / 6 - 8) /
                                                        5 +
                                                    24,
                                            hole2Height: (width - 70) > 400
                                                ? 400 * 5 / 6 +
                                                    (400 * 5 / 6 - 8) / 5 +
                                                    34
                                                : (width - 70) * 5 / 6 +
                                                    ((width - 70) * 5 / 6 - 8) /
                                                        5 +
                                                    34,
                                          ),
                                          Positioned(
                                              top: 55,
                                              left: width > 500
                                                  ? (width - 480) / 2
                                                  : 25,
                                              child: SizedBox(
                                                width: width - 60,
                                                child: const Text(
                                                  "Multiplication Table",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                  textAlign: TextAlign.left,
                                                ),
                                              )),
                                        ])
                                      : walkThroughProgress == 5
                                          ? Stack(children: [
                                              BlurredOverlay(
                                                hole1OffsetX: 0,
                                                hole1OffsetY: 0,
                                                hole1Width: 0,
                                                hole1Height: 0,
                                                hole2OffsetX: width / 2,
                                                hole2OffsetY: (width - 70) > 400
                                                    ? (400 * 5 / 6 +
                                                                (400 * 5 / 6 -
                                                                        8) /
                                                                    5 +
                                                                24) /
                                                            2 +
                                                        topPaddingHole2
                                                    : ((width - 70) * 5 / 6 +
                                                                ((width - 70) *
                                                                            5 /
                                                                            6 -
                                                                        8) /
                                                                    5 +
                                                                24) /
                                                            2 +
                                                        topPaddingHole2,
                                                hole2Width: (width - 70) > 400
                                                    ? 400 * 5 / 6 +
                                                        (400 * 5 / 6 - 8) / 5 +
                                                        24
                                                    : (width - 70) * 5 / 6 +
                                                        ((width - 70) * 5 / 6 -
                                                                8) /
                                                            5 +
                                                        24,
                                                hole2Height: (width - 70) > 400
                                                    ? 400 * 5 / 6 +
                                                        (400 * 5 / 6 - 8) / 5 +
                                                        24
                                                    : (width - 70) * 5 / 6 +
                                                        ((width - 70) * 5 / 6 -
                                                                8) /
                                                            5 +
                                                        24,
                                              ),
                                              Positioned(
                                                  top: 55,
                                                  left: width > 500
                                                      ? (width - 480) / 2
                                                      : 25,
                                                  child: SizedBox(
                                                    width: width - 60,
                                                    child: const Text(
                                                      "Scroll the table around to view more.",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                  )),
                                              Positioned(
                                                top: (width - 60 >= 500
                                                            ? 500
                                                            : width -
                                                                width / 10) /
                                                        2 +
                                                    278,
                                                left: 20 + (width / 2),
                                                child: Image.asset(
                                                  'assets/icons/scroll.png',
                                                  width: 60,
                                                  height: 90,
                                                ),
                                              ),
                                            ])
                                          : walkThroughProgress == 6
                                              ? Stack(
                                                  children: [
                                                    BlurredOverlay(
                                                      hole1OffsetX: width / 2,
                                                      hole1OffsetY: (width -
                                                                  70) >
                                                              400
                                                          ? 400 * 5 / 6 +
                                                              (400 * 5 / 6 -
                                                                      8) /
                                                                  5 +
                                                              80 +
                                                              topPaddingHole2
                                                          : (width - 70) *
                                                                  5 /
                                                                  6 +
                                                              ((width - 70) *
                                                                          5 /
                                                                          6 -
                                                                      8) /
                                                                  5 +
                                                              80 +
                                                              topPaddingHole2,
                                                      hole1Width: width > 500
                                                          ? 460
                                                          : width - 40,
                                                      hole1Height: 80,
                                                      hole2OffsetX: width / 2,
                                                      hole2OffsetY: (width -
                                                                  70) >
                                                              400
                                                          ? (400 * 5 / 6 +
                                                                      (400 * 5 / 6 -
                                                                              8) /
                                                                          5 +
                                                                      34) /
                                                                  2 +
                                                              topPaddingHole2
                                                          : ((width - 70) *
                                                                          5 /
                                                                          6 +
                                                                      ((width - 70) * 5 / 6 -
                                                                              8) /
                                                                          5 +
                                                                      34) /
                                                                  2 +
                                                              topPaddingHole2,
                                                      hole2Width: (width - 70) >
                                                              400
                                                          ? 400 * 5 / 6 +
                                                              (400 * 5 / 6 -
                                                                      8) /
                                                                  5 +
                                                              24
                                                          : (width - 70) *
                                                                  5 /
                                                                  6 +
                                                              ((width - 70) *
                                                                          5 /
                                                                          6 -
                                                                      8) /
                                                                  5 +
                                                              24,
                                                      hole2Height: (width -
                                                                  70) >
                                                              400
                                                          ? 400 * 5 / 6 +
                                                              (400 * 5 / 6 -
                                                                      8) /
                                                                  5 +
                                                              34
                                                          : (width - 70) *
                                                                  5 /
                                                                  6 +
                                                              ((width - 70) *
                                                                          5 /
                                                                          6 -
                                                                      8) /
                                                                  5 +
                                                              34,
                                                    ),
                                                    Positioned(
                                                        top: 55,
                                                        left: width > 500
                                                            ? (width - 480) / 2
                                                            : 25,
                                                        child: SizedBox(
                                                          width: width - 60,
                                                          child: const Text(
                                                            "Tap to change the table range",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        )),
                                                    Positioned(
                                                      top: (width - 70) > 400
                                                          ? 400 * 5 / 6 +
                                                              (400 * 5 / 6 -
                                                                      8) /
                                                                  5 +
                                                              90 +
                                                              topPaddingHole2
                                                          : (width - 70) *
                                                                  5 /
                                                                  6 +
                                                              ((width - 70) *
                                                                          5 /
                                                                          6 -
                                                                      8) /
                                                                  5 +
                                                              90 +
                                                              topPaddingHole2,
                                                      right: width > 500
                                                          ? (width - 480) / 2 +
                                                              20
                                                          : 20,
                                                      child: Image.asset(
                                                        'assets/icons/tap.png',
                                                        width: 60,
                                                        height: 90,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : walkThroughProgress == 7
                                                  ? Stack(children: [
                                                      BlurredOverlay(
                                                        hole1OffsetX: width >
                                                                500
                                                            ? (width - 480) /
                                                                    4 +
                                                                20 +
                                                                width / 4
                                                            : ((width - 20) /
                                                                            12 +
                                                                        25) /
                                                                    2 +
                                                                width / 4,
                                                        hole1OffsetY:
                                                            topPaddingHole1,
                                                        hole1Width: width > 500
                                                            ? 480 / 6
                                                            : (width - 20) / 6,
                                                        hole1Height: 70,
                                                        hole2OffsetX: width / 2,
                                                        hole2OffsetY: (width -
                                                                    60) >
                                                                375
                                                            ? 405 / 2 +
                                                                topPaddingHole2
                                                            : (width - 50) / 2 +
                                                                topPaddingHole2,
                                                        hole2Width:
                                                            (width - 60) > 375
                                                                ? 395
                                                                : (width - 60),
                                                        hole2Height:
                                                            (width - 60) > 375
                                                                ? 405
                                                                : (width - 50),
                                                      ),
                                                      Positioned(
                                                          top: 55,
                                                          left: width > 500
                                                              ? (width - 500) /
                                                                      2 -
                                                                  100
                                                              : -width / 5,
                                                          child: SizedBox(
                                                            width: width > 500
                                                                ? 500
                                                                : width,
                                                            child: const Text(
                                                              "Squares Table",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          )),
                                                    ])
                                                  : walkThroughProgress == 8
                                                      ? Stack(children: [
                                                          BlurredOverlay(
                                                            hole1OffsetX: 0,
                                                            hole1OffsetY: 0,
                                                            hole1Width: 0,
                                                            hole1Height: 0,
                                                            hole2OffsetX:
                                                                width / 2,
                                                            hole2OffsetY: (width -
                                                                        60) >
                                                                    375
                                                                ? 405 / 2 +
                                                                    topPaddingHole2
                                                                : (width - 50) /
                                                                        2 +
                                                                    topPaddingHole2,
                                                            hole2Width: (width -
                                                                        60) >
                                                                    375
                                                                ? 395
                                                                : (width - 60),
                                                            hole2Height:
                                                                (width - 60) >
                                                                        375
                                                                    ? 405
                                                                    : (width -
                                                                        50),
                                                          ),
                                                          Positioned(
                                                              top: 55,
                                                              left: width > 500
                                                                  ? (width -
                                                                          480) /
                                                                      2
                                                                  : 25,
                                                              child: SizedBox(
                                                                width:
                                                                    width - 60,
                                                                child:
                                                                    const Text(
                                                                  "Scroll the table up to view more.",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                              )),
                                                          Positioned(
                                                            top: (width - 60 >=
                                                                            500
                                                                        ? 500
                                                                        : width -
                                                                            width /
                                                                                10) /
                                                                    2 +
                                                                278,
                                                            left: 20 +
                                                                (width / 2),
                                                            child: Image.asset(
                                                              'assets/icons/scroll.png',
                                                              width: 60,
                                                              height: 90,
                                                            ),
                                                          ),
                                                        ])
                                                      : walkThroughProgress == 9
                                                          ? Stack(children: [
                                                              BlurredOverlay(
                                                                hole1OffsetX:
                                                                    width / 2,
                                                                hole1OffsetY:
                                                                    topPaddingHole1,
                                                                hole1Width: width >
                                                                        500
                                                                    ? 480 / 6
                                                                    : (width -
                                                                            20) /
                                                                        6,
                                                                hole1Height: 70,
                                                                hole2OffsetX:
                                                                    width / 2,
                                                                hole2OffsetY: (width -
                                                                            60) >
                                                                        375
                                                                    ? (395 * 4 / 5 +
                                                                                4) /
                                                                            2 +
                                                                        topPaddingHole2
                                                                    : ((width - 60) * 4 / 5 +
                                                                                4) /
                                                                            2 +
                                                                        topPaddingHole2,
                                                                hole2Width:
                                                                    (width - 60) >
                                                                            375
                                                                        ? 395
                                                                        : (width -
                                                                            60),
                                                                hole2Height: (width -
                                                                            60) >
                                                                        375
                                                                    ? 395 *
                                                                            4 /
                                                                            5 +
                                                                        4
                                                                    : (width - 60) *
                                                                            4 /
                                                                            5 +
                                                                        4,
                                                              ),
                                                              Positioned(
                                                                  top: 55,
                                                                  left: 30,
                                                                  child:
                                                                      SizedBox(
                                                                    width:
                                                                        width -
                                                                            60,
                                                                    child:
                                                                        const Text(
                                                                      "Cubes Table.",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              20),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  )),
                                                            ])
                                                          : walkThroughProgress ==
                                                                  10
                                                              ? Stack(
                                                                  children: [
                                                                      BlurredOverlay(
                                                                        hole1OffsetX: width >
                                                                                500
                                                                            ? width * 3 / 4 -
                                                                                ((width - 480) / 4 + 20)
                                                                            : width * 3 / 4 - ((width - 20) / 12 + 25) / 2,
                                                                        hole1OffsetY:
                                                                            topPaddingHole1,
                                                                        hole1Width: width > 500
                                                                            ? 480 /
                                                                                6
                                                                            : (width - 20) /
                                                                                6,
                                                                        hole1Height:
                                                                            70,
                                                                        hole2OffsetX:
                                                                            width /
                                                                                2,
                                                                        hole2OffsetY: (width - 60) > 375
                                                                            ? (395 * 4 / 5 + 4) / 2 +
                                                                                topPaddingHole2
                                                                            : ((width - 60) * 4 / 5 + 4) / 2 +
                                                                                topPaddingHole2,
                                                                        hole2Width: (width - 60) >
                                                                                375
                                                                            ? 395
                                                                            : (width -
                                                                                60),
                                                                        hole2Height: (width - 60) > 375
                                                                            ? 395 * 4 / 5 +
                                                                                4
                                                                            : (width - 60) * 4 / 5 +
                                                                                4,
                                                                      ),
                                                                      Positioned(
                                                                          top:
                                                                              55,
                                                                          right: width > 500
                                                                              ? (width - 500) / 2 -
                                                                                  100
                                                                              : -width /
                                                                                  5,
                                                                          child:
                                                                              SizedBox(
                                                                            width: width > 500
                                                                                ? 500
                                                                                : width,
                                                                            child:
                                                                                const Text(
                                                                              "Powers Table.",
                                                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          )),
                                                                    ])
                                                              : walkThroughProgress ==
                                                                      11
                                                                  ? Stack(
                                                                      children: [
                                                                          BlurredOverlay(
                                                                            hole1OffsetX: width > 500
                                                                                ? width - ((width - 480) / 2 + 480 / 12)
                                                                                : width - ((width - 20) / 12 + 25),
                                                                            hole1OffsetY:
                                                                                topPaddingHole1,
                                                                            hole1Width: width > 500
                                                                                ? 480 / 6
                                                                                : (width - 20) / 6,
                                                                            hole1Height:
                                                                                70,
                                                                            hole2OffsetX:
                                                                                width / 2,
                                                                            hole2OffsetY: (width - 60) > 375
                                                                                ? 405 / 2 + topPaddingHole2
                                                                                : (width - 50) / 2 + topPaddingHole2,
                                                                            hole2Width: (width - 60) > 375
                                                                                ? 395
                                                                                : (width - 60),
                                                                            hole2Height: (width - 60) > 375
                                                                                ? 405
                                                                                : (width - 50),
                                                                          ),
                                                                          Positioned(
                                                                              top: 55,
                                                                              right: width > 500 ? (width - 480) / 2 : 25,
                                                                              child: SizedBox(
                                                                                width: width - 60,
                                                                                child: const Text(
                                                                                  "Prime Numbers Table.",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                  textAlign: TextAlign.right,
                                                                                ),
                                                                              )),
                                                                        ])
                                                                  : walkThroughProgress ==
                                                                          12
                                                                      ? Stack(
                                                                          children: [
                                                                              BlurredOverlay(
                                                                                hole1OffsetX: 0,
                                                                                hole1OffsetY: 0,
                                                                                hole1Width: 0,
                                                                                hole1Height: 0,
                                                                                hole2OffsetX: width / 2,
                                                                                hole2OffsetY: (width - 60) > 375 ? 405 / 2 + topPaddingHole2 : (width - 50) / 2 + topPaddingHole2,
                                                                                hole2Width: (width - 60) > 375 ? 395 : (width - 60),
                                                                                hole2Height: (width - 60) > 375 ? 405 : (width - 50),
                                                                              ),
                                                                              Positioned(
                                                                                  top: 55,
                                                                                  left: width > 500 ? (width - 480) / 2 : 25,
                                                                                  child: SizedBox(
                                                                                    width: width - 60,
                                                                                    child: const Text(
                                                                                      "Scroll the table up to view more.",
                                                                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                    ),
                                                                                  )),
                                                                              Positioned(
                                                                                top: (width - 60 >= 500 ? 500 : width - width / 10) / 2 + 248,
                                                                                left: 20 + (width / 2),
                                                                                child: Image.asset(
                                                                                  'assets/icons/scroll.png',
                                                                                  width: 60,
                                                                                  height: 90,
                                                                                ),
                                                                              ),
                                                                            ])
                                                                      : walkThroughProgress ==
                                                                              13
                                                                          ? Stack(children: [
                                                                              BlurredOverlay(
                                                                                hole1OffsetX: 0,
                                                                                hole1OffsetY: 0,
                                                                                hole1Width: 0,
                                                                                hole1Height: 0,
                                                                                hole2OffsetX: width >= 500 ? width - 65 - (width - 500) / 2 : width - 65,
                                                                                hole2OffsetY: height - 53,
                                                                                hole2Width: 65,
                                                                                hole2Height: 65,
                                                                              ),
                                                                              Positioned(
                                                                                  bottom: 160,
                                                                                  left: width > 500 ? (width - 480) / 2 : 10,
                                                                                  child: SizedBox(
                                                                                    width: width > 500 ? 480 : width - 20,
                                                                                    child: const Text(
                                                                                      "Heatmap - Analyze your learning levels with the heatmap and reach mastered by completing quizzes.",
                                                                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                      textAlign: TextAlign.right,
                                                                                    ),
                                                                                  )),
                                                                              Positioned(
                                                                                bottom: 35,
                                                                                right: width >= 500 ? 65 + (width - 500) / 2 : 65,
                                                                                child: Image.asset(
                                                                                  'assets/icons/tapRight.png',
                                                                                  width: 90,
                                                                                  height: 90,
                                                                                ),
                                                                              ),
                                                                            ])
                                                                          : walkThroughProgress == 14
                                                                              ? Stack(children: [
                                                                                  const BlurredOverlay(
                                                                                    hole1OffsetX: 0,
                                                                                    hole1OffsetY: 0,
                                                                                    hole1Width: 0,
                                                                                    hole1Height: 0,
                                                                                    hole2OffsetX: 0,
                                                                                    hole2OffsetY: 0,
                                                                                    hole2Width: 0,
                                                                                    hole2Height: 0,
                                                                                  ),
                                                                                  Positioned(
                                                                                    bottom: 40,
                                                                                    right: width >= 500 ? (width - 400) / 2 : 30,
                                                                                    child: Image.asset(
                                                                                      'assets/heatmap.png',
                                                                                      width: width >= 500 ? 400 : width - 60,
                                                                                      height: width >= 500 ? 400 * 1324 / 913 : (width - 60) * 1324 / 913,
                                                                                    ),
                                                                                  ),
                                                                                ])
                                                                              : walkThroughProgress == 15
                                                                                  ? Stack(children: [
                                                                                      BlurredOverlay(
                                                                                        hole1OffsetX: 0,
                                                                                        hole1OffsetY: 0,
                                                                                        hole1Width: 0,
                                                                                        hole1Height: 0,
                                                                                        hole2OffsetX: width / 2,
                                                                                        hole2OffsetY: height - 53,
                                                                                        hole2Width: width >= 460 ? 290 : width - 170,
                                                                                        hole2Height: 65,
                                                                                      ),
                                                                                      Positioned(
                                                                                          bottom: 160,
                                                                                          left: width > 500 ? (width - 480) / 2 : 10,
                                                                                          child: SizedBox(
                                                                                            width: width > 500 ? 480 : width - 20,
                                                                                            child: const Text(
                                                                                              "Attend Quizzes to improve your learning",
                                                                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                          )),
                                                                                      Positioned(
                                                                                        bottom: 30,
                                                                                        left: width / 2 + 40,
                                                                                        child: Image.asset(
                                                                                          'assets/icons/tapLeft.png',
                                                                                          width: 90,
                                                                                          height: 90,
                                                                                        ),
                                                                                      ),
                                                                                    ])
                                                                                  : walkThroughProgress == 16
                                                                                      ? const Stack(children: [
                                                                                          RangeSelectionDialog(),
                                                                                        ])
                                                                                      : walkThroughProgress == 17
                                                                                          ? Container(
                                                                                              color: Colors.transparent,
                                                                                              child: const Stack(children: [
                                                                                                DifficultyPage(
                                                                                                  type: QuestionType.square,
                                                                                                  selectedTables: [1, 2],
                                                                                                )
                                                                                              ]),
                                                                                            )
                                                                                          : walkThroughProgress == 18
                                                                                              ? SizedBox(
                                                                                                  width: width,
                                                                                                  height: height,
                                                                                                  child: walkthroughLast(
                                                                                                    onNextTap: onNextTap,
                                                                                                    onPreviousTap: onPreviousTap,
                                                                                                    resetWalkthrough: resetWalkthrough,
                                                                                                    skipWalkthrough: skipWalkthrough,
                                                                                                  ),
                                                                                                )
                                                                                              : const SizedBox(
                                                                                                  height: 20,
                                                                                                ),
                    ])),
                if (walkThroughProgress >= 3 && walkThroughProgress <= 17)
                  NavigationButtons(
                    onNextTap: onNextTap,
                    onPreviousTap: onPreviousTap,
                    skipWalkthrough: skipWalkthrough,
                  )
              ],
            ))));
  }

  Future<void> skipDialogue(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return popDialogue(
              onConfirm: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              onCancel: () {
                Navigator.pop(context);
              },
              accept: 'Yes',
              reject: 'No',
              message: 'Do you want to skip the walkthrough?',
            );
          },
        );
      },
    );
  }
}

class BlurredOverlay extends StatelessWidget {
  final double hole1OffsetX;
  final double hole2OffsetX;
  final double hole1OffsetY;
  final double hole2OffsetY;
  final double hole1Width;
  final double hole2Width;
  final double hole1Height;
  final double hole2Height;

  const BlurredOverlay({
    super.key,
    required this.hole1Width,
    required this.hole2Width,
    required this.hole1Height,
    required this.hole2Height,
    required this.hole1OffsetX,
    required this.hole2OffsetX,
    required this.hole1OffsetY,
    required this.hole2OffsetY,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height -
        mediaQuery.padding.bottom -
        mediaQuery.padding.top;
    return SizedBox(
        width: width,
        height: height,
        child: ClipPath(
          clipper: HoleClipper([
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(hole1OffsetX, hole1OffsetY),
                width: hole1Width,
                height: hole1Height,
              ),
              const Radius.circular(12),
            ),
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(hole2OffsetX, hole2OffsetY),
                width: hole2Width,
                height: hole2Height,
              ),
              const Radius.circular(20),
            ),
          ]),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),
        ));
  }
}

class HoleClipper extends CustomClipper<Path> {
  final List<RRect> holes;

  HoleClipper(this.holes);

  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    for (var hole in holes) {
      path.addRRect(hole);
    }
    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(HoleClipper oldClipper) => oldClipper.holes != holes;
}

class NavigationButtons extends StatelessWidget {
  final VoidCallback onPreviousTap;
  final VoidCallback onNextTap;
  final VoidCallback skipWalkthrough;

  const NavigationButtons({
    super.key,
    required this.onPreviousTap,
    required this.onNextTap,
    required this.skipWalkthrough,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height -
        mediaQuery.padding.bottom -
        mediaQuery.padding.top;
    return SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onPreviousTap,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(width),
                        bottomRight: Radius.circular(height),
                      ),
                    ),
                    width: width / 2 - width / 20,
                    height: height,
                    child: const Center(
                      child: Text(
                        "Tap here to view previous page",
                        style:
                            TextStyle(color: Colors.transparent, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: skipWalkthrough,
                        child: Image.asset(
                          'assets/icons/walkthroughSkip.png',
                          width: 60,
                          height: 50,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onNextTap,
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(width),
                            bottomLeft: Radius.circular(height),
                          ),
                        ),
                        width: width / 2 - width / 20,
                        height: height - 80,
                        child: const Center(
                          child: Text(
                            "Tap here to view next page",
                            style: TextStyle(
                                color: Colors.transparent, fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
