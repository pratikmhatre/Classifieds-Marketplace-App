import 'package:flutter/cupertino.dart';

enum CallStatus { Loading, Idle, Completed }
enum AdListType { CategoryAds, LikedAds, SearchAds, MyAds }
enum EmptyStates {
  NoAdsFound,
  SomethingWentWrong,
  NoSearchResults,
  NoConnection
}

class AppConstants {
  static const String baseUrl = 'http://192.168.0.180:8000';
  // static const String baseUrl = 'https://webhook.site/7d46fc25-3819-4b6c-a42b-c3fd29eb2da4';
  // static const String baseUrl = 'http://192.168.0.180:8000';

  static const String defaultSearchLabel = 'Search in DigiGad';
  static const int serverError = 500;
  static const Color colorPrimary = Color(0xFFE10A39);
  static const Color colorPrimaryGrey = Color(0xFFE8EDFF);
  static const Color colorAccent = Color.fromRGBO(0, 144, 121, 1);
  static const Color colorBackground = Color(0xFFf6f7ff);
  static const Color colorIcons = Color(0xFF222455);
  static const Color colorButton = Color(0xFF010b3c);
  static const Color colorHint = Color(0xFFABB4BD);
  static const Color colorText = Color(0xFF3E3F68);
  static const Color colorDarkGrey = Color(0xFFAAAAAA);
  static const Color colorLightGrey = Color(0xFFEEEEEE);
  static const double horizontalMargin = 16.0;
  static const double horizontalMarginHalf = 8.0;
  static const String somethingWentWrong =
      "Something went wrong, please try again..";

  static const int masterTypeCategory = 1;
  static const int masterTypeSubCategory = 2;
  static const int masterTypeTaluka = 3;
  static const int masterTypeReportReasons = 4;
  static const int masterTypeStoreCategory = 6;

  static const int ACTION_VIEW = 1;
  static const int ACTION_SHARE = 2;
  static const int ACTION_LIKE = 3;
  static const int ACTION_REPORT = 4;

  static const String clientId = 'cH6Lahuva7BrRSg880X9IVJZlVSbSBIWT1iuoCMr';
  static const String clientSecret = 'nYDArILxnURNAZsaJKOlS0Gk9wxHOUTiTIVC56WpeV8oOpCVUQjVrf7JFr7YTNNcbDipRr1sj8CSMQSYt572HUVgPXXxrao0RmYvy6b0rxHkWYrDAQYGW6ySNdBLW9Sq';
  static const String scopes = 'read write';
  static const String user = 'cypher';
  static const String password = 'myangel0';
  static const String grantType = 'password';


}
