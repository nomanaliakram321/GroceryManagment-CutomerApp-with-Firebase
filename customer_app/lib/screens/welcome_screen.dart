import 'package:customer_app/providers/auth_provider.dart';
import 'package:customer_app/providers/location_provider.dart';
import 'package:customer_app/screens/maps_screen.dart';
import 'package:customer_app/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();
    void showBottomSheet(context) {

      showModalBottomSheet(

        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AppBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  elevation: 2.0,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(125, 0, 125, 7),
                        child: Divider(
                          height: 3.0,
                          thickness: 3.0,
                          color: Colors.grey[300],
                        ),
                      ),
                      Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.teal,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Enter Your Number to Process ',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: auth.error == 'Invalid OTP' ? true : false,
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                auth.error,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        cursorColor: Colors.teal,
                        decoration: InputDecoration(
                            prefixText: '+92',
                            labelText: '10 digit Mobile Number',
                            labelStyle: new TextStyle(color: Colors.teal),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.teal,
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.teal,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(0.0),
                            fillColor: Colors.white),
                        // decoration: InputDecoration(

                        //   prefixText: '+92',
                        //   labelText: '10 digit Mobile Number',
                        // ),
                        autofocus: true,
                        buildCounter: (BuildContext context,
                                {int currentLength,
                                int maxLength,
                                bool isFocused}) =>
                            null,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: _phoneNumberController,
                        onChanged: (value) {
                          if (value.length == 10) {
                            setState(() {
                              _validPhoneNumber = true;
                            });
                          } else {
                            setState(() {
                              _validPhoneNumber = false;
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AbsorbPointer(
                              absorbing: _validPhoneNumber ? false : true,
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  color: _validPhoneNumber
                                      ? Colors.teal
                                      : Colors.grey,
                                  onPressed: () {
                                    setState(() {
                                      auth.loading = true;
                                    });
                                    String number =
                                        '+92${_phoneNumberController.text}';
                                    auth
                                        .verifyPhone(
                                      context: context,
                                      number: number,
                                    )
                                        .then((value) {
                                      _phoneNumberController.clear();
                                    });
                                  },
                                  child: auth.loading
                                      ? CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        )
                                      : Text(
                                          _validPhoneNumber
                                              ? 'Continue'
                                              : 'Enter Phone Number',
                                          style: TextStyle(color: Colors.white),
                                        )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Positioned(
                  right: 0.0,
                  top: 10.0,
                  child: FlatButton(
                    child: Text(
                      'SKIP',
                      style: TextStyle(
                          color: Colors.teal, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  )),
              Column(
                children: [
                  Expanded(child: OnBoardScreen()),
                  Text(
                    'Ready to Order from Your Nearest Shop?',
                    style: TextStyle(color: Colors.teal),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Colors.teal,
                      onPressed: () async {
                        setState(() {
                          locationData.loading = true;
                        });
                        await locationData.getCurrentPosition();
                        if (locationData.permissionAllowed == true) {
                          Navigator.pushReplacementNamed(context, MapScreen.id);
                          setState(() {
                            locationData.loading = false;
                          });
                        } else {
                          print("Permission are denied");
                          setState(() {
                            locationData.loading = false;
                          });
                        }
                      },
                      child: locationData.loading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'Set Location',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                  SizedBox(
                    height: 20.0,
                  ),
                  FlatButton(
                    child: RichText(
                      text: TextSpan(
                          text: 'Already a customer ? ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  color: Colors.teal),
                            ),
                          ]),
                    ),
                    onPressed: () {
                      setState(() {
                        auth.screen = 'login';
                      });
                      showBottomSheet(context);
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
