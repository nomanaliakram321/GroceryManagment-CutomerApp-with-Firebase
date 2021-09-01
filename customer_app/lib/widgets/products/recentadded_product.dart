import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/services/product_services.dart';
import 'package:customer_app/widgets/products/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentlyAddedProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _vendor = Provider.of<VendorProvider>(context);
    return FutureBuilder<QuerySnapshot>(
        future: _services.product
            .where('published', isEqualTo: true)
            .where('collection', isEqualTo: 'Recently Added')
            .where('sellerUid', isEqualTo: _vendor.vendorInfo['uid'])
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return Container();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                        height: 30,
                        child: Icon(Icons.stacked_line_chart_rounded)),
                    Text(
                      'Recently Added',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                  return ProductCard(documentSnapshot);
                }).toList(),
              ),
            ],
          );
        });
  }
}
