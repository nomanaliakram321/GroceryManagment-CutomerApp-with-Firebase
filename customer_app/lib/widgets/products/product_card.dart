import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  ProductCard(this.documentSnapshot);
  @override
  Widget build(BuildContext context) {
    String offer = ((documentSnapshot.data()['priceBefore'] -
                documentSnapshot.data()['price']) /
            documentSnapshot.data()['priceBefore'] *
            100)
        .toStringAsFixed(0);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, offset: Offset.zero, blurRadius: 5)
          ],
          borderRadius: BorderRadius.circular(25)),
      height: 160,
      // width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        child: Row(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Container(
                    child: Image.network(
                      documentSnapshot.data()['productImage'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      )),
                  child: Text(
                    '$offer % OFF',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 180,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.teal[50],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                documentSnapshot.data()['brand'],
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          documentSnapshot.data()['productName'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          '1 ${documentSnapshot.data()['weight']}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                          'Rs ${documentSnapshot.data()['price'].toStringAsFixed(0)}'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${documentSnapshot.data()['priceBefore'].toString()}',
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 170,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              color: Colors.teal,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {},
                              child: Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
