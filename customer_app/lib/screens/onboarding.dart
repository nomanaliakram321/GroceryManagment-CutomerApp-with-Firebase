import 'package:customer_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);
int _currentPag = 0;
List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('images/enteraddress.png')),
      Text(
        'set Your Delivery Location',
        style: kpageviewText,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/orderfood.png')),
      Text('Order Online From your Favourite Store',
          style: kpageviewText, textAlign: TextAlign.center),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/deliverfood.png')),
      Text('Quick Delivery to Your Home ',
          style: kpageviewText, textAlign: TextAlign.center),
    ],
  ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
              controller: _controller,
              children: _pages,
              onPageChanged: (index) {
                setState(() {
                  _currentPag = index;
                });
              }),
        ),
        SizedBox(
          height: 10.0,
        ),
        new DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPag.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeColor: Colors.teal,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                5.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
