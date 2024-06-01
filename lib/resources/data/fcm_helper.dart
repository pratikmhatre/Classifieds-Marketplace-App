import 'package:auto_route/auto_route.dart';
import 'package:digigad/ui/ad_details/addetails_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/src/widgets/router.dart';

class FcmHelper {
  var fcm = FirebaseMessaging.instance;
  StackRouter _router;

  FcmHelper(this._router);

  init(Function(String? token) saveToken) async {
    var token = await fcm.getToken();
    saveToken(token);

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      var map = remoteMessage.data;
    });
/*    fcm.configure(onMessage: (Map<String, dynamic> map) async {
      print('onMessage :: ${map.toString()}');
    }, onLaunch: (Map<String, dynamic> map) async {
      print('onLaunch:: ${map.toString()}');
      _handlePayload(map);
    }, onResume: (Map<String, dynamic> map) async {
      print('onResume:: ${map.toString()}');
      _handlePayload(map);
    });*/
  }

  _proceedToAdDetails(adId) {
    // _router.push(AdDetailsViewRoute(adData: null, adId: adId, position: null));
  }

  void _handlePayload(Map<String, dynamic> map) {
    if (map.containsKey('data') &&
        map['data'] != null &&
        (map['data'] as Map).containsKey('ad')) {
      var adId = (map['data'] as Map)['ad'];
      _proceedToAdDetails(adId);
    }
  }
}
