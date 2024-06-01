import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/ui/stores/strore_pdp/StorePdpViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StorePdpView extends StatefulWidget {
  @override
  _StorePdpViewState createState() => _StorePdpViewState();
}

class _StorePdpViewState extends State<StorePdpView> {
  late StorePdpViewModel _pdpViewModel;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pdpViewModel = locator<StorePdpViewModel>();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.call,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: screenHeight * 0.4,
              width: screenWidth,
              child: Stack(
                children: <Widget>[
                  PageView.builder(
                    itemBuilder: (context, index) {
                      return Image.asset(
                        'images/img_dummy_food.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                    controller: _pageController,
                    itemCount: 3,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 20,
                      width: 80,
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        effect: SlideEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 8,
                          dotColor: Colors.white,
                          activeDotColor: AppConstants.colorPrimary,
                        ),
                        count: 3,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton<int>(
                      color: Colors.white,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text('Share'),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text('Report'),
                            value: 1,
                          ),
                        ];
                      },
                      onSelected: (int i) {
                        Fluttertoast.showToast(msg: '$i');
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Fragrance Sticks',
                              style: TextStyle(
                                  color: AppConstants.colorText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Rs.350/-',
                              style: TextStyle(
                                  color: AppConstants.colorPrimary,
                                  fontSize: 20,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 4,
                          ),
                          Image.asset(
                            'icons/ic_location_pin.png',
                            width: 18,
                            height: 18,
                            color: AppConstants.colorText,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            '2.3 km',
                            style: TextStyle(color: AppConstants.colorText),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'View price by quantity',
                        style: TextStyle(
                            color: AppConstants.colorText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '   Bulk Orders Accepted',
                        style: TextStyle(
                            color: AppConstants.colorPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                  ])),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 35,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          margin: EdgeInsets.only(left: index == 0 ? 0 : 16),
                          child: Center(
                            child: Text(
                              '100 gm',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 14),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.colorLightGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      },
                      itemCount: 5,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text('Product Details',
                      style: TextStyle(
                          color: AppConstants.colorText,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                      "What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
                      style: TextStyle(
                          color: AppConstants.colorDarkGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: 30,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Ratings & Reviews',
                        style: TextStyle(
                            color: AppConstants.colorText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '   Add Review',
                        style: TextStyle(
                            color: AppConstants.colorPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                  ])),
                  ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: EdgeInsets.only(
                            top: 20, bottom: index == 5 ? 20 : 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('images/dummy_product.jpeg'),
                              radius: 25,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Pratik Mhatre | Thal',
                                  style: TextStyle(
                                      color: AppConstants.colorText,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  itemSize: 20,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppConstants.colorPrimary,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'Very Good Product it is. Very tasty \n I have ordered it twice a month. Lorem ipsuym',
                                  style: TextStyle(
                                      color: AppConstants.colorDarkGrey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ))
                          ],
                        ),
                      );
                    },
                    itemCount: 6,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
