import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/screens/shop_locations.dart';
import 'package:customer_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class UnPublishProduct extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  UnPublishProduct(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(left: 5),
        height: 100,
        width: 160,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.pushReplacementNamed(context, MapShopLocation.id);
                  },
                  child: SizedBox(
                    height: 100,
                    child: new Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            documentSnapshot['productImage'],

                            //
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  documentSnapshot['productName'],
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.favorite_border),
                      Text(
                        ' Rs ' + documentSnapshot['price'].toStringAsFixed(0),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

//   Widget build(BuildContext context) {
//     FirebaseServices _services = FirebaseServices();
//     return Container(
//       child: StreamBuilder(
//         stream:
//             _services.product.where('published', isEqualTo: false).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Something Went Wrong');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//                 child: SizedBox(
//                     height: 30, width: 30, child: CircularProgressIndicator()));
//           }
//           return snapshot.data != null
//               ? SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//
//             child: Container(
//               margin: EdgeInsets.only(left: 5),
//
//               height: 100,
//               width: 100,
//               child:  Neumorphic(
//                   style: NeumorphicStyle(
//                     shape: NeumorphicShape.convex,
//
//                     shadowLightColor: Colors.white,
//                     shadowDarkColor: Colors.white,
//                     color: Colors.white,border:NeumorphicBorder(isEnabled: true,) ,
//                     depth: 3,
//
//
//                     boxShape:
//                     NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
//                   ),
//
//                   child: Column(
//
//
//
//                     children: [
//
//                       InkWell(
//                         onTap: (){
//                           Navigator.pushReplacementNamed(context, MapShopLocation.id);
//                         },
//                         child: SizedBox(
//                           height: 90,
//                           width: double.infinity,
//                           child: new Card(
//
//                             elevation: 3,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(15.0),
//                                 child: Image.network(
//                                   documentSnapshot['image'],
//
//                                   fit: BoxFit.cover,
//                                 )),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 3,),
//                       Text(
//                         documentSnapshot['categoryName'],
//
//                         style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
//                       ),
//
//                     ],
//                   )),
//             ),
//           )
//               : Center(child: Text('No Product Added Yet'));
//         },
//       ),
//     );
//   }
//
//   List<DataRow> _productDetails(QuerySnapshot snapshot) {
//     List<DataRow> newList =
//         snapshot.docs.map((DocumentSnapshot documentSnapshot) {
//       if (documentSnapshot != null) {
//         return DataRow(cells: [
//           DataCell(
//               Container(child: Text(documentSnapshot.data()['productName']))),
//           DataCell(Container(
//               child: Image.network(
//             documentSnapshot.data()['productImage'],
//             height: 40,
//           ))),
//           DataCell(Text('hi'))
//         ]);
//       }
//     }).toList();
//     return newList;
//   }
// }

// DataTable(
// showBottomBorder: true,
// dataRowHeight: 60,
// headingRowColor: MaterialStateProperty.all(Colors.teal[50]),
// columns: <DataColumn>[
// DataColumn(
// label: Text(
// ' Name',
// style: TextStyle(fontWeight: FontWeight.bold),
// )),
// DataColumn(
// label: Text(
// 'Image',
// style: TextStyle(fontWeight: FontWeight.bold),
// )),
// DataColumn(
// label: Text(
// 'Action',
// style: TextStyle(fontWeight: FontWeight.bold),
// )),
// ],
// rows: _productDetails(snapshot.data),
// ),
