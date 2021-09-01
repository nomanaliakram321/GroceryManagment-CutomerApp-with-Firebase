import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class HomeSlider extends StatefulWidget {
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int _index=0;
  int _dataLenghth=1;
  @override
  void initState() {
    getSliderImagesFromServer();
    // TODO: implement initState
    super.initState();
  }
  @override
  Future getSliderImagesFromServer()async
  {
    var _fireStore=FirebaseFirestore.instance;
    QuerySnapshot snapshot=await _fireStore.collection('slider').get();
   if(mounted)
     {
       setState(() {
         _dataLenghth=snapshot.docs.length;
       });
     }
    return snapshot.docs;
  }
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        if(_dataLenghth!=0)
        FutureBuilder(future: getSliderImagesFromServer(),builder:(_,snapshot){
          return snapshot.data==null ? Center(child: CircularProgressIndicator(),):
          CarouselSlider.builder(
            itemCount: snapshot.data.length,
            itemBuilder: ( context, int itemIndex) {
              DocumentSnapshot sliderImage=snapshot.data[itemIndex];
              Map getImage=sliderImage.data();

              return  Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.teal,
                  ),
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),


                      child: Image.network(getImage['image'],fit: BoxFit.cover,)));

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
    );
  }
}
