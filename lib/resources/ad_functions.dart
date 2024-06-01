import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'app_constants.dart';
import 'app_functions.dart';
import 'data/network/response/ads.dart';

class AdFunctions {
  static _showAdOptionsDialog(BuildContext context, Function? onReportClicked,
      Function onShareClicked, bool isMyPostedAd) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => onShareClicked(),
                      child: Text(
                        'Share with friends',
                        style: TextStyle(
                            color: AppConstants.colorText, fontSize: 16),
                      ),
                    ),
                    Visibility(
                      visible: !isMyPostedAd,
                      child: SizedBox(
                        height: 16,
                      ),
                    ),
                    Visibility(
                      visible: !isMyPostedAd,
                      child: InkWell(
                        onTap: () => onReportClicked?.call(),
                        child: Text(
                          'Report this listing',
                          style: TextStyle(
                              color: AppConstants.colorText, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Widget getAdItemView(bool isMyPostedAds,
      {required int index,
      required BuildContext context,
      required Ads ad,
      Function? onReportClicked,
      dynamic onLikeClicked,
      required Function onAdClicked,
      required String myUserId}) {
    List<Color> _colors = [
      Color.fromRGBO(0, 0, 0, 0.5),
      Color.fromRGBO(0, 0, 0, 0.2),
      Color.fromRGBO(0, 0, 0, 0.0)
    ];
    List<double> _stops = [0.3, 0.8, 1];

    double widthPerItem = (MediaQuery.of(context).size.width -
            (AppConstants.horizontalMargin * 3)) /
        2;

    var imgUrl = '';
    if (ad.images != null && ad.images!.isNotEmpty) {
      imgUrl = ad.images![0].imgKey;
    }

    return InkWell(
      splashColor: AppConstants.colorPrimaryGrey,
      onTap: () => onAdClicked.call(),
      child: Container(
        margin: EdgeInsets.only(
            top: (index == 0 || index == 1) ? 16 : 4,
            left: (index % 2 == 0)
                ? AppConstants.horizontalMargin
                : AppConstants.horizontalMarginHalf,
            right: (index % 2 == 0)
                ? AppConstants.horizontalMarginHalf
                : AppConstants.horizontalMargin,
            bottom: AppConstants.horizontalMarginHalf),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: imgUrl,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: widthPerItem,
                      decoration: BoxDecoration(
                          color: Color(0xAAEEEEEE),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(6)),
                    );
                  },
                ),
                Container(
                  width: widthPerItem,
                  height: 40,
                  padding: EdgeInsets.only(
                    left: 6,
                    right: 6,
                    top: 6,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppFunctions.getTimeSpan(ad.dateCreated ?? ''),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      InkWell(
                        onTap: () {
                          _showAdOptionsDialog(
                              context,
                              onReportClicked,
                              () => _onShareAdClicked(ad, context),
                              ad.userId.userId.toString() == myUserId);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                        colors: _colors,
                        stops: _stops,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    ad.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.colorText,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                !isMyPostedAds
                    ? GestureDetector(
                        onTap: onLikeClicked,
                        child: Image.asset(
                          ad.isLiked
                              ? 'icons/ic_heart_solid.png'
                              : 'icons/ic_heart.png',
                          height: 18,
                          width: 18,
                          color:
                              ad.isLiked ? Colors.red : AppConstants.colorText,
                        ),
                      )
                    : Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.message,
                              color: Colors.red[600],
                              size: 18,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              ad.responseCount.toString(),
                              style: TextStyle(
                                  color: Colors.red[800], fontSize: 14),
                            )
                          ],
                        ),
                      )
              ],
            ),
            SizedBox(
              height: 4,
            ),
            RichText(
                text: TextSpan(
                    text: 'Rs.${ad.sellingPrice}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConstants.colorText,
                      fontWeight: FontWeight.w900,
                    ),
                    children: [
                  TextSpan(
                      text:
                          '  ${AppFunctions.getTextForCondition(condition: ad.condition)}',
                      style: TextStyle(
                        color: AppConstants.colorText,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      )),
                ])),
            SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                (ad.userId.avatar == null)
                    ? Icon(
                        Icons.account_circle,
                        size: 18,
                        color: AppConstants.colorDarkGrey,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(
                          ad.userId.avatar ?? '',
                        ),
                        radius: 9,
                        backgroundColor: Colors.transparent,
                      ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  ad.userId.userInfo.fullName ?? '',
                  style: TextStyle(
                    color: AppConstants.colorText,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  static getEmptyState({EmptyStates state = EmptyStates.NoAdsFound}) {
    String assetSource, message;
    switch (state) {
      case EmptyStates.SomethingWentWrong:
        assetSource = 'images/img_empty_wrong.png';
        message = 'Something Went Wrong';
        break;
      case EmptyStates.NoConnection:
        assetSource = 'images/img_empty_no_connection.png';
        message = 'Unable To Reach Servers';
        break;
      case EmptyStates.NoSearchResults:
        assetSource = 'images/img_empty_search.png';
        message = 'No Results Found';
        break;
      default:
        assetSource = 'images/img_empty_list.png';
        message = 'No Ads Here For Now';
        break;
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          assetSource,
          height: 250,
          width: 250,
        ),
        Text(
          message,
          style: TextStyle(
            color: AppConstants.colorDarkGrey,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  static _onShareAdClicked(Ads ad, BuildContext context) {
    Navigator.pop(context);
    if (ad.images != null) {
      AppFunctions.createAndShareDynamicLink(context, DynamicLinkType.share_ad,
          uid: ad.id.toString(),
          image: ad.images![0].imgKey,
          details: ad.details,
          title: ad.title);
    }
  }

}
