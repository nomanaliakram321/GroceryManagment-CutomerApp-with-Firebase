import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/services/product_services.dart';
import 'package:customer_app/widgets/category_card.dart';
import 'package:customer_app/widgets/products/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _vendor = Provider.of<VendorProvider>(context);
    return FutureBuilder<QuerySnapshot>(
        future: _services.product
            .where('published', isEqualTo: true)
            .where('category.mainCategory',
                isEqualTo: _vendor.selectedProductCategory)
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
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: 45,
                decoration: BoxDecoration(color: Colors.teal[50]),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 5, right: 5),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Chip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.teal,
                          label: Text(
                            'sub categories',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Chip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.teal,
                          label: Text(
                            'sub categories',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                height: 200,
                child: CategoryCard(
                  category: _vendor.selectedProductCategory,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(color: Colors.teal[100]),
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Chip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.teal,
                        label: Text(
                          '${snapshot.data.docs.length} items',
                          style: TextStyle(color: Colors.white),
                        ))
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
