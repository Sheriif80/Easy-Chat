import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginLoading());
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
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

      if (event is RegisterEvent) {
        emit(RegisterLoading());
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          emit(RegisterSuccess());
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case 'email-already-in-use':
              emit(
                RegisterFailure(errorMsg: 'This email is already registered.'),
              );
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
                RegisterFailure(
                  errorMsg: 'Please enter a valid email address.',
                ),
              );
              break;

            case 'network-request-failed':
              emit(
                RegisterFailure(errorMsg: 'Check your internet connection.'),
              );
              break;

            case 'operation-not-allowed':
              emit(
                RegisterFailure(
                  errorMsg: 'Email/password sign up is disabled.',
                ),
              );
              break;

            default:
              emit(
                RegisterFailure(errorMsg: e.message ?? 'Registration failed.'),
              );
          }
        }
      }
    });
  }
}
