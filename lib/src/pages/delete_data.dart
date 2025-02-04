import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tabbller/src/components/warning.dart';
import 'package:tabbller/src/functions/firestoreDatabase.dart';
import 'package:tabbller/src/pages/splashHome.dart';

class DeleteDataPage extends StatefulWidget {
  const DeleteDataPage({super.key});

  @override
  _DeleteDataPageState createState() => _DeleteDataPageState();
}

class _DeleteDataPageState extends State<DeleteDataPage> {
  final TextEditingController emailController = TextEditingController();
  bool _isEmailValid = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _deleteDataDialog(BuildContext context) async {
    await showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return popDialogue(
            onConfirm: () async {
              await deleteUserAccount(context);
            },
            onCancel: () {
              Navigator.pop(context);
            },
            accept: 'Yes',
            reject: 'No',
            message: 'Are you sure that you want to delete your account and the progress?',
          );
        });
      },
    );
  }
  
  Future<void> deleteUserAccount(BuildContext context) async {
    FirebaseStorageService.checkInternet(context);
    if (FirebaseAuth.instance.currentUser != null && emailController.text == FirebaseStorageObjectInterface.instance.firebaseStorageObject?.emailID) {
      FirebaseUserInterface.instance.docId != null
          ? await FirebaseStorageService.instance.deleteFirebaseStorageObject(
              FirebaseUserInterface.instance.docId!, context)
          : DoNothingAction();
      await FirebaseAuth.instance.currentUser?.delete();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashHomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _isEmailValid = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismisses the keyboard
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Image.asset(
                                            'assets/icons/arrowLeft.png',
                                            width: 16,
                                            height: 16,
                                          )),
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
                                      )
                                    ]),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(height: 25),
                                const Text(
                                  'Delete User Data',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff65C385),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'We value your privacy and believe in giving you complete control over your data. If you’d like to delete your account and all associated data, you can do so easily using the form below.',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Once you confirm, all your data will be permanently deleted from our systems. This process is irreversible, so please make sure you no longer need the information before proceeding.',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'If you face any issues or need help, feel free to contact our support team.',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                ),
                                const SizedBox(height: 50),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        TextField(
                                          onChanged: (_) {
                                            setState(() {
                                              _isEmailValid = true;
                                            });
                                          },
                                          controller: emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Enter your email address',
                                            hintStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                color: _isEmailValid
                                                    ? Colors.transparent
                                                    : const Color(0xffDC4646),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    SizedBox(
                                      height: 20.0,
                                      child: Text(
                                        _isEmailValid ? '' : 'Wrong email provided',
                                        style: const TextStyle(
                                          color: Color(0xffDC4646),
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF138A3C),
                                        Color(0xFF124925),
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                    border: Border.all(
                                        color: Colors.transparent, width: 1),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _deleteDataDialog(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.transparent,
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      minimumSize:
                                          const Size(double.infinity, 55),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ).copyWith(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                    ),
                                    child: const Text(
                                      'Verify and Delete',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
              )),
        ));
  }
}

