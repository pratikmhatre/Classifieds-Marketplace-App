import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/fcm_helper.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/data/network/response/token_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';

//:TODO : Avoid passing context in viewmodel, even for navigation

class SplashViewmodel extends ExtendedViewModel {
  var _dataManager = locator<DataManager>();

  fetchAccessToken(Function onUpdateMandatory, BuildContext context,
      {String? adId}) async {
    var fcmHelper = FcmHelper(context.router);
    await fcmHelper
        .init((token) => _dataManager.saveFirebaseToken(token ?? ''));

    var tokenResponse = await safeAwait<TokenResponse>(
        future: _dataManager.requestAccessToken(),
        mapping: (m) => TokenResponse.fromJson(m));
    print("Fetching masters here ${tokenResponse?.refreshToken}");
    if (tokenResponse != null) {
      _dataManager.setAccessToken(tokenResponse.token);
      _fetchMasters(onUpdateMandatory, context, adId: adId);
    }
  }

  _fetchMasters(Function onUpdateMandatory, BuildContext context,
      {String? adId}) async {
    var packageInfo = await PackageInfo.fromPlatform();
    var currentVersion = packageInfo.version;

    MasterResponse? mastersCall = await safeAwait(
        future: _dataManager.getMastersFromServer(),
        mapping: (map) => MasterResponse.fromJsonMap(map));

    if (mastersCall != null) {
      _dataManager.saveLatestVersion(mastersCall.meta.version.versionName);
      _dataManager.saveSafetyNote(mastersCall.meta.safetyNote);

      if (currentVersion != mastersCall.meta.version.versionName &&
          mastersCall.meta.version.isMandatory) {
        onUpdateMandatory.call();
        return;
      }

      var mapList = mastersCall.data
          .map<Map<String, dynamic>>((e) => e.toJson())
          .toList();

      _dataManager.deleteMaster().then(
            (value) => _dataManager.addMasters(mapList).then(
              (value) {
                var router = context.router;
                router.replace(HomeViewRoute());
              },
            ),
          );
    }
  }
}
