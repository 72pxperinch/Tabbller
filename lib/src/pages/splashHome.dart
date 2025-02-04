import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:tabbller/src/functions/firestoreDatabase.dart';

import 'package:tabbller/src/pages/home.dart';
import 'package:tabbller/src/pages/name.dart';
import 'package:tabbller/src/pages/splash.dart';

class SplashHomeScreen extends StatefulWidget {
  const SplashHomeScreen({super.key});

  @override
  State<SplashHomeScreen> createState() => _SplashHomeScreenState();
}

class _SplashHomeScreenState extends State<SplashHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();


    _scaleController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );


    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );
  }


  Future<bool> loadData() async {
    if (FirebaseUserInterface.instance.docId != null) {
      FirebaseStorageObject? object;
      object ??= await FirebaseStorageService.instance
          .readFirebaseStorageObject(FirebaseAuth.instance.currentUser!.uid, context);
      FirebaseStorageObjectInterface.instance.firebaseStorageObject = object;
      FirebaseUserInterface.instance.userName = FirebaseStorageObjectInterface
          .instance.firebaseStorageObject!.userName;
      return true;
    } else {
      String? userID = FirebaseAuth.instance.currentUser!.uid;
      String? docId = await getDocIdFromUserID(userID);
      FirebaseUserInterface.instance.docId = docId;
      FirebaseStorageObject? object;
      object ??= await FirebaseStorageService.instance
          .readFirebaseStorageObject(FirebaseAuth.instance.currentUser!.uid, context);
      FirebaseStorageObjectInterface.instance.firebaseStorageObject = object;
      FirebaseUserInterface.instance.userName = FirebaseStorageObjectInterface
          .instance.firebaseStorageObject!.userName;
      return true;
    }
  }

  void startAnimation() async {
    if (_scaleController.isAnimating) return;

    try {
      await _scaleController.forward();

      bool dataLoaded = await loadData();
      if (dataLoaded) {
        _scaleController.reverse().then((_){
          Future.delayed(const Duration(milliseconds: 50),(){
          Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => 
            FirebaseUserInterface.instance.userName != null
              ? const HomePage()
              : const NamePage()
          )
        );

          });
      });

        
      } else {
        print("Data loading failed.");
        try {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const SplashScreen()), 
          );
        } catch (e) {
          print('Error logging out: $e');
        }
      }
    } catch (e) {
      print("Error during animation or loading data: $e");
      try {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const SplashScreen()), 
          );
        } catch (e) {
        print('Error logging out: $e');
      }
      return;
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAnimation();
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
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
            child: Center(
              child:
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Hero(
                    tag: 'appLogo',
                    child: Image.asset(
                      'assets/logo.png',
                      height: width / 3,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
