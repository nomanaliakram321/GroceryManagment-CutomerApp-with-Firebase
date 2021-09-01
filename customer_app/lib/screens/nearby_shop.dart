import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/services/shop_services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class NearByShop extends StatefulWidget {
  NearByShop({Key key}) : super(key: key);

  @override
  _NearByShopState createState() => _NearByShopState();
}

class _NearByShopState extends State<NearByShop> {
  ShopServices _services = ShopServices();
  PaginateRefreshedChangeListener _refreshedChangeListener =
      PaginateRefreshedChangeListener();
  @override
  Widget build(BuildContext context) {
    final _vendor = Provider.of<VendorProvider>(context);
    _vendor.getUserLocation(context);

    String getDistance(location) {
      var distance = Geolocator.distanceBetween(_vendor.userLatitude,
          _vendor.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000; //show distance in km
      return distanceInKm.toStringAsFixed(2);
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _services.getNearShop(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          List shopDistance = [];
          for (int i = 0; i < snapshot.data.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
                _vendor.userLatitude,
                _vendor.userLongitude,
                snapshot.data.docs[i]['location'].latitude,
                snapshot.data.docs[i]['location'].longitude);
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort(); //this will help u to find nearest shop
          if (shopDistance[0] > 10) {
            return Container(
              child: Center(child: Text('no services')),
            );
          }
          return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    _refreshedChangeListener.refreshed = true;
                  },
                  child: PaginateFirestore(
                    bottomLoader: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)),
                    header: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 8, top: 20),
                          child: Text('All NearBy Shop',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 8, top: 5),
                          child: Text('Find out Good Quality Products',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16,
                              )),
                        ),
                      ],
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilderType: PaginateBuilderType.listView,
                    itemBuilder: (index, context, document) => Padding(
                      padding: EdgeInsets.all(4),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Card(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    document['imageUrl'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      document.data()['shopName'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    document.data()['dialog'],
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      document.data()['address'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    '${getDistance(document['location'])}km',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_outline,
                                        color: Colors.teal,
                                        size: 12,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '3.3',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    query: _services.getNearShopPagination(),
                    listeners: [
                      _refreshedChangeListener,
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
