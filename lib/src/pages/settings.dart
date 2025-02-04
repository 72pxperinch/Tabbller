import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart'; 

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:tabbller/src/components/warning.dart';

import 'package:tabbller/src/functions/apptimer.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';
import 'package:tabbller/src/pages/about.dart';

import 'package:tabbller/src/pages/splash.dart';
import 'package:tabbller/src/pages/delete_data.dart';
import 'package:tabbller/src/pages/privacy.dart';
import 'package:tabbller/src/pages/sync.dart';
import 'package:tabbller/src/pages/terms.dart';

class SettingsOverlay extends StatefulWidget {
  const SettingsOverlay({
    super.key,
    required this.onWalkthrough,
  });
  final VoidCallback onWalkthrough;

  @override
  // ignore: library_private_types_in_public_api
  _SettingsOverlayState createState() => _SettingsOverlayState();
}

class _SettingsOverlayState extends State<SettingsOverlay>
    with TickerProviderStateMixin {
  bool isMusicOn = true;
  bool isSoundOn = true;
  bool isVibrationOn = true;
  bool isSyncing = false;

  bool synced =
      FirebaseStorageObjectInterface.instance.firebaseStorageObject?.emailID !=
              null
          ? true
          : false;

  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  late AnimationController _blurController;
  late Animation<double> _blurAnimation;

  late List<AnimationController> _percentageControllers;
  late List<Animation<double>> percentageAni;

  late AnimationController _musicController;
  late AnimationController _soundController;
  late AnimationController _vibrationController;

  late Animation<double> _musicAnimation;
  late Animation<double> _soundAnimation;
  late Animation<double> _vibrationAnimation;

  bool _isPressedLogout = false;

  List<double> heatMapPercentage = [0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();

    _musicController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _soundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _vibrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _musicAnimation = Tween<double>(begin: 0, end: 5).animate(
      CurvedAnimation(
        parent: _musicController,
        curve: Curves.elasticIn,
      ),
    );

    _soundAnimation = Tween<double>(begin: 0, end: 5).animate(
      CurvedAnimation(
        parent: _soundController,
        curve: Curves.elasticIn,
      ),
    );

    _vibrationAnimation = Tween<double>(begin: 0, end: 5).animate(
      CurvedAnimation(
        parent: _vibrationController,
        curve: Curves.elasticIn,
      ),
    );

    _musicAnimation.addListener(() => setState(() {}));
    _soundAnimation.addListener(() => setState(() {}));
    _vibrationAnimation.addListener(() => setState(() {}));

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _blurController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _blurAnimation =
        Tween<double>(begin: 0.0, end: 10.0).animate(CurvedAnimation(
      parent: _blurController,
      curve: Curves.easeInOut,
    ));

    _percentageControllers = List.generate(
      heatMapPercentage.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      ),
    );

    percentageAni = List.generate(
      heatMapPercentage.length,
      (index) =>
          Tween<double>(begin: 0, end: heatMapPercentage[index].toDouble())
              .animate(
        CurvedAnimation(
            parent: _percentageControllers[index], curve: Curves.easeOut),
      )..addListener(() {
              setState(() {});
            }),
    );

    for (var controller in _percentageControllers) {
      controller.forward();
    }

    _slideController.forward();
    _blurController.forward();
  }

  @override
  void dispose() {
    _musicController.dispose();
    _soundController.dispose();
    _vibrationController.dispose();
    _slideController.dispose();
    _blurController.dispose();
    for (var controller in _percentageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    await showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return popDialogue(
            onConfirm: () async {
              AppUsageTrackerInterface.instance.appUsageTracker!.resetTime();
              // Navigator.pop(context);
              try {
                try {
                  // GoogleUserSignInInterface.instance.signIn?.currentUser != null) {
                  await GoogleSignIn().disconnect();
                } catch (e) {}
                if (FirebaseAuth.instance.currentUser != null) {
                  if (!synced){
                  FirebaseUserInterface.instance.docId != null
                      ? await FirebaseStorageService.instance.deleteFirebaseStorageObject(
                          FirebaseUserInterface.instance.docId!, context)
                      : DoNothingAction();
                  await FirebaseAuth.instance.currentUser?.delete();} else {
                  await FirebaseAuth.instance.signOut();
                  }
                }
                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                print('Error logging out: $e');
              }
              ;
            },
            onCancel: () {
              Navigator.pop(context);
            },
            accept: 'Yes',
            reject: 'No',
            message: synced ? 'Are you sure that you want to logout from your account?' : 'All the progress will be deleted. Are you sure that you want to delete and logout from your account?',
          );
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    double totalWidth = 350;

    void toggleMusic() {
      _musicController.forward().then((_) {
        _musicController.reverse();
        setState(() {
          isMusicOn = !isMusicOn;
        });
      });
    }

    void toggleSound() {
      _soundController.forward().then((_) {
        _soundController.reverse();
        setState(() {
          isSoundOn = !isSoundOn;
        });
      });
    }

    void toggleVibration() {
      _vibrationController.forward().then((_) {
        _vibrationController.reverse();
        setState(() {
          isVibrationOn = !isVibrationOn;
        });
      });
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.zero,
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _blurAnimation,
                      builder: (context, child) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: _blurAnimation.value,
                            sigmaY: _blurAnimation.value,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.35),
                                  Colors.black.withOpacity(0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    child: Transform.translate(
                      offset: Offset(
                          _slideAnimation.value *
                              MediaQuery.of(context).size.width,
                          0),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: SizedBox(
                          width: totalWidth,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                _slideController
                                                    .reverse()
                                                    .then((_) {
                                                  _blurController.reverse();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  color: Colors.transparent,
                                                  width: 30,
                                                  height: 30,
                                                  child: Image.asset(
                                                    'assets/icons/close.png',
                                                    width: 18,
                                                    height: 18,
                                                  ))),
                                        ]),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
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
                                        const SizedBox(width: 20),
                                        const Text(
                                          'by',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 20),
                                        Image.asset(
                                          'assets/pxlbyt.png',
                                          width: 80,
                                          height: 40,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    SettingsItem("bulb", "Walkthrough"),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    SettingsItem("terms", "Terms & Conditions"),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    SettingsItem("privacy", "Privacy Policy"),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    SettingsItem("about", "About Us"),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    SettingsItem("feedback", "Feedback"),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    if (synced)
                                      SettingsItem("delete", "Delete all data"),
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (!synced){
                                        setState(() {
                                          isSyncing = true;
                                        });
                                        await syncWithGoogle(context);
                                        setState(() {
                                          isSyncing = false;
                                        });
                                      }},
                                      child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              child: Image.asset(
                                                synced
                                                    ? 'assets/icons/synced.png'
                                                    : 'assets/icons/sync.png',
                                                width: synced ? 180 : 115,
                                                height: 50,
                                              ),
                                            ),
                                            Container(
                                              color: isSyncing
                                                  ? Colors.black54
                                                  : Colors.transparent,
                                              width: 115,
                                              height: 50,
                                            ),
                                            Visibility(
                                              visible: isSyncing,
                                              child: Transform.scale(
                                                  scale: 0.8,
                                                  child:
                                                      const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )),
                                            )
                                          ]),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 20,
                                            bottom: 40),
                                        child: Center(
                                          child: GestureDetector(
                                            onTapDown: (_) => setState(
                                                () => _isPressedLogout = true),
                                            onTapUp: (_) => setState(
                                                () => _isPressedLogout = false),
                                            onTapCancel: () => setState(
                                                () => _isPressedLogout = false),
                                            onTap: () async {
                                              await _logout(context);
                                            },
                                            child: AnimatedScale(
                                              scale: _isPressedLogout
                                                  ? 0.9
                                                  : 1.0, // Shrink to 90% on press
                                              duration: const Duration(
                                                  milliseconds:
                                                      100), // Quick animation
                                              curve: Curves.easeInOut,
                                              child: Container(
                                                width: 200,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "Log Out",
                                                    style: TextStyle(
                                                      color: Color(0xffDC4646),
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                )
                              ]),
                        ),
                      )),
                    ),
                  )
                ],
              );
            },
          ),
        ));
  }

  Widget SettingsItem(String icon, String label) {
    return GestureDetector(
      onTap: () async {
        if (icon == "delete") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DeleteDataPage()));
        }
        else if (icon == "about") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AboutPage()));
        }
        else if (icon == "terms") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TermsPage()));
        }
        else if (icon == "privacy") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage()));
        }
        else if (icon == "bulb") {
          _slideController.reverse().then((_) async {
            _blurController.reverse();
            Navigator.pop(context);
            Navigator.pop(context);
            widget.onWalkthrough();
          });
        } else if (icon == "feedback") {
        final Uri emailUri = Uri(
          scheme: 'mailto',
          path: 'tabbller2024@gmail.com',
          query: 'subject=Feedback from Tabbller User&body=Enter your feedback here', // Optional: prefill subject and body
        );

        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
        } else {
          // Show an error message if the email app can't be launched
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to open email client')),
          );
        }
      }
      },
      child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/icons/$icon.png',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )),
    );
  }
}

Future<bool> syncWithGoogle(BuildContext context) async {
  try {
    FirebaseStorageService.checkInternet(context);
    User? currentUser = FirebaseAuth.instance.currentUser;

    GoogleSignIn signin = GoogleSignIn(
        // forceCodeForRefreshToken: true,
        signInOption: SignInOption.standard);
    final GoogleSignInAccount? googleUser = await signin.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    try {
      await currentUser!.linkWithCredential(credential);
      FirebaseStorageObjectInterface.instance.firebaseStorageObject!.emailID =
          googleUser?.email;
      FirebaseStorageService.instance.updateFirebaseStorageObject(
          FirebaseUserInterface.instance.docId!,
          FirebaseStorageObjectInterface.instance.firebaseStorageObject!,
          context);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SyncPage(credential: credential)));
        // final choice = await shouldOverwriteDialogue(context);
        // if(choice){

        // } else{

        // }

        return true;
      }
      return false;
    }
  } catch (e) {
    print("Couldn't login to google: ${e}");
    return false;
  }
}


