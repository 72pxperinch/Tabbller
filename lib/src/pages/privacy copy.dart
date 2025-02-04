import 'package:flutter/material.dart';
import 'package:tabbller/src/pages/terms.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;
    return Scaffold(
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
            child: SafeArea(child: Center(
                child: SizedBox(
                    width: width,
                    child: Column(children: [
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
                                        builder: (context) => TermsPage()));
                              },
                              child: const Text(
                                "Terms and Conditions",
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
                            'Privacy Policy',
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
                            buildSectionTitle('1. Introduction'),
                            buildSectionContent(
                              'This Privacy Policy explains how Tabbller ("we," "our," or "us") collects, uses, and discloses information about you when you use our app. By using Tabbller, you consent to the collection and use of your information as described in this policy.',
                            ),
                            const SizedBox(height: 20),
                            buildSectionTitle('2. Information We Collect'),
                            buildSectionContent(
                              'We may collect the following types of information:',
                            ),
                            buildBulletSection([
                              'Personal Information: When you register to use Tabbller, we collect personal information such as your Gmail ID and password.',
                              'Usage Data: We may collect information about your interactions with the app, including the quizzes you take, your progress, and any feedback you provide.',
                              'Device Information: We may collect information about the device you use to access the app, including your IP address, device type, and operating system.',
                            ]),
                            const SizedBox(height: 20),
                            buildSectionTitle('3. How We Use Your Information'),
                            buildSectionContent(
                              'We may use the information we collect for various purposes, including:',
                            ),
                            buildBulletSection([
                              'To create and manage your account.',
                              'To provide and maintain our services, including quizzes and progress tracking.',
                              'To improve the app\'s functionality and user experience.',
                              'To communicate with you about updates, promotions, or other information related to the app.',
                              'To monitor and analyze usage and trends to enhance the app.',
                            ]),
                            const SizedBox(height: 20),
                            buildSectionTitle('4. Sharing Your Information'),
                            buildSectionContent(
                              'We do not sell or rent your personal information to third parties. We may share your information in the following circumstances:',
                            ),
                            buildBulletSection([
                              'Service Providers: We may engage third-party companies and individuals to facilitate our services or to provide services on our behalf. These third parties have access to your personal information only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.',
                              'Legal Requirements: We may disclose your information if required to do so by law or in response to valid requests by public authorities (e.g., a court or government agency).',
                            ]),
                            const SizedBox(height: 20),
                            buildSectionTitle('5. Data Security'),
                            buildSectionContent(
                              'We take reasonable measures to protect the information we collect from unauthorized access, use, or disclosure. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee its absolute security.',
                            ),
                            const SizedBox(height: 20),
                            buildSectionTitle('6. Your Rights'),
                            buildSectionContent(
                              'Depending on your location, you may have certain rights regarding your personal information, including:',
                            ),
                            buildBulletSection([
                              'The right to access, update, or delete your information.',
                              'The right to withdraw consent for processing your information.',
                              'The right to request the transfer of your information to another service provider.',
                              'To exercise these rights, please contact us at tabbller2024@gmail.com.',
                            ]),
                            const SizedBox(height: 20),
                            buildSectionTitle('7. Changes to This Privacy Policy'),
                            buildSectionContent(
                              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Effective Date" at the top of this policy. You are advised to review this Privacy Policy periodically for any changes.',
                            ),
                            const SizedBox(height: 20),
                            buildSectionTitle('8. Contact Us'),
                            buildSectionContent(
                              'If you have any questions about this Privacy Policy or our data practices, please contact us at tabbller2024@gmail.com.',
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ]
                  )
                )
              ))
            )
          );
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
