import 'package:customer_app/providers/auth_provider.dart';
import 'package:customer_app/providers/location_provider.dart';
import 'package:customer_app/screens/home_screen.dart';
import 'package:customer_app/screens/landing_screen.dart';
import 'package:customer_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MapScreen extends StatefulWidget {
  static const id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentPosition = LatLng(37.421632, 122.084664);
  GoogleMapController _mapController;
  bool _loggedIn = false;
  bool _locating = false;
  User user;
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
      // Navigator.pushNamed(context, LoginScreen.id);
    });

    if (user != null) {
      setState(() {
        _loggedIn = true;

        // Navigator.pushNamed(context, LoginScreen.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);
    setState(() {
      currentPosition = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: currentPosition, zoom: 14.4746),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              buildingsEnabled: true,
              mapType: MapType.normal,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _locating = true;
                });
                locationData.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {
                setState(() {
                  _locating = false;
                });
                locationData.getMoveCamera();
              },
            ),
            Center(
              child: Container(
                  height: 50.0,
                  margin: EdgeInsets.only(bottom: 40),
                  child: Image.asset(
                    'images/marker.png',
                    color: Colors.teal,
                  )),
            ),
            Center(
              child: SpinKitPulse(
                color: Colors.teal,
                size: 100.0,
              ),
            ),
            Positioned(
                bottom: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _locating
                            ? LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.teal),
                              )
                            : Container(),
                        TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.location_searching,
                              color: Colors.teal,
                            ),
                            label: _locating
                                ? Text(
                                    'Loading...',
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Expanded(
                                    child: Text(
                                        locationData
                                            .selectedAddress.featureName,
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                  )),
                        Text(
                            _locating
                                ? 'Loading...'
                                : locationData.selectedAddress.addressLine,
                            style: TextStyle(color: Colors.teal)),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: AbsorbPointer(
                              absorbing: _locating ? true : false,
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  onPressed: () {
                                    //save address in sharedpreference
                                    locationData.savePrefs();
                                    if (_loggedIn == false) {
                                      Navigator.pushNamed(
                                          context, LoginScreen.id);
                                    } else {
                                      setState(() {
                                        _auth.latitude = locationData.latitude;
                                        _auth.longitude =
                                            locationData.longitude;
                                        _auth.address = locationData
                                            .selectedAddress.addressLine;
                                        _auth.location = locationData
                                            .selectedAddress.featureName;
                                      });
                                      _auth
                                          .updateUser(
                                        id: user.uid,
                                        number: user.phoneNumber,
                                      )
                                          .then((value) {
                                        if (value == true) {
                                          Navigator.push(
                                              context,MaterialPageRoute(builder: (BuildContext context) => HomeScreen()) );
                                        }
                                      });
                                    }
                                  },
                                  color: _locating ? Colors.grey : Colors.teal,
                                  child: Text('Confirm Location',
                                      style: TextStyle(color: Colors.white))),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
