import 'package:flutter/material.dart';

class walkthroughFirst extends StatefulWidget {
  const walkthroughFirst(
      {super.key, required this.onNextTap, required this.onPreviousTap, required this.skipWalkthrough});

  final VoidCallback onNextTap;
  final VoidCallback onPreviousTap;
  final VoidCallback skipWalkthrough;

  @override
  State<walkthroughFirst> createState() => _walkthroughFirstState();
}

class _walkthroughFirstState extends State<walkthroughFirst>
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

    _opacityController.forward().then((_){
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
                      height: 80,
                    ),
                    SlideTransition(
                              position: _dataAnimation,
                              child:SizedBox(
                      width: width,
                      child: const Text(
                        'Hello!',
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
                              child:SizedBox(
                      width: width,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Welcome to ',
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
                              child:SizedBox(
                      width: width,
                      child: const Text(
                        "Let's Start Your Walkthrough",
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
                              child:Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width,
                        child: const Text(
                          'Dive into the world of multiplication tables, squares, cubes, and primes. Learn and memorize effortlessly, then test your skills with fun quizzes.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: const Text(
                          "Let’s make math your ultimate superpower!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 100,
                        height: 60,
                        child: GestureDetector(
                          onTap: widget.onNextTap,
                          child: Image.asset(
                            'assets/icons/walkthrough.png',
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: GestureDetector(
                          onTap: widget.skipWalkthrough,
                          child: Image.asset(
                            'assets/icons/walkthroughSkip.png',
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
