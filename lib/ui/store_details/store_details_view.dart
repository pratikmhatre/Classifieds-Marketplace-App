import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/network/response/store_list.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:digigad/ui/store_details/store_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StoreDetailsView extends StatefulWidget {
  late StoreList storeList;

  StoreDetailsView(this.storeList);

  @override
  _StoreDetailsViewState createState() => _StoreDetailsViewState(storeList);
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  late StoreList storeList;
  late StoreDetailsViewModel _storeDetailsViewModel;
  _StoreDetailsViewState(this.storeList);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (context, viewModel, child) {
          var screenWidth = MediaQuery.of(context).size.width;
          return Scaffold(
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: screenWidth,
                      child: Stack(
                        children: [
                          Image.asset(
                            'images/img_dummy_food.jpg',
                            fit: BoxFit.cover,
                            width: screenWidth,
                            height: 250,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 0, top: 25),
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.of(context).pop()),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Opacity(
                          child: Image.asset(
                            'images/img_map.jpg',
                            width: screenWidth,
                            height: 190,
                            fit: BoxFit.fitWidth,
                          ),
                          opacity: .40,
                        ),
                        Container(
                          height: 190,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          width: screenWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.local_dining,
                                  color: Colors.white,
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppConstants.colorPrimary),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'The Pride Kitchen Biryani',
                                style: TextStyle(
                                    color: AppConstants.colorText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Near bus stop, Navi Mumbai, Maharashtra',
                                style: TextStyle(
                                    color: AppConstants.colorText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: AppConstants.colorPrimary,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: AppConstants.colorPrimary,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: AppConstants.colorPrimary,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: AppConstants.colorPrimary,
                                  ),
                                  Icon(
                                    Icons.star_border,
                                    color: AppConstants.colorIcons,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    '4.1',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: AppConstants.colorText),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '(3 reviews)',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppConstants.colorText),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      margin: EdgeInsets.only(top: 16),
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _getFab('Call', Icons.call),
                          _getFab('Add Review', Icons.rate_review),
                          _getFab('Directions', Icons.directions_bike),
                          _getFab('Pay Online', Icons.account_balance_wallet),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    _getTitleDetailsView('Contact', '(+91) 9823596892'),
                    _getTitleDetailsView(
                        'Categories', 'Indian, Thai, Continental...'),
                    _getTitleDetailsView(
                        'Working Hours', '10:00 AM to 10:00 PM'),
                    Divider(
                      height: 1,
                      color: AppConstants.colorDarkGrey,
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    InkWell(
                      onTap: () => AutoRouter.of(context).navigate(
                          StoreMenuViewRoute(storeList: storeList)),
                      child: Container(
                        width: screenWidth,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book),
                            SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'View Menu Card',
                                  style: TextStyle(
                                      color: AppConstants.colorText,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '36 items',
                                  style: TextStyle(
                                      color: AppConstants.colorText,
                                      fontSize: 10),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Divider(
                      height: 1,
                      color: AppConstants.colorDarkGrey,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Best Selling Dishes',
                        style: TextStyle(
                            color: AppConstants.colorText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 180,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            6,
                            (index) => Container(
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 90,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Color(0x8d000000),
                                                    Color(0x0d000000)
                                                  ]),
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6))),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Chicken Mejwani',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Rs.240/-',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          height: 22,
                                          width: 22,
                                          child: Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.green),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 2)),
                                        ),
                                      )
                                    ],
                                  ),
                                  width: screenWidth * .4,
                                  height: 180,
                                  margin: EdgeInsets.only(
                                      left: (index == 0) ? 16 : 0, right: 16),
                                  decoration: BoxDecoration(
                                      color: AppConstants.colorLightGrey,
                                      borderRadius: BorderRadius.circular(6),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'images/img_dummy_food.jpg'),
                                          fit: BoxFit.fill)),
                                )),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Top Reviews',
                        style: TextStyle(
                            color: AppConstants.colorText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(
                          4,
                          (index) => Container(
                                width: screenWidth,
                                margin: EdgeInsets.only(
                                    top: (index == 0) ? 0 : 16,
                                    left: 16,
                                    right: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'images/img_dummy_food.jpg'),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Json Bourne',
                                                  style: TextStyle(
                                                      color: AppConstants
                                                          .colorText,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 20,
                                                      color: AppConstants
                                                          .colorPrimary,
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      '4.2',
                                                      style: TextStyle(
                                                          color: AppConstants
                                                              .colorText,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    color: AppConstants
                                                        .colorLightGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: 300,
                                            child: Text(
                                              'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.',
                                              style: TextStyle(
                                                  color: AppConstants
                                                      .colorDarkGrey,
                                                  fontSize: 13),
                                              maxLines: 3,
                                              textAlign: TextAlign.justify,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => _storeDetailsViewModel);
  }

  _getFab(String title, IconData iconData) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 55,
            width: 55,
            child: Icon(
              iconData,
              color: AppConstants.colorText,
            ),
            decoration: BoxDecoration(
                color: AppConstants.colorLightGrey, shape: BoxShape.circle),
          ),
          Text(
            title,
            style: TextStyle(
                color: AppConstants.colorText,
                fontSize: 12,
                fontWeight: FontWeight.w300),
          )
        ],
      );

  @override
  void initState() {
    super.initState();
    _storeDetailsViewModel = locator<StoreDetailsViewModel>();
  }

  _getTitleDetailsView(String title, String details) => Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            Divider(
              height: 1,
              color: AppConstants.colorDarkGrey,
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: AppConstants.colorText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    details,
                    style: TextStyle(
                        color: AppConstants.colorPrimary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
