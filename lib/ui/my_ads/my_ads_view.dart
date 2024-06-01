import 'package:digigad/resources/ad_functions.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/network/response/ads.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/ui/my_ads/my_ads_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MyAdsView extends StatefulWidget {
  @override
  _MyAdsViewState createState() => _MyAdsViewState();
}

class _MyAdsViewState extends State<MyAdsView> {
  late MyAdsViewModel _adsViewModel;

  @override
  void initState() {
    super.initState();
    _adsViewModel = locator<MyAdsViewModel>();
    _adsViewModel.fetchMyAds();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyAdsViewModel>.reactive(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My Advertisements'),
            ),
            body: Stack(
              children: <Widget>[
                (viewModel.getAdList.isEmpty && !viewModel.isBusy)
                    ? Center(child: _getProperEmptyState())
                    : GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 0.7,
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        children: List.generate(
                          viewModel.getAdList.length,
                          (index) {
                            var adItem = viewModel.getAdList[index];
                            return AdFunctions.getAdItemView(true,
                                index: index,
                                ad: adItem,
                                context: context,
                                onLikeClicked: () =>
                                    viewModel.onLikeAdClicked(index),
                                onAdClicked: () => _onAdClicked(adItem, index, context),
                                myUserId: viewModel.getMyUserId!);
                          },
                        ),
                      ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Visibility(
                    visible: viewModel.isBusy,
                    child: Container(
                      width: 45,
                      height: 45,
                      margin: EdgeInsets.only(top: 8),
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
                )
              ],
            ),
          );
        },
        viewModelBuilder: () => _adsViewModel);
  }

  _onAdClicked(Ads ad, int index, BuildContext context) async {
    //:TODO : Figure out how to receive arguments from closing screen
    /*Map<String, dynamic> openDetails = await context.router.push(AdDetailsViewRoute(adData: ad, adId: null, position: index));

        await ExtendedNavigator.ofRouter<Router>()
            .pushAdDetailsViewRoute(adData: ad, adId: null, position: index);

    if (openDetails.containsKey('position')) {
      var position = openDetails['position'] as int;
      var isLiked = openDetails['liked'] as bool;
      _adsViewModel.onAdListResumed(position, isLiked);
    } else if (openDetails.containsKey('delete') &&
        openDetails['delete'] == true) {
      _adsViewModel.fetchMyAds();
    }*/
  }

  Widget _getProperEmptyState() {
    EmptyStates emptyState = EmptyStates.NoAdsFound;
    return AdFunctions.getEmptyState(state: emptyState);
  }
}
