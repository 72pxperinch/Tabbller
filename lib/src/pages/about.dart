import 'package:flutter/material.dart';
import 'package:tabbller/src/pages/privacy.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double width = deviceWidth > 400 ? 400 : deviceWidth;
    return Scaffold(
        body: Container(
            width: deviceWidth,
            padding:
                const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 30),
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
            child: SafeArea(
              child: Center(
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
                          height: 25,
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              SizedBox(
                                  width: width,
                                  child: const Text(
                                    'About Us',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff65C385)),
                                  )),
                              const SizedBox(height: 15),
                              buildSectionContent(
                                'At Tabbller, we believe learning math should be simple, engaging, and accessible to everyone. Our mission is to help students of all ages build strong foundational skills in essential math concepts like multiplication, squares, cubes, prime numbers, and powers, while having fun along the way!',
                              ),
                              const SizedBox(height: 10),
                              buildSectionContent(
                                'We created Tabbller to make math less intimidating and more interactive. With user-friendly tools, fun quizzes, and progress tracking, we aim to inspire confidence in students as they master key math concepts step by step.',
                              ),
                              const SizedBox(height: 10),
                              buildSectionContent(
                                'Our app is designed for students, parents, and tutors who want an effective way to learn, teach, and track progress. Whether you’re practicing multiplication tables or diving into powers and primes, Tabbller is your companion for mastering math with ease.',
                              ),
                              const SizedBox(height: 20),
                              buildSectionTitle('Our Vision'),
                              const SizedBox(height: 4),
                              buildSectionContent(
                                'To create a world where every student feels confident in their math skills and discovers the joy of learning.',
                              ),
                              const SizedBox(height: 20),
                              buildSectionTitle('Our Values'),
                              const SizedBox(height: 4),
                              buildSectionContent(
                                'Simplicity: Math concepts made easy to understand.',
                              ),
                              const SizedBox(height: 4),
                              buildSectionContent(
                                'Engagement: Interactive tools to make learning fun.',
                              ),
                              const SizedBox(height: 4),
                              buildSectionContent(
                                'Progress: Helping users track improvement and grow.',
                              ),
                              const SizedBox(height: 20),
                              buildSectionContent(
                                'We’re passionate about making a difference in education and supporting learners on their journey to success. Join us and make math your superpower with Tabbller!',
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        )
                      ]))),
            )));
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
