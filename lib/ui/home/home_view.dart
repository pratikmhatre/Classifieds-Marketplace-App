import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:digigad/ui/dashboard/dashboard_view.dart';
import 'package:digigad/ui/home/home_viewmodel.dart';
import 'package:digigad/ui/menu/menu_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late DashboardView _dashboardView;
  late MenuView _menuView;
  late TabController _tabController;
  late HomeViewModel _homeViewModel;

  @override
  void initState() {
    super.initState();
    _homeViewModel = locator<HomeViewModel>();
    _homeViewModel.init();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _dashboardView = locator<DashboardView>();
    _menuView = locator<MenuView>();
    _homeViewModel.onPagerPositionChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        builder: (context, viewModel, child) {
          return WillPopScope(
            onWillPop: () async {
              if (viewModel.getPagerPosition == 1) {
                _tabController.animateTo(0);
                viewModel.onPagerPositionChanged(0);
                return false;
              } else {
                if (viewModel.backPresses == 0 ||
                    (viewModel.backPresses % 6 == 0)) {
                  _showRatingDialog(context);
                  return false;
                } else {
                  return true;
                }
              }
            },
            child: Scaffold(
              backgroundColor: AppConstants.colorLightGrey,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(
                    height: 0.5,
                    color: AppConstants.colorLightGrey,
                  ),
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: TabBar(
                              controller: _tabController,
                              labelColor: AppConstants.colorPrimary,
                              labelPadding: EdgeInsets.only(top: 6),
                              unselectedLabelColor: AppConstants.colorDarkGrey,
                              onTap: (i) {
                                viewModel.onPagerPositionChanged(i);
                              },
                              tabs: [
                                _getTab('icons/ic_home.png', 'Explore', 0),
                                _getTab('icons/ic_user.png', 'My Account', 1),
                              ]),
                        ),
                        Center(
                          child: Container(
                            height: 45,
                            width: 45,
                            child: FloatingActionButton(
                              onPressed: () => _onSellButtonClicked(context),
                              splashColor: AppConstants.colorPrimary,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              backgroundColor: AppConstants.colorButton,
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppConstants.colorPrimary,
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                      offset: Offset(0, 5))
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              body: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [_dashboardView, _menuView],
              ),
            ),
          );
        },
        viewModelBuilder: () => _homeViewModel);
  }

  _onSellButtonClicked(BuildContext context) async {
    context.router.push(SellerRegistrationViewRoute());
  //:TODO: Handle back data
/*
    bool openCreateAd =
        await ExtendedNavigator.ofRouter<Router>().pushCreateAdView();

    if (openCreateAd) {
      _dashboardView.onNewAdPosted();
    }
*/
  }

  _getTab(String image, String title, int index) {
    return Tab(
      child: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                image,
                height: 22,
                width: 22,
                color: _homeViewModel.getPagerPosition == index
                    ? AppConstants.colorPrimary
                    : AppConstants.colorDarkGrey,
              ),
              Divider(
                height: 2,
                color: Colors.transparent,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showRatingDialog(BuildContext context) async {
    var screenWidth = MediaQuery.of(context).size.width;
    await showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 400,
                width: screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'images/img_rating.png',
                      width: 250,
                    ),
                    Text(
                      'Liked our work ?\nWe would love to hear it from you.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            AppFunctions.openPlayStore();
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              'Rate Now',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppConstants.colorPrimary),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppFunctions.exitApp();
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              'Ignore & Exit',
                              style: TextStyle(
                                  color: AppConstants.colorPrimary,
                                  fontSize: 16),
                            )),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppConstants.colorPrimary,
                                    width: 1.5)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          );
        });
  }
}
