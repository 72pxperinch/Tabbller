import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorPage extends StatefulWidget implements PreferredSizeWidget {
  const ErrorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ErrorPageState createState() => _ErrorPageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    super.initState();
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
                          "Oops...",
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
                          "Something went wrong.",
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 14,
                          ),
                        ),
                        const Text(
                          "Please restart the app",
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
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
                              SystemNavigator.pop();
                            },
                            child: const SizedBox(
                                width: 100,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    'Restart',
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
