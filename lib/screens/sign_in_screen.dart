import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static final String id = 'SignIn Screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? email;

  String? password;

  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: kPrimaryColors,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      'assets/images/chat.png',
                      width: 110,
                      height: 110,
                    ),
                    const Center(
                      child: Text(
                        'EasyChat',
                        style: TextStyle(
                          fontFamily: 'ShadowsIntoLight',
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    Row(
                      children: [
                        Text('Sign in', style: GoogleFonts.rubik(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hint: 'Enter your email',
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      isPassword: true,
                      hint: 'Enter your password',
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      text: 'Sign in',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          try {
                            await signInUser();
                            showSnackBar(
                              context,
                              text: 'Signed in successfully.',
                            );
                            Navigator.pushNamed(context, ChatScreen.id);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              showSnackBar(
                                context,
                                text: 'No user found for that email.',
                              );
                            } else if (e.code == 'wrong-password') {
                              showSnackBar(
                                context,
                                text: 'Wrong password provided.',
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
                        const Text("Don't have an account ?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpScreen.id);
                          },
                          child: const Text("  Sign up"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
