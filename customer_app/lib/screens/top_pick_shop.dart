import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/screens/vendor_home_screen.dart';
import 'package:customer_app/screens/welcome_screen.dart';
import 'package:customer_app/services/shop_services.dart';
import 'package:customer_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class TopPickShop extends StatefulWidget {
  @override
  _TopPickShopState createState() => _TopPickShopState();
}

class _TopPickShopState extends State<TopPickShop> {
  ShopServices _shopServices = ShopServices();
  UserServices _userServices=UserServices();
  User user=FirebaseAuth.instance.currentUser;
  var _userLatitude=0.0;
  var _userLongitude=0.0;
  double latitude=0.0;
  double longitude=0.0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final _shopData=Provider.of<VendorProvider>(context);
    _shopData.determinePosition().then((position){
      latitude=position.latitude;
      longitude=position.longitude;
    });
    super.didChangeDependencies();
  }
  @override
  void initState() {
    _userServices.getUserById(user.uid).then((result){
  if(user!=null)
    {
      if(mounted)
        {
          setState(() {
            _userLatitude=result.data()['latitude'];
            _userLongitude=result.data()['longitude'];
          });
        }

    }
  else
    {
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    }
    });
    super.initState();
  }


  String getDistance(location)
{

var distance=Geolocator.distanceBetween(latitude, longitude, location.latitude, location.longitude);
var distanceInKm=distance/1000;//show distance in km
return distanceInKm.toStringAsFixed(2);
}

  @override
  Widget build(BuildContext context) {
    final _shopData=Provider.of<VendorProvider>(context);
    return Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: _shopServices.getTopShop(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
              if (!snapShot.hasData) return CircularProgressIndicator();
              List shopDistance=[];
              for(int i=0;i<snapShot.data.docs.length-1;i++)
                {
                  var distance=Geolocator.distanceBetween(

                      latitude ,longitude,
                      snapShot.data.docs[i]['location'].latitude, snapShot.data.docs[i]['location'].longitude);
                  var distanceInKm=distance/1000;
                  shopDistance.add(distanceInKm);

                }
              shopDistance.sort();//this will help u to find nearest shop
              if(shopDistance[0]>10)
                {
                  return Container();
                }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Row(children: [
                SizedBox(height: 30, child: Image.asset('images/like.gif')),
                    Text('Top Picked Shops for you',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],),
                    Container(
                      child: Flexible(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              snapShot.data.docs.map((DocumentSnapshot document) {
                                if(double.parse(getDistance(document['location']))<=10)
                                  {
                                    //show shop only within 10km
                                    return InkWell(
                                      onTap: (){
                                        _shopData.getSelectedVendor(document,getDistance(document['location']));
                                        pushNewScreenWithRouteSettings(context,
                                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                            withNavBar: true,
                                            screen: VendorhomeScreen(), settings: RouteSettings(name: VendorhomeScreen.id));

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20)),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              SizedBox(
                                                height: 130,
                                                width: 180,
                                                child: Container(

                                                    child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.circular(20),
                                                        child: Image.network(
                                                            document['imageUrl'],
                                                            fit: BoxFit.cover))),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(

                                                      document['shopName'],style: TextStyle(
                                                      fontSize: 16.0,fontWeight: FontWeight.bold,
                                                    ),
                                                      maxLines: 2,overflow: TextOverflow.ellipsis,

                                                    ),
                                                    Text('${getDistance(document['location'])}km',style: TextStyle(
                                                        fontSize: 14.0,color: Colors.grey[500]
                                                    ),)
                                                  ],
                                                ),

                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                else
                                  {
                                    //if no shop
                                   return Container();
                                  }

                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
              );
            })
    );
  }
}
