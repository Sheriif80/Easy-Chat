import 'package:chat_app/cubits/login_cubit/login_cubit.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/new_sign_up_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/new_custom_text_field.dart';
import 'package:chat_app/widgets/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class NewSignInScreen extends StatelessWidget {
  NewSignInScreen({super.key});

  static final String id = 'New Sign In Screen';

  String? email;

  String? password;

  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          isLoading = false;
          Navigator.pushNamed(context, ChatScreen.id);
        } else if (state is LoginFailure) {
          isLoading = false;
          showSnackBar(context, text: state.errorMsg);
        }
      },
      builder: (context, state) => ModalProgressHUD(
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
                            'assets/images/sign in.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),

                          Positioned(
                            bottom: 10,
                            left: 16,
                            child: Text(
                              "Sign in",
                              style: GoogleFonts.rubik(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Image.asset('assets/images/line.png', width: 130),
                    ),
                    const SizedBox(height: 60),
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
                      text: 'Login',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<LoginCubit>(
                            context,
                          ).signInUser(email: email!, password: password!);
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
                            Navigator.pushNamed(context, NewSignUpScreen.id);
                          },
                          child: Text(
                            "  Sign up",
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
      ),
    );
  }
}
