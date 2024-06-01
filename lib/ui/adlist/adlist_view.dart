import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/ad_functions.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/data/network/response/ads.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:digigad/ui/adlist/adlist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AdlistView extends StatefulWidget {
  String? categoryId;
  String? searchQuery;
  AdListType adListType;

  AdlistView(
      {this.categoryId, this.searchQuery, required this.adListType});

  @override
  _AdlistViewState createState() =>
      _AdlistViewState(categoryId, searchQuery, adListType);
}

class _AdlistViewState extends State<AdlistView> {
  final String? categoryId;
  final String? searchQuery;
  final AdListType adListType;
  late AdlistViewModel _adlistViewModel;

  _AdlistViewState(this.categoryId, this.searchQuery, this.adListType);

  @override
  void initState() {
    super.initState();
    _adlistViewModel = locator<AdlistViewModel>();
    _adlistViewModel.set(categoryId);

    _adlistViewModel.fetchAdlist(
        adListType: adListType, searchQuery: searchQuery, isInitial: true);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdlistViewModel>.reactive(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: SafeArea(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: AppConstants.horizontalMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.pop(context)),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            //TODO: Handle back data
                            context.router.push(SearchViewRoute(
                                isFromDashboard: false,
                                searchQuery: viewModel.getSearchQuery));
                            /*String results =
                                await ExtendedNavigator.ofRouter<Router>()
                                    .pushSearchView(
                                        isFromDashboard: false,
                                        searchQuery: viewModel.getSearchQuery);
                            if (results != null && results.trim().isNotEmpty) {
                              viewModel.fetchAdlist(
                                  searchQuery: results,
                                  adListType: AdListType.SearchAds,
                                  isInitial: true);*/
                          },
                          child: Container(
                            height: 55,
                            margin: EdgeInsets.only(
                                right:
                                    adListType == AdListType.LikedAds ? 16 : 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 5)
                              ],
                              border: Border.all(
                                color: Color(0xAAEEEEEE),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'icons/ic_search.png',
                                    height: 24,
                                    width: 24,
                                    color: AppConstants.colorText,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      viewModel.getSearchQuery ??
                                          AppConstants.defaultSearchLabel,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppConstants.colorHint),
                                    ),
                                  )),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: adListType != AdListType.LikedAds,
                        child: GestureDetector(
                          onTap: () => context.router.push(
                              AdlistViewRoute(adListType: AdListType.LikedAds)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Image.asset(
                              'icons/ic_heart.png',
                              height: 26,
                              width: 26,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                AppFunctions.getStandardDivider(),
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Visibility(
                          visible: viewModel.isBusy,
                          child: Container(
                            width: 45,
                            height: 45,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppConstants.colorLightGrey,
                                      blurRadius: 6)
                                ]),
                          ),
                        ),
                      ),
                      (viewModel.getAdsList.isEmpty && !viewModel.isBusy)
                          ? Center(child: _getProperEmptyState())
                          : NotificationListener<ScrollNotification>(
                              child: GridView.count(
                                shrinkWrap: true,
                                childAspectRatio: 0.7,
                                scrollDirection: Axis.vertical,
                                crossAxisCount: 2,
                                children: List.generate(
                                  viewModel.getAdsList.length,
                                  (index) {
                                    var adItem = viewModel.getAdsList[index];
                                    return AdFunctions.getAdItemView(false,
                                        index: index,
                                        ad: adItem,
                                        context: context,
                                        onReportClicked: () => _onReportClicked(
                                            adItem.id, context, viewModel),
                                        onLikeClicked: () =>
                                            viewModel.onLikeAdClicked(index),
                                        onAdClicked: () => _onAdClicked(
                                            adItem, index, context),
                                        myUserId: viewModel.getMyUserId ?? '');
                                  },
                                ),
                              ),
                              onNotification:
                                  (ScrollNotification notification) {
                                if (notification.metrics.pixels ==
                                    notification.metrics.maxScrollExtent) {
                                  if (!viewModel.isBusy) {
                                    viewModel.fetchAdlist(
                                        adListType: AdListType.CategoryAds,
                                        isInitial: false);
                                  }
                                }

                                return true;
                              },
                            ),
                    ],
                  ),
                )
              ],
            )),
          );
        },
        viewModelBuilder: () => _adlistViewModel);
  }

  _onReportClicked(int adId, BuildContext context, AdlistViewModel viewModel) {
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

  Widget _getProperEmptyState() {
    EmptyStates emptyState = EmptyStates.SomethingWentWrong;
    if (_adlistViewModel.fetchAdsResponse != null &&
        _adlistViewModel.fetchAdsResponse?.statusCode != 200) {
      emptyState = EmptyStates.SomethingWentWrong;
    } else if (_adlistViewModel.getAdsList.isEmpty) {
      emptyState = adListType == AdListType.SearchAds
          ? EmptyStates.NoSearchResults
          : EmptyStates.NoAdsFound;
    }
    return AdFunctions.getEmptyState(state: emptyState);
  }

  _onAdClicked(Ads ad, int index, BuildContext context) async {
    //:TODO : Handle back data

    context.router.push(AdDetailsViewRoute(adData: ad, adId: null, position: index));

    /*Map<String, dynamic> openDetails =
        await ExtendedNavigator.ofRouter<Router>()
            .pushAdDetailsViewRoute(adData: ad, adId: null, position: index);
    if (openDetails.containsKey('position')) {
      var position = openDetails['position'] as int;
      var isLiked = openDetails['liked'] as bool;
      _adlistViewModel.onAdListResumed(position, isLiked);
    } else if (openDetails.containsKey('delete') &&
        openDetails['delete'] == true) {
      _adlistViewModel.fetchAdlist(
          adListType: adListType, searchQuery: searchQuery, isInitial: true);
    }*/
  }
}
