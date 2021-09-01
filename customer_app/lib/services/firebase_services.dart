import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference banners = FirebaseFirestore.instance.collection('slider');
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference product =
      FirebaseFirestore.instance.collection('products');

  Future<DocumentSnapshot> getAdminCredentials(id) {
    var result = FirebaseFirestore.instance.collection('Admin').doc(id).get();
    return result;
  }
//For Banners

  deleteBannerFromDb(id) async {
    firestore.collection('slider').doc(id).delete();
  }

  //For Vendor
  updateVendorStatus({id, status}) async {
    vendors.doc(id).update({'accountVerified': status ? false : true});
  }

  updateVendorTopPickedStatus({id, status}) async {
    vendors.doc(id).update({'isTopPicked': status ? false : true});
  }

  //For Category

  deleteCategoryFromDb(id) async {
    firestore.collection('categories').doc(id).delete();
  }

  Future<void> deleteDialog({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('YES'),
              onPressed: () {
                deleteBannerFromDb(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteDialogCategory({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('YES'),
              onPressed: () {
                deleteCategoryFromDb(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog({title, message, context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
