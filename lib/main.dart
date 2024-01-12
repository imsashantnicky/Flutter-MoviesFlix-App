import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviesflix_app/user/Login_page.dart';
import 'package:flutter_moviesflix_app/pages/collection_page.dart';
import 'package:flutter_moviesflix_app/pages/home_page.dart';
import 'package:flutter_moviesflix_app/pages/new_movies_page.dart';
import 'package:flutter_moviesflix_app/pages/search_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_moviesflix_app/user/opt_login.dart';
import 'package:flutter_moviesflix_app/utils/my_sp.dart';
import 'package:flutter_moviesflix_app/utils/util.dart';
import 'firebase_options.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: Colors.grey,
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Set the color for the drawer icon
          ),
        ),
      ),
      home: MyBottomNavigationBar(),
    );
  }
}


