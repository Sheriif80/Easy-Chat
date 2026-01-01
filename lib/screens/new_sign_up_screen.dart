import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/new_custom_text_field.dart';
import 'package:chat_app/widgets/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class NewSignUpScreen extends StatefulWidget {
  const NewSignUpScreen({super.key});
  static final String id = 'new sign up screen';

  @override
  State<NewSignUpScreen> createState() => _NewSignUpScreenState();
}

class _NewSignUpScreenState extends State<NewSignUpScreen> {
  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  SizedBox(
                    height: 393,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          'assets/images/sign up.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                        Positioned(
                          bottom: 70,
                          left: 16,
                          child: Text(
                            "Sign up",
                            style: GoogleFonts.rubik(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 55,
                          left: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Image.asset(
                              'assets/images/line.png',
                              width: 130,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  NewCustomTextField(
                    name: 'Email',
                    hint: 'Enter your email',
                    icon: Icons.email_outlined,
                    onChanged: (data) {
                      email = data;
                    },
                  ),
                  const SizedBox(height: 15),
                  NewCustomTextField(
                    name: 'Password',
                    hint: 'Enter your password',
                    icon: Icons.password_outlined,
                    isPasswrod: true,
                    onChanged: (data) {
                      password = data;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    text: 'Create account',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await signupUser();
                          showSnackBar(
                            context,
                            text:
                                'Account created succefully.\nPlease use it to sign in.',
                          );
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            showSnackBar(
                              context,
                              text: 'The password is too weak.',
                            );
                          } else if (e.code == 'email-already-in-use') {
                            showSnackBar(
                              context,
                              text: 'This email is already in use.',
                            );
                          } else if (e.code == 'invalid-email') {
                            showSnackBar(
                              context,
                              text: 'Please enter a valid email address.',
                            );
                          } else {
                            showSnackBar(
                              context,
                              text: e.message ?? 'Something went wrong.',
                            );
                          }
                        }
                        isLoading = false;
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      const Text("Already have an Account!"),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "  Login",
                          style: GoogleFonts.rubik(
                            color: const Color(0xffFF8383),
                            textStyle: const TextStyle(fontWeight: .w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signupUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
