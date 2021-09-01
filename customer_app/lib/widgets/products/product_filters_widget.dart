import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFilterWidget extends StatefulWidget {
  ProductFilterWidget({Key key}) : super(key: key);

  @override
  _ProductFilterWidgetState createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  List _sublist = [];
  ProductServices _services = ProductServices();
  @override
  void didChangeDependencies() {
    var _vendor = Provider.of<VendorProvider>(context);
    // TODO: implement didChangeDependencies

    FirebaseFirestore.instance
        .collection('products')
        .where('category.mainCategory',
            isEqualTo: _vendor.selectedProductCategory)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                _sublist.add(doc['category']['subCategory']);
              })
            });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _vendor = Provider.of<VendorProvider>(context);
    return FutureBuilder<DocumentSnapshot>(
      future: _services.category.doc(_vendor.selectedProductCategory).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Container();
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        Map<String, dynamic> data = snapshot.data.data();
        return Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          height: 45,
          decoration: BoxDecoration(color: Colors.teal[50]),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: ScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: ActionChip(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.teal,
                  label: Text(
                    'All ${_vendor.selectedProductCategory}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _vendor.SelectedSubCategoryProduct(null);
                  },
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _sublist.contains(data['subCat'][index]['name'])
                        ? ActionChip(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.teal,
                            label: Text(
                              data['subCat'][index]['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _vendor.SelectedSubCategoryProduct(
                                  data['subCat'][index]['name']);
                            },
                          )
                        : Container(),
                  );
                },
                itemCount: data.length,
              )
            ],
          ),
        );
      },
    );
  }
}
