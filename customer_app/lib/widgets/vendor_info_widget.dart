import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
class VendorInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var _vendor=Provider.of<VendorProvider>(context);
    GeoPoint location=_vendor.vendorInfo['location'];
    mapLauncher()async{
      GeoPoint location=_vendor.vendorInfo['location'];
      final availableMaps = await MapLauncher.installedMaps;
      print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

      await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title: "${_vendor.vendorInfo['shopName']} is here ",
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          height: 170,

          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(_vendor.vendorInfo['imageUrl'])
            )
          ),
          child: Container(
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.4),
    borderRadius: BorderRadius.circular(15),),
child: Padding(
              padding: EdgeInsets.all(8),
  child: ListView(
    children: [
      Text(_vendor.vendorInfo['dialog'].toString().toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Address : ',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
          Expanded(
            child: Text(_vendor.vendorInfo['address'],

              style: TextStyle(color: Colors.white,fontSize: 14,),),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email : ',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
          Expanded(
            child: Text(_vendor.vendorInfo['email'],

              style: TextStyle(color: Colors.white,fontSize: 14),),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Distance : ',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
          Expanded(
            child: Text('${_vendor.distance}km',

              style: TextStyle(color: Colors.white,fontSize: 14),),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,

        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Rating : ',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),

          Row(
            children: [
              Icon(Icons.star,color: Colors.white,size: 18,),
              Icon(Icons.star,color: Colors.white,size: 18,),
              Icon(Icons.star,color: Colors.white,size: 18,),
              Icon(Icons.star_half,color: Colors.white,size: 18,),
              Icon(Icons.star_outline,color: Colors.white,size: 18,),

                Text('(3.5)',

                style: TextStyle(color: Colors.white,fontSize: 14),),
            ],
          ),
        ],
      ),
      SizedBox(height: 10,),
      Row(

        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white ,
            child: IconButton(icon: (Icon(Icons.phone)),color: Colors.teal,onPressed: (){
              launch('tel:${_vendor.vendorInfo['mobile']}');
            },),
          ),
          SizedBox(width: 5,),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(icon: (Icon(Icons.location_on)),color: Colors.teal,onPressed: (){
             mapLauncher();
             //  MapsLauncher.launchCoordinates(
             //      location.latitude, location.longitude, 'Google Headquarters are here');
            },),
          ),
        ],
      ),

    ],
  ),
          ),
          ),
        ),
      ),
    );
  }
}
