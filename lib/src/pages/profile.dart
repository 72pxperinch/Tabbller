import 'package:flutter/material.dart';
import 'package:tabbller/src/functions/apptimer.dart';
import 'package:tabbller/src/functions/data.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';
import 'dart:math';
import 'package:tabbller/src/pages/quizHistory.dart';
import 'package:tabbller/src/pages/settings.dart';

class ProfilePage extends StatefulWidget implements PreferredSizeWidget {
  const ProfilePage({super.key, required this.onWalkthrough});
  final VoidCallback onWalkthrough;

  @override
  _ProfilePageState createState() => _ProfilePageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  bool isEditOn = false;
  String userName =
      FirebaseUserInterface.instance.userName ?? "[Enter User Name]";
  late TextEditingController _controller;
  double totalPercent = 50;
  List<double> percentages = [];

  late AnimationController _totalAnimationController;
  late Animation<double> totalPercentageAni;
  late List<AnimationController> _percentageControllers;
  late List<Animation<double>> percentageAni;
  late int? appTimeinS;

  bool _isPressedQuizHistory = false;

  @override
  void initState() {
    super.initState();
    AppUsageTrackerInterface.instance.appUsageTracker!.triggerTimeCalc(true);
    appTimeinS = AppUsageTrackerInterface.instance.appUsageTracker?.totalForegroundTime.inSeconds;
    _controller = TextEditingController(text: userName);

    _totalAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    calcPercentages();
    totalPercentageAni = Tween<double>(begin: 0, end: totalPercent).animate(
      CurvedAnimation(parent: _totalAnimationController, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {});
      });

    _totalAnimationController.forward();
    _percentageControllers = List.generate(
      percentages.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      ),
    );

    percentageAni = List.generate(
      percentages.length,
      (index) =>
          Tween<double>(begin: 0, end: percentages[index].toDouble()).animate(
        CurvedAnimation(
            parent: _percentageControllers[index], curve: Curves.easeOut),
      )..addListener(() {
              setState(() {});
            }),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
    for (var controller in _percentageControllers) {
      controller.forward();
    }});
  }

  @override
  void dispose() {
    _controller.dispose();
    _totalAnimationController.dispose();
    for (var controller in _percentageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void calcPercentages() {
    int completedSum = 0;
    int totalSum = 0;
    for (int i = 0; i < 5; i++) {
      int totalCount = 0;
      int completedCount = 0;
      List<Level> levelData = FirebaseStorageObjectInterface
          .instance.firebaseStorageObject!.learningProgresses[i].levelData
          .expand((e) => e)
          .toList();
      for (int j = 0; j < levelData.length; j++) {
        if (i == 4) {
          if (primeNumbers.contains(primeBar[j])) {
            if (levelData[j] == Level.level5) {
              completedCount = completedCount + 1;
            }
            totalCount = totalCount + 1;
          }
        } else {
          if (levelData[j] == Level.level5) {
            completedCount = completedCount + 1;
          }
          totalCount = totalCount + 1;
        }
      }
      percentages.add(((completedCount * 100) ~/ totalCount).toDouble());
      totalSum = totalSum + totalCount;
      completedSum = completedSum + completedCount;
    }
    totalPercent = ((completedSum * 100) ~/ totalSum).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
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
                child: SafeArea(
                  child: SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: SizedBox(
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                            alignment: Alignment.centerLeft,
                                            width: 30,
                                            height: 30,
                                            color: Colors.transparent,
                                            child: Image.asset(
                                              'assets/icons/arrowLeft.png',
                                              width: 16,
                                              height: 16,
                                            ))),
                                        GestureDetector(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            color: Colors.transparent,
                                            width: 30,
                                            height: 30,
                                            child: Image.asset(
                                            'assets/icons/settings.png',
                                            width: 25,
                                            height: 25,
                                            color: Colors.white,
                                          ),),
                                          onTap: () async{
                                            await showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return SettingsOverlay(
                                                  onWalkthrough:
                                                      widget.onWalkthrough,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Profile",
                                  style: TextStyle(
                                    color: Color(0xff65C385),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: isEditOn
                                            ? TextField(
                                                controller: _controller,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Enter your name",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white54),
                                                ),
                                                autofocus: true,
                                              )
                                            : Text(
                                                userName,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Image.asset(
                                        isEditOn
                                            ? 'assets/icons/ok.png'
                                            : 'assets/icons/edit.png',
                                        width: 24,
                                        height: 24,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isEditOn) {
                                            userName = _controller.text;
                                            FirebaseUserInterface.instance
                                                .userName = _controller.text;
                                            FirebaseStorageObjectInterface
                                                .instance
                                                .firebaseStorageObject!
                                                .userName = _controller.text;
                                            FirebaseStorageService.instance
                                                .updateFirebaseStorageObject(
                                                    FirebaseUserInterface
                                                        .instance.docId!,
                                                    FirebaseStorageObjectInterface
                                                        .instance
                                                        .firebaseStorageObject!, context);
                                          }
                                          isEditOn = !isEditOn;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  FirebaseStorageObjectInterface.instance.firebaseStorageObject?.phoneNumber ?? FirebaseStorageObjectInterface.instance.firebaseStorageObject?.emailID ?? 'Guest Account',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "This week's learning",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 6),
                                          child: Text(
                                            '${(appTimeinS ?? 0 )~/ 3600}h ${(appTimeinS ?? 0) ~/ 60}m',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTapDown: (_) => setState(() => _isPressedQuizHistory = true),
                                          onTapUp: (_) => setState(() => _isPressedQuizHistory = false),
                                          onTapCancel: () => setState(() => _isPressedQuizHistory = false),
                                          child: AnimatedScale(
                                            scale: _isPressedQuizHistory ? 0.9 : 1.0, // Shrink to 90% on press
                                            duration: const Duration(milliseconds: 100), // Quick animation
                                            curve: Curves.easeInOut,
                                              child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HistoryPage()));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xff1D3927),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 10),
                                                child: Text(
                                                  "Quiz History",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xffffffff)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CustomPaint(
                                          size: const Size(95, 95),
                                          painter: CirclePainter(
                                              totalPercentageAni.value,
                                              12,
                                              totalPercentageAni.value >= 70
                                                  ? const Color(0xff65C385)
                                                  : totalPercentageAni.value >=
                                                              30 &&
                                                          totalPercentageAni
                                                                  .value <
                                                              70
                                                      ? const Color(0xffD6C634)
                                                      : const Color(
                                                          0xffDC4646)),
                                        ),
                                        Positioned(
                                          top: 22,
                                          child: Text(
                                            '${totalPercentageAni.value.toStringAsFixed(0)}%',
                                            style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const Positioned(
                                          bottom: 30,
                                          child: Text(
                                            'Completed',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 30,
                            ),
                            Expanded(
                                child: Stack(
                              children: [
                                GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      List<Widget> widgets = [
                                        ProgressTile(
                                          title: "Multiplication Table",
                                          percentage: percentageAni[0].value,
                                          lineWidth: 8.0,
                                          size: 90,
                                          mode: 'table',
                                        ),
                                        ProgressTile(
                                          title: "Squares of numbers",
                                          percentage: percentageAni[1].value,
                                          lineWidth: 8.0,
                                          size: 90,
                                          mode: 'square',
                                        ),
                                        ProgressTile(
                                          title: "Cubes of numbers",
                                          percentage: percentageAni[2].value,
                                          lineWidth: 8.0,
                                          size: 90,
                                          mode: 'cube',
                                        ),
                                        ProgressTile(
                                          title: "Powers",
                                          percentage: percentageAni[3].value,
                                          lineWidth: 8.0,
                                          size: 90,
                                          mode: 'power',
                                        ),
                                        ProgressTile(
                                          title: "Prime numbers",
                                          percentage: percentageAni[4].value,
                                          lineWidth: 8.0,
                                          size: 90,
                                          mode: 'prime',
                                        ),
                                      ];
                                      return widgets[index];
                                    }),
                                Positioned(
                                    top: -40,
                                    left: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xff051009),
                                              spreadRadius: 0,
                                              blurRadius: 8,
                                              offset: Offset(0, 4)),
                                        ],
                                      ),
                                      child: const SizedBox(
                                        height: 40,
                                        width: 500,
                                      ),
                                    ))
                              ],
                            )),
                          ],
                        ),
                      ))),
                ))));
  }
}

class Bor {}

class ProgressTile extends StatelessWidget {
  final String title;
  final double percentage;
  final double lineWidth;
  final double size;
  final String mode;

  const ProgressTile({
    super.key,
    required this.title,
    required this.percentage,
    required this.lineWidth,
    required this.size,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    color = percentage >= 70
        ? const Color(0xff65C385)
        : percentage >= 30 && percentage < 70
            ? const Color(0xffD6C634)
            : const Color(0xffDC4646);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff08190E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(10),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            CircularProgressBar(
              percentage: percentage,
              lineWidth: lineWidth,
              color: color,
              size: size,
              mode: mode,
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class CircularProgressBar extends StatelessWidget {
  final double percentage;
  final double lineWidth;
  final Color color;
  final double size;
  final String mode;

  const CircularProgressBar(
      {super.key,
      required this.percentage,
      this.lineWidth = 10,
      required this.color,
      required this.size,
      required this.mode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20,
            child: Image.asset(
              'assets/icons/${mode}White.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
          CustomPaint(
            size: Size(size, size),
            painter: CirclePainter(percentage, lineWidth, color),
          ),
          Positioned(
            top: 50,
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 14,
                color: percentage < 30
                    ? const Color(0xffDC4646)
                    : percentage >= 70
                        ? const Color(0xff65C385)
                        : const Color(0xffD6C634),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double percentage;
  final double lineWidth;
  final Color color;

  CirclePainter(this.percentage, this.lineWidth, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = lineWidth
      ..color = const Color(0xff1D3927)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..strokeWidth = lineWidth
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2,
      paint,
    );

    double progressAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2),
      -pi / 2,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
