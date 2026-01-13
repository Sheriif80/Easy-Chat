import 'package:chat_app/cubits/register_cubit/register_cubit.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/new_custom_text_field.dart';
import 'package:chat_app/widgets/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class NewSignUpScreen extends StatelessWidget {
  NewSignUpScreen({super.key});

  static final String id = 'new sign up screen';

  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          isLoading = false;
          showSnackBar(context, text: ' Account created successfully');
          Navigator.pop(context);
        } else if (state is RegisterFailure) {
          isLoading = false;
          showSnackBar(context, text: state.errorMsg);
        }
      },
      builder: (context, state) {
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
                            BlocProvider.of<RegisterCubit>(
                              context,
                            ).signupUser(email: email!, password: password!);
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
      },
    );
  }
}
