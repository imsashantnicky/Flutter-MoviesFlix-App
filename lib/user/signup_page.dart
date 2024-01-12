import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviesflix_app/user/user_authentication.dart';
import 'package:flutter_moviesflix_app/utils/util.dart';


class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isEmailFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Align content to the start (top)
                crossAxisAlignment: CrossAxisAlignment.center, // Align content to the start (left)
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start, // Align content to the start (top)
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hey,\nSignUp Now.',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                'If you have an account/',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  NavigationPageHelper.navigateToPage(context, "Login");
                                  print('Navigate to Sign Up page');
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start, // Align content to the start (top)
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: emailController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: passwordController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Align content to the start (top)
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            String email = emailController.text;
                            String password = passwordController.text;
                            AuthService().signUp(email, password);
                            print('Email: $email, Password: $password');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.cyan,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            fixedSize: Size(200, 50),
                          ),
                          child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            NavigationPageHelper.navigateToPage(context, "Home");
                            print('Navigate to Home page');
                          },
                          child: Text(
                            'Skip now',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black54
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}