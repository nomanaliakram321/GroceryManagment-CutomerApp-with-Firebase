import 'package:customer_app/providers/auth_provider.dart';
import 'package:customer_app/providers/location_provider.dart';
import 'package:customer_app/screens/categorylist.dart';
import 'package:customer_app/screens/maps_screen.dart';
import 'package:customer_app/screens/product_list.dart';
import 'package:customer_app/screens/products.dart';
import 'package:customer_app/screens/top_pick_shop.dart';
import 'package:customer_app/screens/welcome_screen.dart';
import 'package:customer_app/widgets/appbar_widgets.dart';
import 'package:customer_app/widgets/home_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(130),
        child:  MyAppBar()
      ),

      body: SingleChildScrollView(
        child: Column(

          children: [
            HomeSlider(),
            Container(height: 225, child: TopPickShop()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(height: 30, child: Icon(Icons.apps)),
                  Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 120,
                child: CategoryList()),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(height: 30, child: Icon(Icons.grain)),
                  Text(
                    'Recent Added',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 200,
                child: ProductList()),
          ],
        ),
      ),
    );
  }
}
