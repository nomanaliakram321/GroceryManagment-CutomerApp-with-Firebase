import 'package:customer_app/providers/auth_provider.dart';
import 'package:customer_app/providers/location_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(

              children: [
                SizedBox(height: 60,),
                Image.asset('images/login.png'),

                Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
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
                Text(
                  'Enter Your Number to Process ',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 30,
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


                  ),
                  autofocus: true,
                  buildCounter: (BuildContext context,
                          {int currentLength, int maxLength, bool isFocused}) =>
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
                AbsorbPointer(
                  absorbing: _validPhoneNumber ? false : true,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: _validPhoneNumber ? Colors.teal : Colors.grey,
                      onPressed: () {
                        setState(() {
                          auth.loading = true;
                          auth.screen = 'mapscreen';
                          auth.latitude = locationData.latitude;
                          auth.longitude = locationData.longitude;
                          auth.address =
                              locationData.selectedAddress.addressLine;
                        });
                        String number = '+92${_phoneNumberController.text}';
                        auth
                            .verifyPhone(
                          context: context,
                          number: number,
                        )
                            .then((value) {
                          _phoneNumberController.clear();
                          setState(() {
                            auth.loading = false;
                          });
                        });
                      },
                      child: auth.loading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            )
                          : Text(
                              _validPhoneNumber
                                  ? 'Continue'
                                  : 'Enter Phone Number',
                              style: TextStyle(color: Colors.white),
                            )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
