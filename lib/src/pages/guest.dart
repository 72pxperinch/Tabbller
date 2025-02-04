import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tabbller/src/components/tandc&pp.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';
import 'package:tabbller/src/pages/name.dart';
import 'package:tabbller/src/pages/splashHome.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  _GuestPageState createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {

  bool isLoading = false;
  bool isGoogleloading = false;

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
          child: Center(
            child: Stack(
              clipBehavior: Clip.none, 
              children: [
              Positioned(
                  top: -40,
                  right: -40,
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.asset(
                      'assets/logoBack.png',
                      height: width * 6 / 5,
                    ),
                  )),
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 50, bottom: 10, left: 0, right: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.zero,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text.rich(
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
                                          color: Color(0xFF137D39),
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
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Math is Mathing',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Crunch the numbers with Tabbller',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          )),

      floatingActionButton: 
      
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: 
        Center(child: Container(width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF138A3C), Color(0xFF124925)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await signinAsGuest(context);
                  setState(() {
                    isLoading = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Join as Guest',
                  style: TextStyle(
                      fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            const Center(
              child: Text(
                'Or continue with',
                style: TextStyle(color: Colors.white54, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await signInWithGoogle(context);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Image.asset(
                  'assets/icons/google_icon.png',
                  width: 50.0,
                  height: 50.0,
                ),
              ),
          ),
          const SizedBox(height: 40.0),
          const TermsPrivacyWidget(),

      ],) ,
      ),)
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ));
  }
}

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    await FirebaseStorageService.checkInternet(context);
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      // forceCodeForRefreshToken: true,
      signInOption: SignInOption.standard
    ).signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? currentUser = userCred.user;

    if (currentUser != null) {
      String? userID = FirebaseAuth.instance.currentUser!.uid;
      String? docId = await getDocIdFromUserID(userID);
      if (docId == null) {
        try {
          if (userCred.user != null) {
            FirebaseUserInterface.instance.userData = userCred.user;
            FirebaseStorageObjectInterface.instance.firebaseStorageObject =
                FirebaseStorageObject(
                    userID: FirebaseUserInterface.instance.userData!.uid,
                    emailID: FirebaseUserInterface.instance.userData!.email,
                    showWalkthrough: true,
                  );
            DocumentReference? ref = await FirebaseStorageService.instance
                .addFirebaseStorageObject(FirebaseStorageObjectInterface
                    .instance.firebaseStorageObject!, context);
            FirebaseUserInterface.instance.docId = ref!.id;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NamePage()),
            );
          }
        } catch (e) {
          print(e);
        }
      } else {
        FirebaseUserInterface.instance.userData = userCred.user;
        FirebaseUserInterface.instance.docId = docId;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashHomeScreen()),
        );
      }
    }
    return;
  } catch (e) {
    print(e);
    return;
  }
}

Future<void> signinAsGuest(BuildContext context) async {
  try {
    await FirebaseStorageService.checkInternet(context);
    final userCredential =
      await FirebaseAuth.instance.signInAnonymously();
    User? currentUser = userCredential.user;

    if (currentUser != null) {
      String? userID = FirebaseAuth.instance.currentUser!.uid;
      String? docId = await getDocIdFromUserID(userID);
      if (docId == null) {
        try {
          if (userCredential.user != null) {
            FirebaseUserInterface.instance.userData = userCredential.user;
            FirebaseStorageObjectInterface.instance.firebaseStorageObject =
                FirebaseStorageObject(
                    userID: FirebaseUserInterface.instance.userData!.uid,
                    showWalkthrough: true
                  );
            DocumentReference? ref = await FirebaseStorageService.instance
                .addFirebaseStorageObject(FirebaseStorageObjectInterface
                    .instance.firebaseStorageObject!, context);
            FirebaseUserInterface.instance.docId = ref!.id;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NamePage()),
            );
          }
        } catch (e) {
          print(e);
        }
      } else {
        FirebaseUserInterface.instance.userData = userCredential.user;
        FirebaseUserInterface.instance.docId = docId;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashHomeScreen()),
        );
      }
    }
    return;
  } catch (e) {
    print(e);
    return;
  }
}
