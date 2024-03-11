import 'package:flutter/foundation.dart';

import '../data/network/firebase_backend_service.dart';

class AuthenticationRepository {
  final FirebaseApiService _firebaseApiService = FirebaseApiService();

  //signup
  Future<void> signupApi(Map<String, dynamic> userSignUpData) async {
    try {
      dynamic response = await _firebaseApiService.signUp(userSignUpData);
      if (kDebugMode) {
        print(response);
      }
    } catch (error) {
      rethrow;
    }
  }

  //login feature
  Future<dynamic> loginApi(
      String emailID, String password, String fcmDeviceToken) async {
    try {
      dynamic response =
          await _firebaseApiService.login(emailID, password, fcmDeviceToken);
      return response;
    } catch (error) {
      debugPrint('error from the login repo ***************');
      rethrow;
    }
  }

  //check user session
  dynamic checkUserSession() {
    try {
      dynamic user = _firebaseApiService.checkUserSession();
      debugPrint(user.toString());
      return user;
    } catch (error) {
      rethrow;
    }
  }

  //forget password
  Future<void> forgetPasswordApi(String email) async {
    try {
      await _firebaseApiService.forgetPassword(email);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  //perform logout
  Future<void> logoutApi() async {
    try {
      _firebaseApiService.logout();
    } catch (error) {
      rethrow;
    }
  }
}
