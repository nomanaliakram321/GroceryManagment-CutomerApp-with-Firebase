import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/services/product_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatefulWidget {
  final String category;
  const CategoryCard({@required this.category});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  List _catList = [];
  ProductServices _productServices = ProductServices();
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // var _vendor = Provider.of<VendorProvider>(context);
    FirebaseFirestore.instance
        .collection('products')
        .where('category.mainCategory', isEqualTo: widget.category)
        // .where('seller.sellerUid', isEqualTo: _vendor.vendorInfo['uid']
        // )
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
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.network(
                              documentSnapshot.data()['image'],
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      )
                    : Text('');
              }).toList());
        });
  }
}
