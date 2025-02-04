import 'package:flutter/material.dart';

class walkthroughLast extends StatefulWidget {
  const walkthroughLast(
      {super.key,
      required this.onNextTap,
      required this.onPreviousTap,
      required this.resetWalkthrough,
      required this.skipWalkthrough});

  final VoidCallback onNextTap;
  final VoidCallback onPreviousTap;
  final VoidCallback resetWalkthrough;
  final VoidCallback skipWalkthrough;

  @override
  State<walkthroughLast> createState() => _walkthroughLastState();
}

class _walkthroughLastState extends State<walkthroughLast>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late AnimationController _opacityController;
  late AnimationController _dataController;
  late Animation<Offset> _dataAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(1.5, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _dataController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _dataAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _dataController,
      curve: Curves.easeInOut,
    ));

    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _opacityController.forward().then((_) {
      _dataController.forward();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _dataController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;

    return FadeTransition(
        opacity: _opacityController,
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            clipBehavior: Clip.none,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                    child: Column(
                  children: [
                    SizedBox(
                      width: width,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const SizedBox(height: 10),
                          Positioned(
                            top: -40,
                            right: -40,
                            child: SlideTransition(
                              position: _animation,
                              child: Opacity(
                                  opacity: 0.6,
                                  child: Image.asset(
                                    'assets/logoBack.png',
                                    height: width * 6 / 5,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SlideTransition(
                        position: _dataAnimation,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                                onPressed: widget.onPreviousTap,
                                icon: Image.asset(
                                  'assets/icons/arrowLeft.png',
                                  width: 16,
                                  height: 16,
                                )))),
                    const SizedBox(
                      height: 10,
                    ),
                    SlideTransition(
                        position: _dataAnimation,
                        child: SizedBox(
                          width: width,
                          child: const Text(
                            'Great Job!',
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    SlideTransition(
                        position: _dataAnimation,
                        child: SizedBox(
                          width: width,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Continue to ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Ta',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'bb',
                                      style: TextStyle(
                                        color: Color(0xFF137D39),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'ller',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    SlideTransition(
                        position: _dataAnimation,
                        child: SizedBox(
                          width: width,
                          child: const Text(
                            "You have completed the walkthrough",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                )),
                SlideTransition(
                    position: _dataAnimation,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _dataController.reverse();
                                      _controller.reverse().then((_) {
                                        _opacityController.reverse().then((_) {
                                          Navigator.pop(context);
                                        });
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/icons/walkthrough.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  const Text(
                                    "Let's Begin",
                                    style: TextStyle(
                                        color: Color(0xff65C385), fontSize: 12),
                                  )
                                ],
                              )),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: GestureDetector(
                              onTap: widget.resetWalkthrough,
                              child: Image.asset(
                                'assets/icons/walkthroughAgain.png',
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
