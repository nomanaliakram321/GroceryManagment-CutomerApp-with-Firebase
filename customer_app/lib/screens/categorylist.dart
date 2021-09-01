import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/screens/categories.dart';
import 'package:customer_app/services/firebase_services.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _services.categories.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text('Something Went Wrong'),
            );
          }
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children:
                  snapShot.data.docs.map((DocumentSnapshot documentSnapshot) {
                return CategoryCardView(documentSnapshot);
              }).toList());
        },
      ),
    );
  }
}
