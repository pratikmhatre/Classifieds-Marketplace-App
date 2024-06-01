import 'package:cached_network_image/cached_network_image.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/data/network/response/store_list.dart';
import 'package:digigad/resources/data/network/response/store_menu.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/ui/stores/seller_dashboard/store_menu_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StoreMenuView extends StatefulWidget {
  final StoreList storeList;

  StoreMenuView(this.storeList);

  @override
  _StoreMenuViewState createState() =>
      _StoreMenuViewState(storeList);
}

class _StoreMenuViewState extends State<StoreMenuView>
    with SingleTickerProviderStateMixin {
  late StoreList _storeList;
  late TabController _tabController;
  late StoreMenuViewModel _dashboardViewModel;
  List<Color> _colors = [
    Color.fromRGBO(0, 0, 0, 0.5),
    Color.fromRGBO(0, 0, 0, 0.2),
    Color.fromRGBO(0, 0, 0, 0.0)
  ];
  List<double> _stops = [0.3, 0.8, 1];

  _StoreMenuViewState(this._storeList);

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _storeList.categories?.length ?? 0, vsync: this);
    _dashboardViewModel = locator<StoreMenuViewModel>();
    _dashboardViewModel.setStoreData(_storeList);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoreMenuViewModel>.reactive(
        builder: (context, viewModel, child) {
          var screenWidth = MediaQuery.of(context).size.width;
          var screenHeight = MediaQuery.of(context).size.height;
          return Scaffold(
            appBar: AppBar(
              title: Text('Menu Card'),
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                      isScrollable: true,
                      onTap: viewModel.onTabChanged,
                      labelPadding: EdgeInsets.symmetric(horizontal: 32),
                      labelColor: AppConstants.colorPrimary,
                      indicatorColor: AppConstants.colorPrimary,
                      unselectedLabelColor: Colors.grey,
                      indicatorWeight: 2,
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      controller: _tabController,
                      tabs: List.generate(
                        _storeList.categories?.length ?? 0,
                            (index) => _getTab(
                            _storeList.categories![index].name ?? '', index),
                      )),
                  Expanded(
                    child: TabBarView(
                      children: List.generate(
                          _storeList.categories?.length ?? 0, (index) {
                        var category = _storeList.categories![index].name;

                        return ListView.builder(
                            itemCount:
                            (viewModel.getStoreItems(category ?? '') ?? [])
                                .length,
                            itemBuilder: (context, index) {
                              var menuItem =
                              viewModel.getStoreItems(category ?? '');
                              return _getProductListItem(
                                  context, index, menuItem![index], (viewModel.getStoreItems(category ?? '') ?? [])
                                  .length);
                            });
                      }),
                      controller: _tabController,
                    ),
                  )
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => _dashboardViewModel);
  }

  _getProductListItem(context, index, StoreItem storeItem, int listSize) {
    String? variants;

    if (storeItem.variants != null && storeItem.variants.isNotEmpty) {
      for (var variant in storeItem.variants) {
        variants = 'Rs.${variant.price}/- (${variant.name})     ';
      }
    }

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: index == 0 ? 16 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFunctions.getVegNonVegWidget(storeItem.isVeg),
          SizedBox(
            height: 4,
          ),
          Text(
            storeItem.name,
            maxLines: 2,
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            variants ?? 'Rs.${storeItem.basePrice}/-',
            maxLines: 1,
            style: TextStyle(color: Colors.blueGrey, fontSize: 12),
          ),
          SizedBox(
            height: 16,
          ),
          Visibility(
            visible: index != listSize-1,
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              height: 0.3,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  _getStoreDetails(BuildContext context, screenHeight, screenWidth) {
    var isWorking =
        AppFunctions.isWithinWorkHours(_storeList.workingHours);

    return Column(
      children: <Widget>[
        CachedNetworkImage(
          height: 160,
          imageUrl: _storeList.images?[0].image ?? '',
          fit: BoxFit.cover,
          width: screenWidth,
        ),
        Container(
          width: screenWidth,
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _storeList.name,
                      style: TextStyle(
                          color: AppConstants.colorText,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      _storeList.address,
                      style: TextStyle(
                          color: AppConstants.colorDarkGrey, fontSize: 14),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      _storeList.details?[0] ?? '',
                      style: TextStyle(
                          color: AppConstants.colorText, fontSize: 14),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: isWorking ? 'Open Now  ' : 'Closed  ',
                          style: TextStyle(
                              color: isWorking
                                  ? AppConstants.colorPrimary
                                  : Colors.red,
                              fontSize: 14),
                        ),
                        TextSpan(
                          text: _storeList.workingHours,
                          style: TextStyle(
                              color: AppConstants.colorText,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: AppConstants.colorText,
                          size: 20,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          _storeList.deliveryNote ?? '',
                          style: TextStyle(
                              color: AppConstants.colorText,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                margin: EdgeInsets.only(left: 16),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '4.5',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(12)),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _getIconButton(Icons.call, 'Order Now',
                  () => _dashboardViewModel.callStore()),
              _getIconButton(Icons.star_border, 'Reviews',
                  () => _dashboardViewModel.callStore()),
              _getIconButton(Icons.map, 'Map',
                  () => AppFunctions.openMap(_storeList.coordinates ?? '')),
              _getIconButton(Icons.share, 'Share', () => _shareStore(context)),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  _getBigImageItemView(gridWidth) {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: gridWidth,
                height: gridWidth,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/img_dummy_food.jpg'),
                        fit: BoxFit.cover),
                    color: AppConstants.colorLightGrey,
                    borderRadius: BorderRadius.circular(6)),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      topLeft: Radius.circular(4)),
                  gradient: LinearGradient(
                      colors: _colors,
                      stops: _stops,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
              ),
              Positioned(
                child: Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 22,
                ),
                right: 8,
                top: 8,
              )
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 4, right: 4, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Samosa (200gm)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.colorText,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Rs.90-120/-',
                        style: TextStyle(
                            color: AppConstants.colorPrimary,
                            fontSize: 14,
                            letterSpacing: .1,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                        margin: EdgeInsets.only(left: 16),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 10,
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 1.3,
                                ),
                                Text(
                                  '4.2',
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 10),
                                ),
                              ],
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(8)),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(6)),
    );
  }

  _shareStore(context) {
    AppFunctions.createAndShareDynamicLink(context, DynamicLinkType.share_store,
        uid: _storeList.id.toString(),
        title: _storeList.name,
        image: _storeList.images,
        details: _storeList.details);
  }

  _getTab(String title, int index) {
    var isSelected = index == _dashboardViewModel.getPagerPosition;
    return Tab(
      text: title,
    );
  }

  _getIconButton(IconData icon, String title, onClick) => InkWell(
        onTap: () => onClick(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: AppConstants.colorText,
            ),
            Text(
              title,
              style: TextStyle(
                  color: AppConstants.colorText,
                  fontSize: 13,
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
      );
}
