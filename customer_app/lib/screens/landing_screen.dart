import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/location_provider.dart';
import 'package:customer_app/screens/home_screen.dart';
import 'package:customer_app/screens/mainscreen.dart';
import 'package:customer_app/screens/maps_screen.dart';
import 'package:customer_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  User user = FirebaseAuth.instance.currentUser;
  String _location;
  String _address;
  bool _isloadindg=true;
  @override
  void initState() {
    UserServices _userservices = UserServices();
    _userservices.getUserById(user.uid).then((result) async {
      if (result != null) {
        if (result.data()['latitude'] != null) {
          getPrefs(result);
        } else {
          _locationProvider.getCurrentPosition();
          if (_locationProvider.permissionAllowed == true) {
            Navigator.pushNamed(context, MapScreen.id);
          } else {
            print('Permission are not granted');
          }
        }
      }
    });
    // TODO: implement initState
    super.initState();
  }

  getPrefs(dbresult) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String location = preferences.getString('location');
    if (location == null) {
      preferences.setStringList(
          'address', dbresult.data()['location']); //location is not save in db
      preferences.setStringList('location', dbresult.data()['address']);
      if (mounted) {
        setState(() {
          _location = dbresult.data()['location'];
          _address = dbresult.data()['address'];
          _isloadindg=false;
        });
      }
      Navigator.pushReplacementNamed(context, NavigationScreen.id);
    }
    Navigator.pushReplacementNamed(context, NavigationScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_location == null ? '' : _location),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _address == null ? 'Delivery Address Not Set Yet' : _address,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _address == null
                    ? 'Please Update your Current Location to find Shops near you'
                    : _address,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            CircularProgressIndicator(),
            Container(
              width: 600,
              child: Image.asset(
                'images/city.png',
                fit: BoxFit.fill,
              ),
            ),
            Visibility(
              visible: _location != null ? true : false,
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () {
                    //save address in sharedpreference
                  },
                  color: Colors.teal,
                  child: Text('Confirm Location',
                      style: TextStyle(color: Colors.white))),
            ),
            FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                onPressed: () {
                  //save address in sharedpreference
                  _locationProvider.getCurrentPosition();
                  if (_locationProvider.selectedAddress != null) {
                    Navigator.pushReplacementNamed(context, MapScreen.id);
                  } else {
                    print('Permission are not granted');
                  }
                },
                color: Colors.teal,
                child: Text(
                    _location != null ? 'update Location' : 'Confirm Location',
                    style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
