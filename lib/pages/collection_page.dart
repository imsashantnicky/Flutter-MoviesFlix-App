import 'package:flutter/material.dart';

class CollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        centerTitle: true,
        title: Image.asset(
          'assets/images/mainlogo.png',
          width: 130,
          height: 50,
        ),
      ),
      body: Center(
        child: Text('This is the Info Page'),
      ),
    );
  }
}