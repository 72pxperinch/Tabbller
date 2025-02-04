import 'package:flutter/material.dart';
import 'package:tabbller/src/pages/privacy.dart';
import 'package:tabbller/src/pages/terms.dart';

class TermsPrivacyWidget extends StatelessWidget {

  const TermsPrivacyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "By continuing you are agreeing to our",
          style: TextStyle(color: Color(0xff838BA1)),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(
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
            const SizedBox(width: 30),
            GestureDetector(
              onTap: (){
                Navigator.push(
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
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
