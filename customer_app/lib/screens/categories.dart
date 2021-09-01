import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/screens/shop_locations.dart';
import 'package:customer_app/screens/vendor_product_screen.dart';
import 'package:customer_app/services/firebase_services.dart';
import 'package:customer_app/widgets/products/home_category_screen_product.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/screens/shop_locations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CategoryCardView extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  CategoryCardView(this.documentSnapshot);
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    var _Provider = Provider.of<VendorProvider>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(left: 5),
        height: 100,
        width: 100,
        child: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              shadowLightColor: Colors.white,
              shadowDarkColor: Colors.white,
              color: Colors.white,
              border: NeumorphicBorder(
                isEnabled: true,
              ),
              depth: 3,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _Provider.SelectedCategoryProduct(
                        documentSnapshot.data()['categoryName']);
                    print(documentSnapshot.data()['categoryName']);
                    pushNewScreenWithRouteSettings(
                      context,
                      screen: HomeCategoryProductList(),
                      settings: RouteSettings(name: HomeCategoryProductList.id),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: SizedBox(
                    height: 90,
                    width: double.infinity,
                    child: new Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            documentSnapshot['image'],
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  documentSnapshot['categoryName'],
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ),
    );
  }
}
