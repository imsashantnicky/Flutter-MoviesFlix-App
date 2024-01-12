import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_moviesflix_app/utils/my_sp.dart';
import 'package:flutter_moviesflix_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  // Function to check if the user is logged in
  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  // Sign up with email and password
  Future signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set isLogin to true after successful signup
      await sharedPreferencesHelper.setLoginStatus(true);
      return userCredential.user;
    } catch (e) {
      print('Sign up failed: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set isLogin to true after successful login
      await sharedPreferencesHelper.setLoginStatus(true);

      return userCredential.user;
    } catch (e) {
      print('Sign in failed: $e');
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    await _auth.signOut();
    await sharedPreferencesHelper.setLoginStatus(false);
  }

  static Future<http.Response> makeApiCall({
    required String user,
    required String loginForm,
    required String deviceId,
    required String platform,
    required String appVersion,
    required String sellAppVersion,
  }) async {
    final String apiUrl = "https://apis-stg.bookchor.com/webservices/bookchor.com/dump/user_sell_book.php";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'user': user,
          'login_form': loginForm,
          'device_id': deviceId,
          'platform': platform,
          'app_version': appVersion,
          'sell_app_version': sellAppVersion,
        },
      );
      return response;
    } catch (e) {
      print("Error making API call: $e");
      throw e;
    }
  }

  void sendOTP(String phoneNumber) async {
    String? appVersion = await getApplicationVersion();
    String? deviceId = await getMobileUniqueId();
    try {
      http.Response response = await makeApiCall(
        user: encryptedValue(phoneNumber),
        loginForm: encryptedValue("login"),
        deviceId: deviceId,
        platform: "android",
        appVersion: appVersion.toString(),
        sellAppVersion: appVersion.toString(),
      );
      print("user: ${encryptedValue(phoneNumber)}, loginForm: ${encryptedValue("login")}, device id: ${deviceId}, appVersion: ${appVersion}");
      print("user: ${decryptedValue(encryptedValue(phoneNumber))}, loginForm: ${decryptedValue(encryptedValue("login"))}, device id: ${deviceId}, appVersion: ${appVersion}");

      if (response.statusCode == 200) {
        print("API Call successful");
        print("Response body: ${response.body}");

      } else {
        print("API Call failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in API call: $e");

    }
  }
}
