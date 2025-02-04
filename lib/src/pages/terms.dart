import 'package:flutter/material.dart';
import 'package:tabbller/src/pages/privacy.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;
    return Scaffold(
        body: Container(
      width: deviceWidth,
      padding: const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 30),
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
      child: SafeArea(child: Center(
          child: SizedBox(
              width: width,
              child: Column(
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
                          child: Opacity(
                              opacity: 0.6,
                              child: Image.asset(
                                'assets/logoBack.png',
                                height: width * 6 / 5,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivacyPolicyPage()));
                        },
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: Color(0xff137D39),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                    width: width,
                    child: const Text(
                      'Terms and Conditions',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff65C385)),
                    )),
                const SizedBox(height: 8),
                SizedBox(
                  width: width,
                  child: const Text(
                    'Effective Date: 1st November 2024',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      buildSectionTitle('1. Acceptance of Terms'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'By accessing or using the Tabbller app, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the app.',
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('2. User Registration'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'To use Tabbller, you must create an account by logging in with your Google account. You are responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account.',
                      ),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'You agree to provide accurate, current, and complete information during the registration process and to update such information as necessary to keep it accurate, current, and complete.',
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('3. Use of the App'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'Tabbller is intended solely for educational purposes. You may use the app only for lawful purposes and in accordance with these Terms.',
                      ),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'You agree not to use the app in a way that violates any applicable federal, state, local, or international law or regulation.',
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('4. User Data and Privacy'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'We collect and store user information, including your Phone number or Gmail ID, to manage your account and improve the app\'s functionality.',
                      ),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'Your data will be used in accordance with our Privacy Policy, which is incorporated by reference into these Terms.',
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('5. Quizzes and Progress Tracking'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'Tabbller includes quizzes and progress tracking features. You acknowledge that your performance and progress are tracked and stored in our database.',
                      ),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'We may use this information to improve the app and provide personalized experiences.',
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('6. User Conduct'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'You agree to use the app in a manner that does not violate the rights of others and does not engage in any activity that could harm the app or its users.',
                      ),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'You may not engage in any form of cheating or fraudulent activities while using the app.',
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('7. Intellectual Property'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'All content, features, and functionality of Tabbller, including but not limited to text, graphics, and logos, are the exclusive property of Tabbller and are protected by applicable copyright, trademark, and other intellectual property laws.',
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('8. Limitation of Liability'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'Tabbller is provided on an "as-is" and "as-available" basis. We do not warrant that the app will be uninterrupted, secure, or free of errors.',
                      ),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'In no event shall Tabbller be liable for any indirect, incidental, special, or consequential damages arising out of or in connection with your use of the app.',
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('9. Modifications to Terms'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'We reserve the right to modify these Terms at any time. We will notify you of any changes by updating the "Effective Date" at the top of these Terms.',
                      ),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'Your continued use of the app following the posting of changes constitutes your acceptance of such changes',
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('10. Governing Law'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'These Terms shall be governed by and construed in accordance with the global laws.',
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('11. Contact Information'),
                      const SizedBox(height: 4),
                      buildSectionContent(
                        'For any questions about these Terms, please contact us at tabbller2024@gmail.com.',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
              ]))),)
    ));
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }

  Widget buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
    );
  }

  Widget buildBulletSection(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '• ',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
