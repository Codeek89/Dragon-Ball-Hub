import 'package:dragonballhub/models/user_field.dart';
import 'package:dragonballhub/repository/auth_exception_handler.dart';
import 'package:dragonballhub/repository/firebase_auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSignInData extends StateNotifier<AuthResultStatus> {
  final FirebaseAuthHelper auth;
  UserField email = UserField();
  UserField password = UserField();
  bool isLoading = false;
  dynamic error;

  UserSignInData({
    required this.auth,
    email = '',
    password = '',
  }) : super(AuthResultStatus.undefined);

  void resetData() {
    email = UserField();
    password = UserField();
    isLoading = false;
  }

  Future<AuthResultStatus?> signIn() async {
    try {
      final status = await auth.signInWithEmailAndPassword(
          email: this.email.value, password: this.password.value);
      return status;
    } catch (e) {
      error = e;
      rethrow;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}

//--------------------------------------------------------------------------------

class UserSignUpData with ChangeNotifier {
  final FirebaseAuthHelper auth;
  UserField nome = UserField();
  UserField cognome = UserField();
  DateTime? birthDate = DateTime(2000);
  UserField email = UserField();
  UserField password = UserField();


  UserSignUpData({
    required this.auth,
  });


  Future<void> verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (!user!.emailVerified) {
      await user.sendEmailVerification();
    }
  }


  Future<void> signUpEmail() async {
    try {
      UserCredential userCredential = await auth.signUpWithEmailAndPassword(
          email: this.email.value.toString(),
          password: this.password.value.toString()
      ).catchError((e) {
        print(e);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.password.error = "The password is too weak";
      } else if (e.code == 'email-already-in-use') {
        this.email.error = "Email is already taken. Choose a new one.";
      }
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

}
