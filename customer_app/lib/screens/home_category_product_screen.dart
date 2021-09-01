import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/widgets/category_card.dart';
import 'package:customer_app/widgets/products/home_category_screen_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeCategoryProductScreen extends StatefulWidget {
  HomeCategoryProductScreen({Key key}) : super(key: key);
  static const String id = 'homecategoryproduct-screen';

  @override
  _HomeCategoryProductScreenState createState() =>
      _HomeCategoryProductScreenState();
}

class _HomeCategoryProductScreenState extends State<HomeCategoryProductScreen> {
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
          HomeCategoryProductList(),
        ],
      ),
    );
  }
}
