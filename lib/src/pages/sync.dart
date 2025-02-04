import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tabbller/src/functions/firestoreDatabase.dart';
import 'package:tabbller/src/pages/splashHome.dart';

class SyncPage extends StatefulWidget implements PreferredSizeWidget {
  final OAuthCredential credential;
  const SyncPage({
    super.key,
    required this.credential,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SyncPageState createState() => _SyncPageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SyncPageState extends State<SyncPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> loadGoogleAccount() async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseUserInterface.instance.docId != null
          ? await FirebaseStorageService.instance.deleteFirebaseStorageObject(
              FirebaseUserInterface.instance.docId!, context)
          : DoNothingAction();
      await FirebaseAuth.instance.currentUser?.delete();
    }
    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(widget.credential);
    User? currentUser = userCred.user;

    if (currentUser != null) {
      String? userID = FirebaseAuth.instance.currentUser!.uid;
      String? docId = await getDocIdFromUserID(userID);
      FirebaseUserInterface.instance.userData = userCred.user;
      FirebaseUserInterface.instance.docId = docId;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashHomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
    return;
  }

  Future<void> overWriteGoogleAccount() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.currentUser?.delete();
    }
    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(widget.credential);
    User? currentUser = userCred.user;
    if (currentUser != null) {
      String? prevDocId =
          await getDocIdFromUserID(FirebaseAuth.instance.currentUser!.uid);
      prevDocId != null
          ? await FirebaseStorageService.instance
              .deleteFirebaseStorageObject(prevDocId, context)
          : DoNothingAction();
      FirebaseStorageObjectInterface.instance.firebaseStorageObject!.userID =
          FirebaseAuth.instance.currentUser!.uid;
      FirebaseStorageObjectInterface.instance.firebaseStorageObject!.emailID =
          FirebaseAuth.instance.currentUser!.email;
      await FirebaseStorageService.instance.updateFirebaseStorageObject(
          FirebaseUserInterface.instance.docId!,
          FirebaseStorageObjectInterface.instance.firebaseStorageObject!,
          context);
      FirebaseUserInterface.instance.userData = userCred.user;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashHomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;
    return Scaffold(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/error.png',
                          width: 290,
                          height: 190,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          "Oh...",
                          style: TextStyle(
                            color: Color(0xff65C385),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Look like you already have data in this google account.",
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Color(0xff137D39),
                                  width: 2,
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              await overWriteGoogleAccount();
                            },
                            child: const SizedBox(
                                width: 250,
                                height: 60,
                                child: Center(
                                  child: Text(
                                    'Sync current guest account to google account',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ))),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "This removes old synced google account data",
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Color(0xff137D39),
                                  width: 2,
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              await loadGoogleAccount();
                            },
                            child: const SizedBox(
                                width: 250,
                                height: 60,
                                child: Center(
                                  child: Text(
                                    'Continue using google account data',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ))),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "This removes current guest account data",
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const SizedBox(
                                width: 100,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ))),
                      ],
                    ),
                  ))),
            )));
  }
}
