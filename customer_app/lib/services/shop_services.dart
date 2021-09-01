import 'package:cloud_firestore/cloud_firestore.dart';

class ShopServices{
  CollectionReference shopBanner=FirebaseFirestore.instance.collection('vendorBanner');
  getTopShop()
  {
    return FirebaseFirestore.instance.collection('vendors').where('accountVerified', isEqualTo: true)
        .where('isTopPicked',isEqualTo: true).orderBy('shopName').snapshots();
  }
}