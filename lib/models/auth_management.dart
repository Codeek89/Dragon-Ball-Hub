import 'package:dragonballhub/models/user_data_model.dart';
import 'package:dragonballhub/repository/auth_exception_handler.dart';
import 'package:dragonballhub/repository/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSignInData extends StateNotifier<AuthResultStatus?> {
  final AuthHelper auth;
  UserDataModel userDataModel = UserDataModel();

  UserSignInData({
    required this.auth,
  }) : super(AuthResultStatus.undefined);

  void resetData() {
    userDataModel.email = "";
    userDataModel.password = "";
  }

  String generateStateMsg() {
    return AuthExceptionHandler.generateExceptionMessage(state);
  }

  Future<AuthResultStatus?> signInEmail() async {
    try {
      state = await auth.userSignInEmail(
          email: this.userDataModel.email,
          password: this.userDataModel.password);
      return state;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}

//--------------------------------------------------------------------------------

class UserSignUpData extends StateController<AuthResultStatus?> {
  final AuthHelper auth;
  UserDataModel userDataModel = UserDataModel();

  UserSignUpData({
    required this.auth,
  }) : super(AuthResultStatus.undefined);

  String generateStateMsg() {
    return AuthExceptionHandler.generateExceptionMessage(state);
  }

  Future<AuthResultStatus?> signUpEmail() async {
    try {
      state = await auth.signUpWithEmailAndPassword(
          email: this.userDataModel.email,
          password: this.userDataModel.password
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return state;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

}
