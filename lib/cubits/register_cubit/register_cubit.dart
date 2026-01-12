import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> signupUser({
    required String email,
    required String password,
  }) async {
    try {
      emit(RegisterLoading());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emit(RegisterFailure(errorMsg: 'This email is already registered.'));
          break;

        case 'weak-password':
          emit(
            RegisterFailure(
              errorMsg: 'Password should be at least 6 characters.',
            ),
          );
          break;

        case 'invalid-email':
          emit(
            RegisterFailure(errorMsg: 'Please enter a valid email address.'),
          );
          break;

        case 'network-request-failed':
          emit(RegisterFailure(errorMsg: 'Check your internet connection.'));
          break;

        case 'operation-not-allowed':
          emit(
            RegisterFailure(errorMsg: 'Email/password sign up is disabled.'),
          );
          break;

        default:
          emit(RegisterFailure(errorMsg: e.message ?? 'Registration failed.'));
      }
    }
  }
}
