import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviesflix_app/user/enter_otp_page.dart';
import 'package:flutter_moviesflix_app/user/signup_page.dart';
import 'package:flutter_moviesflix_app/user/user_authentication.dart';
import 'package:flutter_moviesflix_app/utils/util.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneNumberController = TextEditingController();
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hey,\nLogin or SignUp Now.',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 48),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: phoneNumberController,
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 48),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            String number = phoneNumberController.text;
                            AuthService().sendOTP(number);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertDialog();
                              },
                            );
                            print('Number: $number');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.cyan,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            fixedSize: Size(150, 50),
                          ),
                          child: Text('Send OTP', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            // Show the custom designed alert dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertDialog();
                              },
                            );
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

class CustomAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        'Please Enter OTP',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.0),
            Container(
              child: OtpTextField(),
            ),
            SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  NavigationPageHelper.navigateToPage(context, "Home");
                  print('Navigate to Home page');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  fixedSize: Size(80, 30),
                ),
                child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
