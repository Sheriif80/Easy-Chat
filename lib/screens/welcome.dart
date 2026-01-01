import 'package:chat_app/screens/new_sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  static final String id = 'welcome screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          Image.asset('assets/images/welcome.png'),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Welcome",
              style: GoogleFonts.rubik(
                textStyle: const TextStyle(fontSize: 40, fontWeight: .w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "A simple chatting app with Firebase being used",
              style: GoogleFonts.rubik(
                textStyle: const TextStyle(fontSize: 14, fontWeight: .w400),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, NewSignInScreen.id);
              },
              child: Row(
                mainAxisAlignment: .end,
                children: [
                  Text(
                    "Continue",
                    style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: .w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Image.asset('assets/images/arrow.png', height: 42, width: 42),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
