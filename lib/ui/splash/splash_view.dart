import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/ui/splash/splash_viewmodel.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SplashView extends StatelessWidget {
  final SplashViewmodel _splashViewModel = locator<SplashViewmodel>();

  @override
  Widget build(BuildContext context) {
    _splashViewModel.fetchAccessToken(
        () => _showForceUpdateDialog(context), context);
    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/iv_logo.png',
          height: 100,
          width: 100,
        ),
      ),
    );
  }

  initDynamicLink(BuildContext context) async {
    /*
    FirebaseDynamicLinks.instance
        .getInitialLink()
        .then((PendingDynamicLinkData linkData) {
      handleDynamicLink(linkData, context);

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData linkData) async {
        handleDynamicLink(linkData, context);
      }, onError: (OnLinkErrorException e) async {
        FirebaseAnalytics().logEvent(name: 'Dynamic Link Error');
      });
    });
  */
  }

  handleDynamicLink(PendingDynamicLinkData linkData, BuildContext context) {
    if (linkData != null) {
      FirebaseAnalytics().logEvent(name: 'Dynamic Link Received');

      var deepLink = linkData.link;
      var querySet = deepLink.queryParameters;
      if (querySet['action'] == 'share_ad') {
        String? adId = querySet['id'];
        _splashViewModel.fetchAccessToken(
            () => _showForceUpdateDialog(context), context,
            adId: adId);
      } else {
        Fluttertoast.showToast(msg: AppConstants.somethingWentWrong);
      }
    } else {
      _splashViewModel.fetchAccessToken(
          () => _showForceUpdateDialog(context), context);
    }
  }

  _showForceUpdateDialog(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Text('Update Required'),
            content: Text(
                'An important update has been released by the developer, please click UPGRADE NOW button below to continue'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    AppFunctions.openPlayStore();
                  },
                  child: Text('Upgrade Now'))
            ],
          ),
        );
      });
}
