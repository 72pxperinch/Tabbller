import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tabbller/src/components/tables.dart';
import 'package:tabbller/src/components/warning.dart';
import 'package:tabbller/src/components/footer.dart';
import 'package:tabbller/src/components/heatMap.dart';
import 'package:tabbller/src/components/walkthrough.dart';
import 'package:tabbller/src/components/multiplication.dart';

import 'package:tabbller/src/functions/apptimer.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';
import 'package:tabbller/src/functions/pageTransitions.dart';

import 'package:tabbller/src/pages/noInternet.dart';
import 'package:tabbller/src/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> with TickerProviderStateMixin {
  int globalIndex = 0;
  int prevGlobalIndex = 0;
  bool heatMapToggle = false;
  bool walkthroughOpen = false;
  bool _isOnline = true;

  late AnimationController appBarController;
  late AnimationController tabBarController;
  late AnimationController tableController;
  late AnimationController buttonsController;

  late Animation<double> appBarAnimation;
  late Animation<double> tabBarAnimation;
  late Animation<double> tableAnimation;
  late Animation<double> buttonsAnimation;

  @override
  void initState() {
    super.initState();
    AppUsageTrackerInterface.instance.appUsageTracker = AppUsageTracker();
    appBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    tabBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    tableController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    buttonsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    appBarAnimation = CurvedAnimation(
      parent: appBarController,
      curve: Curves.easeIn,
    );
    tabBarAnimation = CurvedAnimation(
      parent: tabBarController,
      curve: Curves.easeIn,
    );
    tableAnimation = CurvedAnimation(
      parent: tableController,
      curve: Curves.easeIn,
    );
    buttonsAnimation = CurvedAnimation(
      parent: buttonsController,
      curve: Curves.easeIn,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appBarController.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        tabBarController.forward();
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        tableController.forward();
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        buttonsController.forward();
      });

      Future.delayed(const Duration(milliseconds: 2000), () {
        determineWalkthrough();
      });
    });
  }

  @override
  void dispose() {
    appBarController.dispose();
    tabBarController.dispose();
    tableController.dispose();
    buttonsController.dispose();
    AppUsageTrackerInterface.instance.appUsageTracker?.dispose();
    super.dispose();
  }

  void determineWalkthrough() async {
    if (FirebaseStorageObjectInterface
            .instance.firebaseStorageObject!.showWalkthrough ??
        true) {
      FirebaseStorageObjectInterface
          .instance.firebaseStorageObject!.showWalkthrough = false;
      FirebaseStorageService.instance.updateFirebaseStorageObject(
          FirebaseUserInterface.instance.docId!,
          FirebaseStorageObjectInterface.instance.firebaseStorageObject!, context);
      openWalkthrough(context);
    }
  }

  void toggleheatMapToggle() {
    setState(() {
      heatMapToggle = !heatMapToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = (deviceWidth - 70) > 400 ? 400 : (deviceWidth - 70);
    width = width * 5 / 6;
    double cellWidthHeight = (width - 8) / 5;
    double height = width + 2 * cellWidthHeight + 29;
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          quitApp(context);
        },
        child: Scaffold(
          body: _isOnline
              ? Container(
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
                  child: Stack(
                    children: [
                      SafeArea(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              // _______________________________________________________ TOP __________________________________________________________

                              FadeTransition(
                                opacity: appBarAnimation,
                                child: PreferredSize(
                                  preferredSize: const Size.fromHeight(128),
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                        top: 15,
                                        left: 20,
                                        right: 20,
                                        bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Ta',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 28,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: 'bb',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF65C385),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 28,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: 'ller',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 28,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'Math is Mathing',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                ProfilePageTransition(
                                                    ProfilePage(
                                              onWalkthrough: () {
                                                openWalkthrough(context);
                                              },
                                            )));
                                          },
                                          child: Image.asset(
                                            'assets/icons/profile.png',
                                            width: 22,
                                            height: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // _______________________________________________________ TABBAR __________________________________________________________

                              const SizedBox(height: 20),
                              FadeTransition(
                                opacity: tabBarAnimation,
                                child: TabBarSection(
                                  currentIndex: globalIndex,
                                  onTap: (index) {
                                    setState(() {
                                      prevGlobalIndex = globalIndex;
                                      globalIndex = index;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 25),

                              // _______________________________________________________ TABLE __________________________________________________________

                              FadeTransition(
                                opacity: tableAnimation,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30, top: 15),
                                    child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          final curvedAnimation =
                                              CurvedAnimation(
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
                                            position: child.key ==
                                                    ValueKey(globalIndex)
                                                ? prevGlobalIndex > globalIndex
                                                    ? prevGlobalIndex == 4 &&
                                                            globalIndex == 3
                                                        ? rightAnimation
                                                        : leftAnimation
                                                    : prevGlobalIndex == 3 &&
                                                            globalIndex == 4
                                                        ? leftAnimation
                                                        : rightAnimation
                                                : prevGlobalIndex > globalIndex
                                                    ? prevGlobalIndex == 4 &&
                                                            globalIndex == 3
                                                        ? leftAnimation
                                                        : rightAnimation
                                                    : prevGlobalIndex == 3 &&
                                                            globalIndex == 4
                                                        ? rightAnimation
                                                        : leftAnimation,
                                            child: child,
                                          );
                                        },
                                        child: SizedBox(
                                          key: ValueKey(globalIndex),
                                          height: height + 10,
                                          child: _getScreen(globalIndex),
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),

                          // _______________________________________________________ FOOTER__________________________________________________________

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FadeTransition(
                                opacity: buttonsAnimation,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 36, right: 36, bottom: 28),
                                  child: BottomButtons(
                                    onShowHeatMap: (context, tIndex,
                                            selectedTables) =>
                                        showHeatMap(
                                            context, tIndex, selectedTables),
                                    tIndex: globalIndex,
                                    rebuild: () {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ],
                  ))
              : const NoInternetPage(),
        ));
  }

  Future<void> quitApp(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return popDialogue(
            onConfirm: () {
              // if (kIsWeb) {
              //   html.window.location.href = 'https://tabbller.pxlbyt.com';
              // } else
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            onCancel: () {
              Navigator.pop(context);
            },
            accept: 'Yes',
            reject: 'No',
            message: 'Do you want to quit the application?',
          );
        });
      },
    );
  }

  Future<void> openWalkthrough(BuildContext context) async {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return WalkThroughTopOverlay(
            tabelSwitch: (wIndex) {
              setState(() {
                prevGlobalIndex = globalIndex;
                globalIndex = wIndex;
              });
            },
          );
        },
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 1:
        return TableWidget(
          tIndex: globalIndex,
          heatMap: false,
        );
      case 2:
        return TableWidget(
          tIndex: globalIndex,
          heatMap: false,
        );
      case 3:
        return TableWidget(
          tIndex: globalIndex,
          heatMap: false,
        );
      case 4:
        return TableWidget(
          tIndex: globalIndex,
          heatMap: false,
        );
      default:
        return const MultiplicationTable();
    }
  }
}

// _______________________________________________________ TABBAR __________________________________________________________

class TabBarSection extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TabBarSection({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        width: 500,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTab('Table', 'assets/icons/table.png',
                'assets/icons/tableInactive.png', 0, context),
            _buildTab('Squares', 'assets/icons/square.png',
                'assets/icons/squareInactive.png', 1, context),
            _buildTab('Cubes', 'assets/icons/cube.png',
                'assets/icons/cubeInactive.png', 2, context),
            _buildTab('Powers', 'assets/icons/power.png',
                'assets/icons/powerInactive.png', 4, context),
            _buildTab('Prime', 'assets/icons/prime.png',
                'assets/icons/primeInactive.png', 3, context),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, String iconPath, String inactiveIconPath,
      int index, BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 500 ? 500 : deviceWidth;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          color: Colors.black.withOpacity(0),
          child: SizedBox(
            width: width / 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 23,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: index == currentIndex
                        ? Image.asset(
                            iconPath,
                          )
                        : Image.asset(
                            inactiveIconPath,
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: index == currentIndex
                        ? const Color(0xFF65C385)
                        : const Color(0xFFC5C5C5),
                    fontWeight: index == currentIndex
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
