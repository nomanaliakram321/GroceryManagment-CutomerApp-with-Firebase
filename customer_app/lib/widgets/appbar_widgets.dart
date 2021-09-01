import 'package:customer_app/providers/auth_provider.dart';
import 'package:customer_app/providers/location_provider.dart';
import 'package:customer_app/screens/maps_screen.dart';
import 'package:customer_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key key}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _location = '';
  String _address = '';
  @override
  void initState() {
    // TODO: implement initState
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String location = preferences.getString('location');
    String address = preferences.getString('address');
    setState(() {
      _location = location;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),

      automaticallyImplyLeading: false,
      // leading: Container(),
      title: FlatButton(
        onPressed: () {
          locationData.getCurrentPosition();
          if (locationData.permissionAllowed == true) {
            pushNewScreen(
              context,
              screen: MapScreen(),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context,) => MapScreen(),),
            // );
          } else {
            print('Permission not Allowed');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                      _location == null ? 'Address not set ' : _location,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 18.0,
                ),
              ],
            ),
            Flexible(
              child: Text(_address == null ? 'Address not set ' : _address,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.power_settings_new,
              size: 30.0,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              pushNewScreen(
                context,
                screen: WelcomeScreen(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );


            }),
        IconButton(
            icon: Icon(
              Icons.account_circle_rounded,
              size: 30.0,
            ),
            onPressed: () {}),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.qr_code_scanner),
                      ),
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(0.0),
                      fillColor: Colors.white),
                ),
              ),
              SizedBox(
                width: 3.0,
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        style: BorderStyle.none,
                        width: 0,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Icon(Icons.mic, color: Colors.grey),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      elevation: 0.0,
    );
  }
}
