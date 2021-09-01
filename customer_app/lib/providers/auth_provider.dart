import 'package:customer_app/providers/location_provider.dart';
import 'package:customer_app/screens/home_screen.dart';
import 'package:customer_app/screens/landing_screen.dart';
import 'package:customer_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String smsOtp;
  String verificationId;
  String error = '';
  bool loading = false;
  double latitude;
  double longitude;
  String address;
  LocationProvider locationData = LocationProvider();
  UserServices _userServices = UserServices();
  String screen;
  String location;
  Future<void> verifyPhone({
    BuildContext context,
    String number,
  }) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verifcationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;

      this.error = e.toString();
      notifyListeners();
      print(e.code);
    };
    final PhoneCodeSent smsOtpSend = (String verid, int resendcode) async {
      this.verificationId = verid;
      //dialogue to enter recieved OTP sms
      smsOtpDialog(context, number);
    };

    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verifcationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verid) {
            this.verificationId = verid;
          });
    } catch (e) {
      this.error = e.toString();
      this.loading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<bool> smsOtpDialog(
    BuildContext context,
    String number,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Enter 6 Digit OTP Code recieved as SMS',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            content: Container(
              height: 85.0,

              child: PinEntryTextField(
                showFieldAsBox: true,
                onSubmit: (String pin) {
                  this.smsOtp = pin;
                  //end showDialog()
                }, // end onSubmit
              ), //,
              // child: TextField(
              //   textAlign: TextAlign.center,
              //   keyboardType: TextInputType.number,
              //   maxLength: 6,
              //   onChanged: (value) {
              //     this.smsOtp = value;
              //   },
              // ),
            ),
            actions: [
              Flexible(
                child: Center(
                  child: FlatButton(
                      color: Colors.teal,
                      onPressed: () async {
                        try {
                          PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: smsOtp);
                          final User user = (await _auth
                                  .signInWithCredential(phoneAuthCredential))
                              .user;

                          if (user != null) {
                            this.loading = false;
                            notifyListeners();
                            _userServices
                                .getUserById(user.uid)
                                .then((snapShot) {
                              if (snapShot.exists) {
                                // user data already exist;
                                if (this.screen == 'login') {
                                  //check either your data exist in database or not;
                                  //if exist data then no need to update user data;
                                  Navigator.pushReplacementNamed(
                                      context, LandingScreen.id);
                                } else {
                                  //need to update adress data
                                  updateUser(
                                      id: user.uid, number: user.phoneNumber);
                                  Navigator.pushReplacementNamed(
                                      context, LandingScreen.id);
                                }
                              } else {
                                // user data does not exist;
                                //will create new data in db;
                                _createUser(
                                  id: user.uid,
                                  number: user.phoneNumber,
                                );
                                Navigator.pushReplacementNamed(
                                    context, HomeScreen.id);
                              }
                            });
                          } else {
                            print('Login failed');
                          }
                          // if (locationData.selectedAddress != null) {
                          //   updateUser(
                          //       id: user.uid,
                          //       number: user.phoneNumber,
                          //       latitude: locationData.latitude,
                          //       longitude: locationData.longitude,
                          //       address: locationData.selectedAddress.addressLine);
                          // } else {
                          //   _createUser(
                          //       id: user.uid,
                          //       number: user.phoneNumber,
                          //       latitude: latitude,
                          //       longitude: longitude,
                          //       address: address);
                          // }
                          // //create user data in firestore after user successfully login

                          // //navigate to homepage after login

                          // if (user != null) {
                          //   Navigator.of(context).pop();

                          //   //dont come back after logged in
                          //   Navigator.pushReplacementNamed(context, HomeScreen.id);
                          // } else {
                          //   print('login faild');
                          // }
                        } catch (e) {
                          this.error = 'Invalid OTP';
                          notifyListeners();
                          Navigator.of(context).pop();
                          print(e.toString());
                        }
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              )
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({String id, String number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'location': this.location
    });
    this.loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({
    String id,
    String number,
  }) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'address': this.address,
        'location': this.location
      });
      this.loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error $e');
      return false;
    }
  }
}
