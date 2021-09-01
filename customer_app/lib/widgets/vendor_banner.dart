
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/providers/vendor_provider.dart';
import 'package:customer_app/services/shop_services.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorBanners extends StatefulWidget {
  @override
  _VendorBannersState createState() => _VendorBannersState();
}

class _VendorBannersState extends State<VendorBanners> {
  int _index=0;
  int _dataLenghth=1;
  @override
  void didChangeDependencies() {
    var _storeProvider=Provider.of<VendorProvider>(context);
    getSliderImagesFromServer(_storeProvider);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  @override
  Future getSliderImagesFromServer(VendorProvider vendorProvider)async
  {
    var _fireStore=FirebaseFirestore.instance;
    QuerySnapshot snapshot=await _fireStore.collection('vendorBanner').
    where('sellerId',isEqualTo:vendorProvider.vendorInfo['uid'] ).get();
    if(mounted)
    {
      setState(() {
        _dataLenghth=snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  ShopServices _shopServices=ShopServices();
  @override
  Widget build(BuildContext context) {
    var _storeProvider=Provider.of<VendorProvider>(context);
    return Container(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          if(_dataLenghth!=0)
            FutureBuilder(future: getSliderImagesFromServer(_storeProvider),
                builder:(_,snapshot){
              return snapshot.data==null ? Center(child: CircularProgressIndicator(),):
              CarouselSlider.builder(
                itemCount: snapshot.data.length,
                itemBuilder: ( context, int itemIndex) {
                  DocumentSnapshot sliderImage=snapshot.data[itemIndex];
                  Map getImage=sliderImage.data();

                  return  Container(
                    margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.teal,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),


                          child: Image.network(getImage['imageUrl'],fit: BoxFit.fill,)));

                },
                options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    onPageChanged: (int i,carouselPageChangedReason){
                      setState(() {
                        _index=i;
                      });
                    },

                    initialPage: 2,

                    aspectRatio: 16/9,
                    height: 150.0
                ),
              );
            }),
          if(_dataLenghth!=0)
            DotsIndicator(
              dotsCount: _dataLenghth,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                size: const Size.square(5.0),
                activeSize: const Size(18.0, 5.0),
                activeColor: Colors.teal,
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                ),
              ),
            ),
        ],
      )
    );
  }
}
