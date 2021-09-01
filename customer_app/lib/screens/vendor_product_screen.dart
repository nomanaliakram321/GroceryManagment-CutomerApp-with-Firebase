import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/widgets/category_card.dart';
import 'package:customer_app/widgets/products/vendor_product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorProductScreen extends StatelessWidget {
  static const String id = 'vendorproduct-screen';

  @override
  Widget build(BuildContext context) {
    var _vendor = Provider.of<VendorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          _vendor.selectedProductCategory,
        ),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          // Container(
          //   height: 200,
          //   child: CategoryCard(
          //     category: _vendor.selectedProductCategory,
          //   ),
          // ),
          VendorProductList(),
        ],
      ),
    );
  }
}
