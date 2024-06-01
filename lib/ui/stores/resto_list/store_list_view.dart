import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:digigad/ui/stores/resto_list/store_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StoreListView extends StatefulWidget {
  final String categoryId;

  StoreListView(this.categoryId);

  @override
  _StoreListViewState createState() => _StoreListViewState(categoryId);
}

class _StoreListViewState extends State<StoreListView> {
  final String categoryId;

  _StoreListViewState(this.categoryId);

  @override
  void initState() {
    super.initState();
    _restoListViewModel = locator<StoreListViewModel>();
    _restoListViewModel.getStoreList(categoryId);
  }

  @override
  Widget build(BuildContext buildContext) {
    var screenWidth = MediaQuery.of(buildContext).size.width;
    return ViewModelBuilder<StoreListViewModel>.reactive(
        builder: (context, viewModel, child) => Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: screenWidth,
                      height: 66,
                      color: Colors.white,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          AppFunctions.getSearchWidget(),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppConstants.colorBackground),
                            child: Center(child: Icon(Icons.sort)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: AppConstants.colorBackground,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            var storeItem = viewModel.getRestoList[index];

                            return InkWell(
                              onTap: () {
                                // rootNavigator.pushSellerDashboard();
                                AutoRouter.of(context).push(
                                    StoreDetailsViewRoute(
                                        storeList: storeItem));
                                /*AutoRouter.of(context).push(
                                    SellerDashboardViewRoute(
                                        storeList: storeItem));*/
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6)),
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    top: index == 0 ? 8 : 0,
                                    bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 110,
                                          height: 120,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          storeItem.images?[0].image ??
                                                              ''),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            height: 18,
                                            width: 18,
                                            child: Center(
                                              child: Container(
                                                width: 8,
                                                height: 8,
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
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            storeItem.name,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            storeItem.address,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Color(0xFF707070),
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
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
                                                        fontSize: 14,
                                                        color: AppConstants
                                                            .colorText),
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Text(
                                                    '(2 reviews)',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            Color(0xFF707070)),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                        'icons/ic_car.png'),
                                                    height: 18,
                                                    width: 18,
                                                    color: Color(0xFF707070),
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    '0 kms',
                                                    // '${storeItem.distance.toStringAsFixed(1)} kms',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF707070),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: viewModel.getRestoList.length,
                          shrinkWrap: true,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => _restoListViewModel);
  }

  late StoreListViewModel _restoListViewModel;
}
