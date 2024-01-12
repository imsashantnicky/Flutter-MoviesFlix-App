import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviesflix_app/main.dart';
import 'package:flutter_moviesflix_app/pages/InfoPage.dart';
import 'package:flutter_moviesflix_app/pages/home_page.dart';
import 'package:flutter_moviesflix_app/user/Login_page.dart';
import 'package:flutter_moviesflix_app/pages/video_player_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_moviesflix_app/user/signup_page.dart';
import 'package:flutter_moviesflix_app/utils/constants.dart';
import 'package:flutter_moviesflix_app/utils/my_sp.dart';
import '../pages/new_movies_page.dart';
import '../pages/search_page.dart';
import 'dart:io';
import 'package:package_info/package_info.dart';


class Movie {
  final String title;
  final String posterPath;
  final String backPosterPath;
  final double rating;
  final String overview;
  final String releaseDate;
  final int id;

  Movie({
    required this.title,
    required this.posterPath,
    required this.backPosterPath,
    required this.rating,
    required this.overview,
    required this.id,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backPosterPath: json['backdrop_path'] ?? 'assets/images/noposter.png',
      rating:
      json['vote_average'] != null ? json['vote_average'].toDouble() : 0.0,
      overview: json['overview'] ?? '',
      id: json['id'] ?? '',
      releaseDate: json['release_date'] ?? '',
    );
  }
}

class NavigationPageHelper {
  static void navigateToPage(BuildContext context, String name) {
    if(name=="Signup") {
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignupPage(),),);
    }
    if(name=="Login") {
      Navigator.pop(
        context, MaterialPageRoute(builder: (context) => LoginPage(),),);
    }
    if(name=="Home") {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar(),),);
    }
  }
}

class NavigationHelper {
  static void navigateToInfoPage(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoPage(id: id),
      ),
    );
  }
}

class NavigationHelperPop {
  static void navigateToInfoPage(BuildContext context, String id) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => InfoPage(id: id),
      ),
    );
  }
}

class NavigationVideoHelperPop {
  static void navigateToInfoPage(BuildContext context, String videoKey,
      String id) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(videoKey: videoKey, id: id),
      ),
    );
  }
}

class Video {
  final String name;
  final String key;

  Video({
    required this.name,
    required this.key,
  });
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.cyan,
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        selectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'New Hot',
          ),
        ],
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return SearchPage();
      case 2:
        return NewMoviesPage();
      default:
        return HomePage(); // Default to HomePage
    }
  }
}

String encryptedValue(String input) {
  try {
    if (input != null) {
      final inputLen = input.length;
      final randKey = Random().nextInt(9) + 1; // Generate a random key between 1 and 9

      final inputChr = input.codeUnits.map((charCode) => charCode - randKey).toList();

      final sb = StringBuffer();
      for (final i in inputChr) {
        sb.write(i);
        sb.write('a');
      }

      sb.write((randKey.toString().codeUnitAt(0) + 50)); // Append modified key

      return sb.toString();
    } else {
      return '';
    }
  } catch (e) {
    return '';
  }
}

String decryptedValue(String input) {
  try {
    List<String> inputArr = input.split("a");
    int inputLen = inputArr.length - 1;
    // Parse the randKey as an integer
    int val = int.parse(inputArr[inputLen]) - 50;
    String randKey = String.fromCharCode(val);

    List<int> inputChr = List.generate(
      inputLen,
          (i) => int.parse(inputArr[i]) + int.parse(randKey),
    );

    String decryptedString = inputChr.map((i) => String.fromCharCode(i)).join('');

    return decryptedString;
  } catch (e) {
    return '';
  }
}

Future<String> getMobileUniqueId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print(androidInfo);
      return androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
  } catch (e) {
    print("Error getting device ID: $e");
  }
  return "";
}

Future<String?> getCustomerId() async {
  String customerId = "";
  try {
    customerId = SharedPreferencesHelper().mySPgetData(SPConstants().customerID) as String;
  } catch (e) {
    customerId = "";
  }
  return customerId;
}

Future<String?> getApplicationVersion() async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.version);
    return packageInfo.version;
  } catch (e) {
    print("Error getting application version: $e");
    return null;
  }
}

Future<String?> getToken() async {
  return "44a102";
}

Widget ProgressDialog() {
  return LinearProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    backgroundColor: Colors.cyan,
  );
}

void dismisProgressDialog(BuildContext context) {
Navigator.of(context, rootNavigator: true).pop();
}





