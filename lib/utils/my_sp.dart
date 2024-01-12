import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  Future<void> mySPsaveData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> mySPgetData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Function to set the login status
  Future<void> setLoginStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', status);
  }

}