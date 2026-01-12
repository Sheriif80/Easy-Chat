import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(LoginFailure(errorMsg: 'No user found for that email.'));
          break;
        case 'wrong-password':
        case 'invalid-credential':
          emit(LoginFailure(errorMsg: 'Email or password is incorrect.'));
          break;
        case 'invalid-email':
          emit(LoginFailure(errorMsg: 'Please enter a valid email.'));
          break;
        case 'network-request-failed':
          emit(LoginFailure(errorMsg: 'Check your internet connection.'));
          break;
        default:
          emit(LoginFailure(errorMsg: e.message ?? 'Login failed.'));
      }
    }
  }
}
