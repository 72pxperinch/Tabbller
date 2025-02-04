import 'package:flutter/material.dart';
import 'package:tabbller/src/pages/splashHome.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> with TickerProviderStateMixin {
  late AnimationController _backController;
  late Animation<Offset> _backAnimation;

  late AnimationController _otherController;
  late Animation<Offset> _otherAnimation;

  final TextEditingController _nameController = TextEditingController();
  bool _isNameEmpty = true; 

  @override
  void initState() {
    super.initState();

    _backController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _backAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, -1.0),
    ).animate(CurvedAnimation(
      parent: _backController,
      curve: Curves.easeInOut,
    ));

    _otherController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _otherAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _otherController,
      curve: Curves.easeInOut,
    ));

    _otherController.forward();    
    _nameController.addListener(() {
      setState(() {
        _isNameEmpty = _nameController.text.isEmpty; // Update the state based on text input
      });
    });
  }

 

  void reverseAni() async {
    _backController.forward();
    _otherController.reverse().then((_) => {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const SplashHomeScreen();
              },
            ),
            (route) => false
          )
        });
  }

  @override
  void dispose() {
    _nameController.removeListener(() {});
    _backController.dispose();
    _otherController.dispose();
    _nameController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;

    return Scaffold(
      body: Container(
        clipBehavior: Clip.none,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: SizedBox(
                width: width,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const SizedBox(height: 10),
                    Positioned(
                      top: -40,
                      right: -40,
                      child: SlideTransition(
                        position: _backAnimation,
                        child: Image.asset(
                          'assets/logoBack.png',
                          height: width * 6 / 5,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: width,
                child: SlideTransition(
                  position: _otherAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/logo.png',
                              height: 80,
                            ),
                            const SizedBox(height: 10),
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Ta',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 28,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'bb',
                                    style: TextStyle(
                                      color: Color(0xFF65C385),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 28,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'ller',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Math is Mathing',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                      SizedBox(
                        width: width,
                        child: const Text(
                          'Hello!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: width,
                        child: TextField(
                          controller: _nameController, // Bind controller
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter your name",
                            hintStyle:
                                const TextStyle(color: Color(0xFFC5C5C5)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                             suffixIcon: IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: _isNameEmpty ? const Color(0xFFC5C5C5) : const Color(0xFF08190E), // Change icon color based on the name input
                      ),
                      onPressed: _isNameEmpty
                        ? null // Disable the button when the name field is empty
                        : () {
                            FirebaseUserInterface.instance.userName =
                                _nameController.text;
                            FirebaseStorageObjectInterface
                                .instance
                                .firebaseStorageObject!
                                .userName = _nameController.text;
                            FirebaseStorageService.instance
                                .updateFirebaseStorageObject(
                                    FirebaseUserInterface.instance.docId!,
                                    FirebaseStorageObjectInterface
                                        .instance.firebaseStorageObject!, context);
                            reverseAni(); // Save name and reverse animation
                          },
                  ),),
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
