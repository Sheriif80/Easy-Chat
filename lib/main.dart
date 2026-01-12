import 'package:chat_app/cubits/login_cubit/login_cubit.dart';
import 'package:chat_app/cubits/register_cubit/register_cubit.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/new_sign_in_screen.dart';
import 'package:chat_app/screens/new_sign_up_screen.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        SignInScreen.id: (context) {
          return const SignInScreen();
        },
        SignUpScreen.id: (context) {
          return const SignUpScreen();
        },
        ChatScreen.id: (context) {
          return ChatScreen();
        },
        Welcome.id: (context) {
          return const Welcome();
        },
        NewSignInScreen.id: (context) {
          return BlocProvider(
            create: (context) => LoginCubit(),
            child: NewSignInScreen(),
          );
        },
        NewSignUpScreen.id: (context) {
          return BlocProvider(
            create: (context) => RegisterCubit(),
            child: NewSignUpScreen(),
          );
        },
      },
      debugShowCheckedModeBanner: false,
      initialRoute: Welcome.id,
    );
  }
}
