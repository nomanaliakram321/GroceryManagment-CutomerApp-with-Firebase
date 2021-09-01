import 'package:customer_app/providers/auth_provider.dart';
import 'package:customer_app/providers/location_provider.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/screens/home_screen.dart';
import 'package:customer_app/screens/landing_screen.dart';
import 'package:customer_app/screens/login_screen.dart';
import 'package:customer_app/screens/mainscreen.dart';
import 'package:customer_app/screens/maps_screen.dart';
import 'package:customer_app/screens/profile_screen.dart';
import 'package:customer_app/screens/shop_locations.dart';
import 'package:customer_app/screens/splash_screen.dart';
import 'package:customer_app/screens/vendor_home_screen.dart';
import 'package:customer_app/screens/vendor_product_screen.dart';

import 'package:customer_app/screens/welcome_screen.dart';
import 'package:customer_app/widgets/products/home_category_screen_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VendorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
      ],
      child: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          SplashScreen.id: (context) => SplashScreen(),
          MapScreen.id: (context) => MapScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          LandingScreen.id: (context) => LandingScreen(),
          MapShopLocation.id: (context) => MapShopLocation(),
          NavigationScreen.id: (context) => NavigationScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          VendorhomeScreen.id: (context) => VendorhomeScreen(),
          VendorProductScreen.id: (context) => VendorProductScreen(),
          HomeCategoryProductList.id: (context) => HomeCategoryProductList()
        });
  }
}
