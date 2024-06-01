import 'dart:math';

import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/locator.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_constants.dart';
import 'data/network/dio_transformer.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'data/network/response/master_response.dart';
import 'data/network/response/plain_response.dart';

enum DynamicLinkType { share_ad, share_store }

class AppFunctions {
  static void exitApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  static openMap(String coordinates) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$coordinates';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Fluttertoast.showToast(msg: 'Google maps not installed');
    }
  }

  static Widget getVegNonVegWidget(bool isVeg) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16,
            width: 16,
            child: Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isVeg ? Colors.green : Colors.amber[900]),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                    color: (isVeg ? Colors.green : Colors.amber[900])!,
                    width: 2)),
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            isVeg ? 'Pure Veg' : 'Veg-Non Veg',
            style: TextStyle(
              fontSize: 12,
              color: isVeg ? Colors.green : Colors.amber[900],
            ),
          ),
        ],
      );

  static double calculateDistance(String current, String coordinates) {
    var currentArray = current.split(',');
    var coordArray = coordinates.split(',');

    var lat1 = double.parse(currentArray[0]);
    var lon1 = double.parse(currentArray[1]);

    var lat2 = double.parse(coordArray[0]);
    var lon2 = double.parse(coordArray[1]);

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static String getTimeSpan(String dateString) {
    //2020-06-13T16:01:30.436022(+05:30)?

    String pointRemoved;
    if (dateString.contains('+')) {
      var plusRemoved = dateString.substring(0, dateString.indexOf('+'));
      pointRemoved = plusRemoved.substring(0, dateString.indexOf('.'));
    } else {
      pointRemoved = dateString.substring(0, dateString.indexOf('.'));
    }

    var tReplaced = pointRemoved.replaceFirst('T', ' ');

    var dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    var dateTime = dateFormat.parse(tReplaced);
    return timeago.format(dateTime);
  }

  static showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Center(
              child: CircularProgressIndicator(
                strokeWidth: 6,
              ),
            ));
  }

  static Widget getImageText(String image, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          image,
          height: 20,
          width: 20,
          color: AppConstants.colorText,
        ),
        SizedBox(
          width: AppConstants.horizontalMarginHalf,
        ),
        Text(
          text,
          style: TextStyle(
            color: AppConstants.colorText,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  static Widget getTextInputField(
      {required int maxLength,
      required String hintText,
      int maxLines = 1,
      required TextInputType inputType,
      TextCapitalization capitalization = TextCapitalization.none,
      Function(String s)? onChanged,
      String? errorText = '',
      TextEditingController? controller,
      bool isEnabled = true}) {
    return TextField(
      controller: controller,
      onChanged: (s) => onChanged?.call(s),
      maxLines: maxLines,
      enabled: isEnabled,
      maxLength: maxLength,
      style:
          TextStyle(color: AppConstants.colorText, fontSize: 16, height: 1.5),
      keyboardType: inputType,
      textCapitalization: capitalization,
      decoration: InputDecoration(
        errorText: errorText,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppConstants.colorDarkGrey)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppConstants.colorPrimary)),
        contentPadding: EdgeInsets.all(0),
        counterStyle: TextStyle(fontSize: 0),
        labelText: hintText,
        labelStyle: TextStyle(
          color: AppConstants.colorHint,
        ),
      ),
    );
  }

  static Widget getHeaderTextView(String title, {double fontSize = 24}) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.black, fontSize: fontSize, fontWeight: FontWeight.w700),
    );
  }

  static String getTextForCondition({int? condition = 1}) {
    return (condition == 1) ? 'Used' : 'New';
  }

  static Widget getBigButton(
      {required String title,
      required Function onClick,
      Color color = AppConstants.colorButton}) {
    return Container(
      height: 55,
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          onClick.call();
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: AppConstants.colorPrimary,
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(0, 5))
      ]),
    );
  }

  static getDio() {
    var dataManager = locator<DataManager>();
    var dio = Dio(BaseOptions(
      baseUrl: '${AppConstants.baseUrl}/api/',
      connectTimeout: 1000 * 4,
      receiveTimeout: 1000 * 4,
    ));

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions request, handler) {
      request.headers['Authorization'] =
          'Bearer ${dataManager.getAccessToken()}';

      print('Headers :: ' + request.headers.toString());
      print('Request :: ' + request.toString());
      print('Request post data:: ' + request.queryParameters.toString());

      return handler.next(request);
    }, onResponse: (response, handler) {
      print('response data ::: ' + response.data.toString());
      return handler.next(response);
    }, onError: (error, handler) {
      print('error : ${error.error.toString()}');

      print('error : ${error.message}');

      return handler.next(error);
    }));

    print('passing headers as :: ' + dio.options.headers.toString());

    return dio;
  }

  static Widget getDivider() {
    return SizedBox(
      width: 30,
    );
  }

  static Widget getStandardDivider({height = AppConstants.horizontalMargin}) {
    return SizedBox(
      height: height,
    );
  }

  static void showMasterSelectionBottomSheet(
      Future<Response<dynamic>> submitReasonFunction(
          MasterData data, int adId)?,
      {required BuildContext context,
      required String title,
      required double bottomsheetHeight,
      Future<List<MasterData>>? masterListFuture,
      int? adId,
      bool isReporting = false,
      onMasterSelected(MasterData data)?}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
              width: double.infinity,
              height: bottomsheetHeight,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: AppConstants.colorText,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: FutureBuilder<List<MasterData>>(
                        future: masterListFuture,
                        builder: (context, snapshot) {
                          return ListView.builder(
                              itemCount:
                                  snapshot.hasData ? snapshot.data!.length : 0,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var master = snapshot.data![index];
                                var masterTitle = master.title;

                                return InkWell(
                                  onTap: () {
                                    if (isReporting) {
                                      _onReasonSelected(context, master,
                                          submitReasonFunction!(master, adId!));
                                    } else {
                                      onMasterSelected!(master);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 60,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                masterTitle,
                                                style: TextStyle(
                                                    color:
                                                        AppConstants.colorText,
                                                    fontSize: 16),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 14,
                                                color: AppConstants.colorText,
                                              )
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: index !=
                                              snapshot.data!.length - 1,
                                          child: Container(
                                            color: AppConstants.colorLightGrey,
                                            height: 1,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                  ),
                  Visibility(
                    visible: isReporting,
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Thank you for making DigiGad better',
                          style: TextStyle(
                              color: AppConstants.colorPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  static _onReasonSelected(BuildContext context, MasterData masterData,
      Future<Response<dynamic>>? submitReasonFunction) async {
    showProgressDialog(context);

    if (submitReasonFunction != null) {
      var reportCall = await submitReasonFunction;
      Navigator.pop(context);
      if (reportCall.statusCode == 200 && reportCall.data != null) {
        var plainResponse = PlainResponse.fromJsonMap(reportCall.data);
        if (plainResponse.status == 200) {
          Fluttertoast.showToast(msg: 'Your request has been recorded');
        }
      } else {
        Fluttertoast.showToast(msg: AppConstants.somethingWentWrong);
      }
    }
  }

  static Future<String> generateDynamicLink(DynamicLinkType linkType,
      {required String adId,
      required String title,
      required String image,
      required String details}) async {
    var parameters = DynamicLinkParameters(
        uriPrefix: 'https://digigad.page.link',
        link: Uri.parse(
            'http://${AppConstants.baseUrl}/?action=$linkType&id=$adId'),
        androidParameters: AndroidParameters(packageName: 'cypher.digigad'),
        iosParameters: IosParameters(
            bundleId: 'io.flutter.flutter.app', appStoreId: '123456'),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: title,
          imageUrl: Uri.parse(image),
          description: details,
        ));
    var generate = await parameters.buildShortLink();
    var link = generate.shortUrl.toString();
    return link;
  }

  static createAndShareDynamicLink(
      BuildContext context, DynamicLinkType linkType,
      {uid, title, details, image}) {
    Navigator.pop(context);
    var shortLink = generateDynamicLink(linkType,
        adId: uid, title: title, details: title, image: image);

    shortLink.then((value) {
      Share.share(value);
    });
  }

  static bool isWithinWorkHours(String workHours) {
    var currentDate = DateTime.now();
    if (workHours.contains(',') && workHours.split(',').length > 1) {
      var array = workHours.split(',');
      var firstSlot = array[0].split('to');
      var secondSlot = array[1].split('to');

      var dateStart1 = DateFormat.jm().parse(firstSlot[0].trim());
      var dateEnd1 = DateFormat.jm().parse(firstSlot[1].trim());
      var dateStart2 = DateFormat.jm().parse(secondSlot[0].trim());
      var dateEnd2 = DateFormat.jm().parse(secondSlot[1].trim());
      var newDate = DateTime(dateStart1.year, dateStart1.month, dateStart1.day,
          currentDate.hour, currentDate.minute, currentDate.second, 0, 0);

      return newDate.isAfter(dateStart1) && newDate.isBefore(dateEnd1) ||
          newDate.isAfter(dateStart2) && newDate.isBefore(dateEnd2);
    } else {
     /* var slot = workHours.split('to');
      print('${slot[0]}');
      print('${slot[1]}');

      var dateStart = DateFormat.jm().parse(slot[0].trim());
      var dateEnd = DateFormat.jm().parse(slot[1].trim());

      var newDate = DateTime(dateStart.year, dateStart.month, dateStart.day,
          currentDate.hour, currentDate.minute, currentDate.second, 0, 0);*/

      return true;
    }
  }

  static Future<dynamic>? myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  static shareAppLink() {
    Share.share('https://play.google.com/store/apps/details?id=cypher.digigad');
  }

  static openPlayStore() async {
    await launch(
        'https://play.google.com/store/apps/details?id=cypher.digigad');
  }

  static getSearchWidget() => Expanded(
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('icons/ic_search.png'),
                color: Color(0xFFAAAAAA),
                height: 20,
                width: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              )
            ],
          ),
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Color(0xFFF1F4F8)),
        ),
      );
}
