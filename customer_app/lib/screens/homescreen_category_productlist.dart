import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/services/product_services.dart';
import 'package:customer_app/widgets/products/product_card.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class HomeCategoryProductList extends StatelessWidget {
  const HomeCategoryProductList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _vendor = Provider.of<VendorProvider>(context);
    return FutureBuilder<QuerySnapshot>(
        future: _services.product
            .where('published', isEqualTo: true)
            .where('category.mainCategory',
                isEqualTo: _vendor.selectedProductCategory)
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
                padding: const EdgeInsets.symmetric(vertical: 2),
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
