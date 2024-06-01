import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/ad_functions.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/data/network/response/ads.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:digigad/ui/dashboard/dashboard_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class DashboardView extends StatefulWidget {
  final _DashboardViewState _dashState = _DashboardViewState();

  @override
  _DashboardViewState createState() {
    return _dashState;
  }

  void onNewAdPosted() {
    _dashState.onNewAdPosted();
  }
}

class _DashboardViewState extends State<DashboardView>
    with AutomaticKeepAliveClientMixin {
  late DashboardViewmodel _dashboardViewModel;
  var _imagePicker = ImagePicker();
  var _verticalMargin = 22.0;

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void initState() {
    super.initState();
    _dashboardViewModel = locator<DashboardViewmodel>();
    _dashboardViewModel.fetchStoreCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<DashboardViewmodel>.reactive(
        builder: (context, viewModel, child) {
          var screenWidth = MediaQuery.of(context).size.width;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      margin: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu,
                            color: AppConstants.colorIcons,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          AppFunctions.getSearchWidget(),
                          SizedBox(
                            width: 16,
                          ),
                          Icon(
                            Icons.map_outlined,
                            color: AppConstants.colorIcons,
                          ),
                        ],
                      ),
                    ), //Appbar
                    Container(
                      height: 90,
                      margin: EdgeInsets.only(top: 25),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: List.generate(
                            viewModel.getStoreCategories.length,
                            (index) => InkWell(
                                  onTap: () =>
                                      _onMainGridItemClicked(index, context),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: (index == 0) ? 16 : 0, right: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          child: Center(
                                              child: Image(
                                            image: NetworkImage(viewModel
                                                    .getStoreCategories[index]
                                                    .icon ??
                                                ''),
                                            height: 32,
                                            width: 32,
                                          )),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFF1F4F8)),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          viewModel
                                              .getStoreCategories[index].title,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppConstants.colorText),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      child: Stack(
                        children: [
                          Container(
                            height: 300,
                            margin: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                                color: AppConstants.colorBackground,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image:
                                        AssetImage('images/img_dummy_food.jpg'),
                                    fit: BoxFit.fill)),
                          ),
                          Positioned(
                            left: 32,
                            right: 32,
                            bottom: 32,
                            child: Container(
                              height: 150,
                              padding: EdgeInsets.all(16),
                              width: screenWidth - 64,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'The Pride Kitchen Biryani',
                                              style: TextStyle(
                                                  color: AppConstants.colorText,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              'Near bus stop, Navi Mumbai, Maharashtra',
                                              style: TextStyle(
                                                  color: AppConstants
                                                      .colorDarkGrey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          child: Icon(
                                            Icons.local_dining,
                                            color: Colors.white,
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppConstants.colorPrimary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Divider(
                                    color: AppConstants.colorDarkGrey,
                                    height: 1,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: AppConstants.colorPrimary,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              '4.1',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppConstants.colorText),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'icons/ic_leaf.png',
                                              height: 18,
                                              width: 18,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              'Pure Veg',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      AppConstants.colorText),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'icons/ic_car.png',
                                              height: 18,
                                              width: 18,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              '2.11 Km',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      AppConstants.colorText),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _getTitleText('Nearby Stores'),
                          Text(
                            'View all',
                            style: TextStyle(
                                color: AppConstants.colorPrimary, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 250,
                      margin: EdgeInsets.only(top: 12),
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            6,
                            (index) => Container(
                                  width: screenWidth * .55,
                                  margin: EdgeInsets.only(
                                      left: (index == 0) ? 16 : 0, right: 16),
                                  height: 190,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 150,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        'images/img_dummy_food.jpg'))),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              height: 22,
                                              width: 22,
                                              child: Center(
                                                child: Container(
                                                  width: 12,
                                                  height: 12,
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
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'The Pride Kitchen Biryani',
                                                  style: TextStyle(
                                                      color: AppConstants
                                                          .colorText,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  'Near bus stop, Navi Mumbai, Maharashtra',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: AppConstants
                                                          .colorDarkGrey,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 18,
                                                  color:
                                                      AppConstants.colorPrimary,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  '4.2',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppConstants
                                                          .colorText),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _getTitleText('Buy & Sell'),
                          InkWell(
                            onTap: () => context.router
                                .navigate(AllCategoriesViewRoute()),
                            child: Text(
                              'View all',
                              style: TextStyle(
                                  color: AppConstants.colorPrimary,
                                  fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 0.7,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(
                        viewModel.getAdList.length,
                        (index) {
                          var adItem = viewModel.getAdList[index];
                          return AdFunctions.getAdItemView(false,
                              index: index,
                              ad: adItem,
                              context: context,
                              onLikeClicked: () =>
                                  viewModel.onLikeAdClicked(index),
                              onReportClicked: () => _onReportClicked(
                                  adItem.id, context, viewModel),
                              onAdClicked: () =>
                                  _onAdClicked(adItem, index, context),
                              // myUserId: viewModel.getMyUserId ?? '');
                              myUserId: '');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => _dashboardViewModel);
  }

  _onAdClicked(Ads ad, int index, BuildContext buildContext) async {
    //TODO: Handle back data

    buildContext.router
        .push(AdDetailsViewRoute(adData: ad, adId: null, position: index));

    /*Map<String, dynamic> openDetails =
        await ExtendedNavigator.ofRouter<Router>()
            .pushAdDetailsViewRoute(adData: ad, adId: null, position: index);

    if (openDetails.containsKey('position')) {
      var position = openDetails['position'] as int;
      var isLiked = openDetails['liked'] as bool;
      _dashboardViewModel.onAdListResumed(position, isLiked);
    } else if (openDetails.containsKey('delete') &&
        openDetails['delete'] == true) {
      _dashboardViewModel.fetchLatestAds();
    }*/
  }

  _onReportClicked(
      int adId, BuildContext context, DashboardViewmodel viewModel) {
    Navigator.pop(context);

    var height = MediaQuery.of(context).size.height * 3 / 4;
    AppFunctions.showMasterSelectionBottomSheet(
        viewModel.onReportReasonSelected,
        context: context,
        title: 'Select Report Reason',
        bottomsheetHeight: height,
        masterListFuture: viewModel.getReportReasons(),
        adId: adId,
        isReporting: true,
        onMasterSelected: null);
  }

  _onCameraClicked(BuildContext buildContext) async {
    var file = await _imagePicker.getImage(source: ImageSource.camera);
    if (file != null) {
      //TODO:Handle back data
      buildContext.router.push(CreateAdViewRoute(cameraImage: file.path));

      /*bool isCreated = await ExtendedNavigator.ofRouter<Router>()
          .pushCreateAdView(cameraImage: file.path);
      if (isCreated) {
        _dashboardViewModel.fetchLatestAds();
      }*/
    }
  }

  Widget _getTitleText(String title) => Text(
        title,
        style: TextStyle(
            color: AppConstants.colorButton,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      );

  _onMainGridItemClicked(int position, BuildContext buildContext) {
    var category =
        _dashboardViewModel.getStoreCategories[position].id.toString();
    buildContext.router.push(StoreListViewRoute(categoryId: category));
  }

  void onNewAdPosted() {
    _dashboardViewModel.fetchLatestAds();
  }
}
