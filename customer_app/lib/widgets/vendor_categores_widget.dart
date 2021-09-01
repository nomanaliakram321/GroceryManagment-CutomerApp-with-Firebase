import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/screens/categories.dart';
import 'package:customer_app/screens/vendor_product_screen.dart';
import 'package:customer_app/widgets/products/vendor_product_list.dart';
import 'package:customer_app/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class VendorCategoriesWidget extends StatefulWidget {
  @override
  _VendorCategoriesWidgetState createState() => _VendorCategoriesWidgetState();
}

class _VendorCategoriesWidgetState extends State<VendorCategoriesWidget> {
  @override
  List _catList = [];
  ProductServices _productServices = ProductServices();
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    var _vendor = Provider.of<VendorProvider>(context);
    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: _vendor.vendorInfo['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc);
        setState(() {
          _catList.add(doc['category']['mainCategory']);
        });
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _Provider = Provider.of<VendorProvider>(context);
    return FutureBuilder(
        future: _productServices.category.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something Went Wrong'));
          }
          if (_catList.length == 0) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Container();
          }
          return ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                return _catList
                        .contains(documentSnapshot.data()['categoryName'])
                    ? Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 100,
                        width: 120,
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
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(15)),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _Provider.SelectedCategoryProduct(
                                        documentSnapshot
                                            .data()['categoryName']);
                                    print(documentSnapshot
                                        .data()['categoryName']);
                                    pushNewScreenWithRouteSettings(
                                      context,
                                      screen: VendorProductScreen(),
                                      settings: RouteSettings(
                                          name: VendorProductScreen.id),
                                      withNavBar:
                                          false, // OPTIONAL VALUE. True by default.
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.network(
                                            documentSnapshot.data()['image'],
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Expanded(
                                  child: Text(
                                    documentSnapshot.data()['categoryName'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                      )
                    : Text('');
              }).toList());
        });
  }
}
