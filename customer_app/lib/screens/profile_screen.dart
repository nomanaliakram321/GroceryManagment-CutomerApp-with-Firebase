import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const id='profile-screen';
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text('Profile Screen')),
      ),
    );
  }
}
