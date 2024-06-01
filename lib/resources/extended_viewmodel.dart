import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

import 'locator.dart';

abstract class ExtendedViewModel extends BaseViewModel {
  var dataManager = locator<DataManager>();

  showToast(message, {isLong = false}) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT);
  }

  onSomethingWentWrong() {
    showToast(AppConstants.somethingWentWrong);
  }

  Future<T?> safeAwait<T>({required Future<Response> future,required T mapping(m)}) async {
    try {
      var call = await future;
      return mapping(call.data);
    } on DioError catch (e) {
      Map<String, dynamic> payLoad;
      if (e.response != null) {
        payLoad = _getAnalyticsPayload(e.response!.headers,
            response: e.response!.data);
      } else {
/*        payLoad =
            _getAnalyticsPayload('', e.request, response: e.response.data);*/
      }
      // FirebaseAnalytics().logEvent(name: e.toString(), parameters: payLoad);
      print('Network Call Dio Error :: ' + e.toString());
      onSomethingWentWrong();
      return null;
    } catch (e) {
      print('Network Call Other Error :: ' + e.toString());

      FirebaseAnalytics().logEvent(name: 'Connectivity Failure');
      showToast('Please check your network connection and try again');
      return null;
    }
  }

  Map<String, dynamic> _getAnalyticsPayload(headers, {response}) {
    var map = {
      'headers': headers,
    };
    if (response != null) {
      map['response'] = response;
    }
    return map;
  }
}
