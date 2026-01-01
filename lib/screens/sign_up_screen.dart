import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  // هنا استخدمت ستاتيك عشان اقدر اعمل اكسيس من غير ما يعمل اوبجكت كل ما يحاول يوصله
  static final String id = 'SignUp Screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

                    const Row(
                      children: [
                        Text('Sign up', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hint: 'Enter your email',
                      onChanged: (data) {
                        email = data;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      isPassword: true,
                      hint: 'Enter your password',
                      onChanged: (data) {
                        password = data;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      text: 'Sign up',
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
                        const Text(" Have an account ?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text("  Sign in"),
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

  Future<void> signupUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
