import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/widgets/home_slider.dart';
import 'package:customer_app/widgets/products/bestselling_product.dart';
import 'package:customer_app/widgets/products/featured_product.dart';
import 'package:customer_app/widgets/products/product_card.dart';
import 'package:customer_app/widgets/products/recentadded_product.dart';
import 'package:customer_app/widgets/vendor_banner.dart';
import 'package:customer_app/widgets/vendor_categores_widget.dart';
import 'package:customer_app/widgets/vendor_info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorhomeScreen extends StatefulWidget {
  static const String id = 'vendorhome-screen';

  @override
  _VendorhomeScreenState createState() => _VendorhomeScreenState();
}

class _VendorhomeScreenState extends State<VendorhomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _shopData = Provider.of<VendorProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text(
            _shopData.vendorInfo['shopName'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(icon: Icon(CupertinoIcons.search), onPressed: () {})
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            VendorInfoWidget(),
            SizedBox(
              height: 5,
            ),
            VendorBanners(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(height: 30, child: Icon(Icons.apps)),
                  Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(height: 120, child: VendorCategoriesWidget()),
            FeaturedProduct(),
            BestSellingProduct(),
            RecentlyAddedProduct(),
            SizedBox(
              height: 120,
            )
          ],
        ),
      ),
    );
  }
}
