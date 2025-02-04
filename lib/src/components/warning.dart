import 'dart:ui';
import 'package:flutter/material.dart';

class popDialogue extends StatelessWidget {
  final String message;
  final String accept;
  final String reject;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const popDialogue({
    super.key,
    required this.message,
    required this.onConfirm,
    required this.onCancel, 
    required this.accept, 
    required this.reject,
  });

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.zero, // Full screen without padding
        child: SizedBox(
          width: MediaQuery.of(context).size.width, // Full width
          height: MediaQuery.of(context).size.height, // Full height
          child: Stack(
            children: [
              // Background blur effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: 
                      SizedBox(
                        width: width - 60,
                        child: 
                      Text(
                        message,
                        style: const TextStyle(
                          color: Color(0xFFC5C5C5),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      )
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // "Yes" Button
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            alignment: Alignment.center,
                            width: 120,
                            height: 45,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF138A3C), Color(0xFF124925)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                minimumSize: const Size.fromHeight(10),
                              ),
                              onPressed: () {
                                onConfirm();
                              },
                              child: Text(
                                accept,
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // "No" Button
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            alignment: Alignment.center,
                            width: 120,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: Color(0xFF000000),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                minimumSize: const Size.fromHeight(10),
                              ),
                              onPressed: () {
                                onCancel();
                              },
                              child: Text(
                                reject,
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
