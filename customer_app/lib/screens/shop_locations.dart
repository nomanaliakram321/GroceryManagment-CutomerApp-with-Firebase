import 'dart:async';
//import "package:latlong/latlong.dart" as latLng;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/screens/home_screen.dart';
import 'package:customer_app/screens/splash_screen.dart';
import 'package:customer_app/screens/welcome_screen.dart';
import 'package:customer_app/services/shop_services.dart';
import 'package:customer_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';
//import 'package:mapbox_gl/mapbox_gl.dart';
// class MapShopLocation extends StatefulWidget {
//   static const String id='shop-location';
//   @override
//   _MapShopLocationState createState() => _MapShopLocationState();
// }
//
// class _MapShopLocationState extends State<MapShopLocation> {
//   Completer<GoogleMapController> _controller = Completer();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               //
//             }),
//         title: Text("New York"),
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {
//                 //
//               }),
//         ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           _buildGoogleMap(context),
//           Shop(),
//           _zoomminusfunction(),
//           _zoomplusfunction(),
//           _buildContainer(),
//         ],
//       ),
//     );
//   }
//
//   Widget _zoomminusfunction() {
//     return Align(
//       alignment: Alignment.topLeft,
//       child: IconButton(
//           icon: Icon(Icons.search_off, color: Color(0xff6200ee)),
//           onPressed: () {
//             // zoomVal--;
//             // _minus(zoomVal);
//           }),
//     );
//   }
//
//   Widget _zoomplusfunction() {
//     return Align(
//       alignment: Alignment.topRight,
//       child: IconButton(
//           icon: Icon(Icons.saved_search, color: Color(0xff6200ee)),
//           onPressed: () {
//             // zoomVal++;
//             // _plus(zoomVal);
//           }),
//     );
//   }
//
//   Future<void> _minus(double zoomVal) async {
//
//     controller.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
//   }
//
//   Future<void> _plus(double zoomVal) async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
//   }
//
//   Widget _buildContainer() {
//     return Align(
//       alignment: Alignment.bottomLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 20.0),
//         height: 150.0,
//         child: ListView(
//           scrollDirection: Axis.horizontal,
//           children: <Widget>[
//             SizedBox(width: 10.0),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: _boxes(
//                   "data:image/jpeg;base64,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",
//                   40.738380,
//                   -73.988426,
//                   "Gramercy Tavern"),
//             ),
//             SizedBox(width: 10.0),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: _boxes(
//                   "data:image/jpeg;base64,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",
//                   40.761421,
//                   -73.981667,
//                   "Le Bernardin"),
//             ),
//             SizedBox(width: 10.0),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: _boxes(
//                   "https://images.unsplash.com/photo-1504940892017-d23b9053d5d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
//                   40.732128,
//                   -73.999619,
//                   "Blue Hill"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _boxes(String _image, double lat, double long, String restaurantName) {
//     return GestureDetector(
//       onTap: () {
//         _gotoLocation(lat, long);
//       },
//       child: Container(
//         child: new FittedBox(
//           child: Material(
//               color: Colors.white,
//               elevation: 14.0,
//               borderRadius: BorderRadius.circular(24.0),
//               shadowColor: Color(0x802196F3),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Container(
//                     width: 180,
//                     height: 200,
//                     child: ClipRRect(
//                       borderRadius: new BorderRadius.circular(24.0),
//                       child: Image(
//                         fit: BoxFit.fill,
//                         image: NetworkImage(_image),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: myDetailsContainer1(restaurantName),
//                     ),
//                   ),
//                 ],
//               )),
//         ),
//       ),
//     );
//   }
//
//   Widget myDetailsContainer1(String restaurantName) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Container(
//               child: Text(
//                 restaurantName,
//                 style: TextStyle(
//                     color: Color(0xff6200ee),
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.bold),
//               )),
//         ),
//         SizedBox(height: 5.0),
//         Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Container(
//                     child: Text(
//                       "4.1",
//                       style: TextStyle(
//                         color: Colors.black54,
//                         fontSize: 18.0,
//                       ),
//                     )),
//                 Container(
//                   child: Icon(
//                       Icons.star,
//                     color: Colors.amber,
//                     size: 15.0,
//                   ),
//                 ),
//                 Container(
//                   child: Icon(
//                       Icons.star,
//                     color: Colors.amber,
//                     size: 15.0,
//                   ),
//                 ),
//                 Container(
//                   child: Icon(
//                       Icons.star,
//                     color: Colors.amber,
//                     size: 15.0,
//                   ),
//                 ),
//                 Container(
//                   child: Icon(
//                     Icons.star,
//                     color: Colors.amber,
//                     size: 15.0,
//                   ),
//                 ),
//                 Container(
//                   child: Icon(
//                     Icons.star,
//                     color: Colors.amber,
//                     size: 15.0,
//                   ),
//                 ),
//                 Container(
//                     child: Text(
//                       "(946)",
//                       style: TextStyle(
//                         color: Colors.black54,
//                         fontSize: 18.0,
//                       ),
//                     )),
//               ],
//             )),
//         SizedBox(height: 5.0),
//         Container(
//             child: Text(
//               "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
//               style: TextStyle(
//                 color: Colors.black54,
//                 fontSize: 18.0,
//               ),
//             )),
//         SizedBox(height: 5.0),
//         Container(
//             child: Text(
//               "Closed \u00B7 Opens 17:00 Thu",
//               style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold),
//             )),
//       ],
//     );
//   }
//
//   Widget _buildGoogleMap(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition:
//         CameraPosition(target: LatLng(40.712776, -74.005974), zoom: 12),
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         markers: {
//           newyork1Marker,
//           newyork2Marker,
//           newyork3Marker,
//           gramercyMarker,
//           bernardinMarker,
//           blueMarker
//         },
//       ),
//     );
//   }
//
//   Future<void> _gotoLocation(double lat, double long) async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       target: LatLng(lat, long),
//       zoom: 15,
//       tilt: 50.0,
//       bearing: 45.0,
//     )));
//   }
// }
//
// Marker gramercyMarker = Marker(
//   markerId: MarkerId('gramercy'),
//   position: LatLng(40.738380, -73.988426),
//   infoWindow: InfoWindow(title: 'Gramercy Tavern'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );
//
// Marker bernardinMarker = Marker(
//   markerId: MarkerId('bernardin'),
//   position: LatLng(40.761421, -73.981667),
//   infoWindow: InfoWindow(title: 'Le Bernardin'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );
// Marker blueMarker = Marker(
//   markerId: MarkerId('bluehill'),
//   position: LatLng(40.732128, -73.999619),
//   infoWindow: InfoWindow(title: 'Blue Hill'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );
//
// //New York Marker
//
// Marker newyork1Marker = Marker(
//   markerId: MarkerId('newyork1'),
//   position: LatLng(40.742451, -74.005959),
//   infoWindow: InfoWindow(title: 'Los Tacos'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );
// Marker newyork2Marker = Marker(
//   markerId: MarkerId('newyork2'),
//   position: LatLng(40.729640, -73.983510),
//   infoWindow: InfoWindow(title: 'Tree Bistro'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );
// Marker newyork3Marker = Marker(
//   markerId: MarkerId('newyork3'),
//   position: LatLng(40.719109, -74.000183),
//   infoWindow: InfoWindow(title: 'Le Coucou'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );

class MapShopLocation extends StatefulWidget {
  static const String id = 'shop-location';
  @override
  _MapShopLocationState createState() => _MapShopLocationState();
}

class _MapShopLocationState extends State<MapShopLocation> {
  Completer<GoogleMapController> _controller = Completer();
  ShopServices _shopServices = ShopServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var _userLatitude = 0.0;
   GoogleMapController _googleMapController;
  List<Marker> allMarkers = [];
  var _userLongitude = 0.0;
  var currentlocation;
  var vendors = [];
 // Set <Marker> vendors;
  bool clientToggle = false;


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

    var distance=Geolocator.distanceBetween(_userLatitude, _userLongitude, location.latitude, location.longitude);
    var distanceInKm=distance/1000;//show distance in km
    return distanceInKm.toStringAsFixed(2);
  }
  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(Icons.search_off, color: Color(0xff6200ee)),
          onPressed: () {
            // zoomVal--;
            // _minus(zoomVal);
          }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(Icons.saved_search, color: Color(0xff6200ee)),
          onPressed: () {
            // zoomVal++;
            // _plus(zoomVal);
          }),
    );
  }
 Widget clientCard(vendor){
    return Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 300.0,
              child:

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(
                        vendor),
                  ),



            ),
          );
        }

  Widget _boxes(vendor) {
      return GestureDetector(
        onTap: () {
          _gotoLocation(vendor);
        },
        child: Container(
          child: new FittedBox(
            child: Material(
                color: Colors.white,
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Color(0x802196F3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 180,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(24.0),
                        child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(vendor['imageUrl']),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: myDetailsContainer1(vendor),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    }
    //
    Widget myDetailsContainer1(vendor) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
                child: Text(
                  vendor['shopName'],
                  style: TextStyle(
                      color: Color(0xff6200ee),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                )),
          ),
          SizedBox(height: 5.0),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      child: Text(
                        "4.1",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18.0,
                        ),
                      )),
                  Container(
                    child: Icon(
                        Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                  ),
                  Container(
                    child: Icon(
                        Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                  ),
                  Container(
                    child: Icon(
                        Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                  ),
                  Container(
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                  ),
                  Container(
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                  ),
                  Container(
                      child: Text(
                        '(100)',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18.0,
                        ),
                      )),
                ],
              )),
          SizedBox(height: 5.0),
          Container(
              child: Text(
                "Distance: ${getDistance(vendor['location'])}km",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
          SizedBox(height: 5.0),
          Container(
              child: Text(
                "Closed \u00B7 Opens 17:00 Thu",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              )),
        ],
      );
    }




  Future <void>_gotoLocation(vendor)async  {
    GoogleMapController controller = await _googleMapController;
    final GoogleMapController mapController = await _controller.future;

    mapController.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(vendor['location'].latitude, vendor['location'].longitude),
          zoom: 18,
          tilt: 10.0,
          bearing: 95.0,
        )));
  }

// Widget loadShop(BuildContext)
// {
//  return Container(
//       child: StreamBuilder<QuerySnapshot>(
//           stream: _shopServices.getTopShop(),
//           builder:
//               ( context, AsyncSnapshot<QuerySnapshot> snapShot) {
//             if (!snapShot.hasData) return CircularProgressIndicator();
//             List shopDistance=[];
//             for(int i=0;i<snapShot.data.docs.length-1;i++)
//             {
//               var distance=Geolocator.distanceBetween(_userLatitude, _userLongitude, snapShot.data.docs[i]['location'].latitude, snapShot.data.docs[i]['location'].longitude);
//               var distanceInKm=distance/1000;
//               shopDistance.add(distanceInKm);
//
//             }
//             shopDistance.sort();//this will help u to find nearest shop
//             if(shopDistance[0]>10)
//             {
//               return Container();
//             }
//             return Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Row(children: [
//                     SizedBox(height: 30, child: Image.asset('images/like.gif')),
//                     Text('Top Picked Shops for you',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
//                   ],),
//                   Container(
//                     child: Flexible(
//                       child: ListView(
//                         scrollDirection: Axis.horizontal,
//                         children:
//                         snapShot.data.docs.map((DocumentSnapshot document) {
//                           if(double.parse(getDistance(document['location']))<=10)
//                           {
//                             //show shop only within 10km
//                             return Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20)),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//
//                                     SizedBox(
//                                       height: 130,
//                                       width: 180,
//                                       child: Container(
//
//                                           child: ClipRRect(
//                                               borderRadius:
//                                               BorderRadius.circular(20),
//                                               child: Image.network(
//                                                   document['imageUrl'],
//                                                   fit: BoxFit.cover))),
//                                     ),
//                                     Container(
//                                       margin: EdgeInsets.only(left: 10),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//
//                                             document['shopName'],style: TextStyle(
//                                             fontSize: 16.0,fontWeight: FontWeight.bold,
//                                           ),
//                                             maxLines: 2,overflow: TextOverflow.ellipsis,
//
//                                           ),
//                                           Text('${getDistance(document['location'])}km',style: TextStyle(
//                                               fontSize: 14.0,color: Colors.grey[500]
//                                           ),)
//                                         ],
//                                       ),
//
//                                     ),
//
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }
//                           else
//                           {
//                             //if no shop
//                             return Container();
//                           }
//
//                         }).toList(),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           })
//   );
// }
  Widget loadMap() {
    vendors = [];
    return StreamBuilder<QuerySnapshot>(
        stream: _shopServices.getTopShop(),
        builder: ( context,AsyncSnapshot<QuerySnapshot>  snapShot) {
          if (!snapShot.hasData) return CircularProgressIndicator();

          clientToggle=true;


          List shopDistance=[];
          for (int i = 0; i < snapShot.data.docs.length; i++) {
            var distance=Geolocator.distanceBetween(_userLatitude, _userLongitude, snapShot.data.docs[i]['location'].latitude, snapShot.data.docs[i]['location'].longitude);
            var distanceInKm=distance/1000;
            vendors.add(snapShot.data.docs[i].data());
            shopDistance.add(distanceInKm);

allMarkers.add(new Marker(
  markerId: MarkerId(snapShot.data.docs[i]['shopName']),
  position: LatLng(snapShot.data.docs[i]['location'].latitude,
             snapShot.data.docs[i]['location'].longitude),
  infoWindow: InfoWindow(title:snapShot.data.docs[i]['shopName'] ),
   icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,)
));


          }
          return Stack(
            children:[Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                  mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          },

                  initialCameraPosition:
                  CameraPosition(target: LatLng(32.0928589, 72.683924), zoom: 12),

                  markers: allMarkers.toSet()
              ),
            ),
              Positioned(
                  top: MediaQuery.of(context).size.height-300,
                  left: 10,
                  child: Container(

                      height: 205.0,
                      width:  MediaQuery.of(context).size.width,
                      child:clientToggle?
                      ListView(
                        scrollDirection: Axis.horizontal,

                        padding: EdgeInsets.all(10),

                        children: vendors.map((elements) {
                          return clientCard(elements);
                        }).toList(),
                      )

                          :Container(height: 10,width: 10,child: Text('ho',style: TextStyle(fontSize: 30,color: Colors.red),),)
                  ))
            ]
          );





        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
     

        body: loadMap(),

      ),
    );
  }

  //
  // Widget _buildContainer() {
  //   return Align(
  //     alignment: Alignment.bottomLeft,
  //     child: Container(
  //       margin: EdgeInsets.symmetric(vertical: 20.0),
  //       height: 150.0,
  //       child: ListView(
  //         scrollDirection: Axis.horizontal,
  //         children: <Widget>[
  //           SizedBox(width: 10.0),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: _boxes(
  //                 "data:image/jpeg;base64,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",
  //                 40.738380,
  //                 -73.988426,
  //                 "Gramercy Tavern"),
  //           ),
  //           SizedBox(width: 10.0),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: _boxes(
  //                 "data:image/jpeg;base64,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",
  //                 40.761421,
  //                 -73.981667,
  //                 "Le Bernardin"),
  //           ),
  //           SizedBox(width: 10.0),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: _boxes(
  //                 "https://images.unsplash.com/photo-1504940892017-d23b9053d5d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
  //                 40.732128,
  //                 -73.999619,
  //                 "Blue Hill"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _boxes(String _image, double lat, double long, String restaurantName) {
  //   return GestureDetector(
  //     onTap: () {
  //       _gotoLocation(lat, long);
  //     },
  //     child: Container(
  //       child: new FittedBox(
  //         child: Material(
  //             color: Colors.white,
  //             elevation: 14.0,
  //             borderRadius: BorderRadius.circular(24.0),
  //             shadowColor: Color(0x802196F3),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: <Widget>[
  //                 Container(
  //                   width: 180,
  //                   height: 200,
  //                   child: ClipRRect(
  //                     borderRadius: new BorderRadius.circular(24.0),
  //                     child: Image(
  //                       fit: BoxFit.fill,
  //                       image: NetworkImage(_image),
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: myDetailsContainer1(restaurantName),
  //                   ),
  //                 ),
  //               ],
  //             )),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget myDetailsContainer1(String restaurantName) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.only(left: 8.0),
  //         child: Container(
  //             child: Text(
  //               restaurantName,
  //               style: TextStyle(
  //                   color: Color(0xff6200ee),
  //                   fontSize: 24.0,
  //                   fontWeight: FontWeight.bold),
  //             )),
  //       ),
  //       SizedBox(height: 5.0),
  //       Container(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               Container(
  //                   child: Text(
  //                     "4.1",
  //                     style: TextStyle(
  //                       color: Colors.black54,
  //                       fontSize: 18.0,
  //                     ),
  //                   )),
  //               Container(
  //                 child: Icon(
  //                     Icons.star,
  //                   color: Colors.amber,
  //                   size: 15.0,
  //                 ),
  //               ),
  //               Container(
  //                 child: Icon(
  //                     Icons.star,
  //                   color: Colors.amber,
  //                   size: 15.0,
  //                 ),
  //               ),
  //               Container(
  //                 child: Icon(
  //                     Icons.star,
  //                   color: Colors.amber,
  //                   size: 15.0,
  //                 ),
  //               ),
  //               Container(
  //                 child: Icon(
  //                   Icons.star,
  //                   color: Colors.amber,
  //                   size: 15.0,
  //                 ),
  //               ),
  //               Container(
  //                 child: Icon(
  //                   Icons.star,
  //                   color: Colors.amber,
  //                   size: 15.0,
  //                 ),
  //               ),
  //               Container(
  //                   child: Text(
  //                     "(946)",
  //                     style: TextStyle(
  //                       color: Colors.black54,
  //                       fontSize: 18.0,
  //                     ),
  //                   )),
  //             ],
  //           )),
  //       SizedBox(height: 5.0),
  //       Container(
  //           child: Text(
  //             "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
  //             style: TextStyle(
  //               color: Colors.black54,
  //               fontSize: 18.0,
  //             ),
  //           )),
  //       SizedBox(height: 5.0),
  //       Container(
  //           child: Text(
  //             "Closed \u00B7 Opens 17:00 Thu",
  //             style: TextStyle(
  //                 color: Colors.black54,
  //                 fontSize: 18.0,
  //                 fontWeight: FontWeight.bold),
  //           )),
  //     ],
  //   );
  // }
  // Future<void> _gotoLocation(double lat, double long) async {
  //
  //  await _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //     target: LatLng(lat, long),
  //     zoom: 15,
  //     tilt: 50.0,
  //     bearing: 45.0,
  //   )));
  // }


}
