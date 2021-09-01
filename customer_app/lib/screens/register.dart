import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/profile.png',
                  height: 100.0,
                )),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
          ],
        ),
      ),
    ));
  }
}
