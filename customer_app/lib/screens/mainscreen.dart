import 'package:customer_app/screens/faverouite.dart';
import 'package:customer_app/screens/home_screen.dart';
import 'package:customer_app/screens/myorder_screen.dart';
import 'package:customer_app/screens/profile_screen.dart';
import 'package:customer_app/screens/shop_locations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavigationScreen extends StatelessWidget {
  static const String id = 'navigation-screen';

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 2);

    List<Widget> _buildScreens() {
      return [
        MyOrderScreen(),

        MapShopLocation(),
        HomeScreen(),
        FaverouiteScreen(),
        ProfileScreen()
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.square_list),
        title: ("Orders"),
        activeColorPrimary: Colors.teal,

        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.map),
          title: ("Maps"),
          activeColorPrimary: Colors.teal,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),       PersistentBottomNavBarItem(

          icon: Icon(CupertinoIcons.home,color: Colors.white,),
          title: ("Home"),
          activeColorPrimary: Colors.teal,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.heart),
          title: ("Whislist"),
          activeColorPrimary: Colors.teal,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: ("profile"),
          activeColorPrimary: Colors.teal,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        )
      ];
    }

    return Scaffold(

      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        hideNavigationBar: false,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,

          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style15, // Choose the nav bar style with this property.
      ),
    );
  }
}
