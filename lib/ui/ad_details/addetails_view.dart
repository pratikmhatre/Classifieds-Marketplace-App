import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/data/network/response/ads.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'addetails_viewmodel.dart';

class AdDetailsView extends StatefulWidget {
  final Ads? adData;
  final String? adId;
  final int? position;

  AdDetailsView(this.adData, this.adId, this.position);

  @override
  _AdDetailsViewState createState() =>
      _AdDetailsViewState(adId: adId, adData: adData, position: position);
}

class _AdDetailsViewState extends State<AdDetailsView> {
  final Ads? adData;
  final String? adId;
  final int? position;
  late AdDetailsViewModel _adDetailsViewModel;

  _AdDetailsViewState({this.adData, required this.adId, this.position});

  @override
  void initState() {
    super.initState();
    _adDetailsViewModel = locator<AdDetailsViewModel>();
    _adDetailsViewModel.set(adId: adId, data: adData);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdDetailsViewModel>.reactive(
        builder: (context, viewModel, child) {
          var finalAdData = viewModel.getAdData;
          int responses = 0;
          if (viewModel.isMyPostedAd &&
              viewModel.responseList != null &&
              viewModel.responseList!.isNotEmpty) {
            responses = viewModel.responseList!.length;
          }
          return WillPopScope(
            onWillPop: () async {
              if (position != null) {
                Navigator.pop(context,
                    {'position': position, 'liked': finalAdData?.isLiked});
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              floatingActionButton: Visibility(
                visible: viewModel.isMyPostedAd && responses != 0,
                child: FloatingActionButton(
                  onPressed: () => _showResponses(context, finalAdData),
                  backgroundColor: Colors.white,
                  child: Container(
                      width: 40,
                      height: 40,
                      child: Stack(
                        children: <Widget>[
                          Center(
                              child: Icon(
                            Icons.insert_comment,
                            size: 30,
                            color: Colors.grey,
                          )),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  responses.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              bottomNavigationBar: Container(
                height: 70,
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalMargin,
                ),
                child: (finalAdData == null)
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  viewModel.onLikeAdClicked();
                                },
                                child: Image.asset(
                                  finalAdData.isLiked
                                      ? 'icons/ic_heart_solid.png'
                                      : 'icons/ic_heart.png',
                                  color: viewModel.isLiked
                                      ? Colors.red
                                      : AppConstants.colorText,
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                '${finalAdData.likes}',
                                style: TextStyle(
                                    color: AppConstants.colorText,
                                    fontSize: 22),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            child: RaisedButton(
                              splashColor: viewModel.isMyPostedAd
                                  ? AppConstants.colorPrimaryGrey
                                  : AppConstants.colorPrimary,
                              hoverColor: Colors.red,
                              onPressed: () => viewModel.isMyPostedAd
                                  ? _onDeleteAdClicked(context)
                                  : _showOfferDialog(finalAdData, context),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: <Widget>[
                                  Visibility(
                                    visible: viewModel.isMyPostedAd,
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Visibility(
                                      visible: viewModel.isMyPostedAd,
                                      child: SizedBox(
                                        width: 8,
                                      )),
                                  Text(
                                    viewModel.isMyPostedAd
                                        ? 'Delete Ad'
                                        : 'Make Offer',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                              color: viewModel.isMyPostedAd
                                  ? Colors.red
                                  : AppConstants.colorButton,
                            ),
                          )
                        ],
                      ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xAAEEEEEE), width: 1.0),
                  ),
                ),
              ),
              body: SafeArea(
                child: (finalAdData == null)
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => AutoRouter.of(context).push(
                                      ViewImagesViewRoute(
                                          imageList:
                                              viewModel.ad?.images ?? [])),
                                  child: CachedNetworkImage(
                                    imageUrl: _getAdImage(finalAdData),
                                    width: double.infinity,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 0, 0, 0.5),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.share,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              viewModel.onShareAdClicked();
                                            }),
                                        Visibility(
                                          visible: !viewModel.isMyPostedAd,
                                          child: Container(
                                            width: 1,
                                            height: 20,
                                            color: AppConstants.colorLightGrey,
                                          ),
                                        ),
                                        Visibility(
                                          visible: !viewModel.isMyPostedAd,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.report_problem,
                                                color: Colors.yellow,
                                                size: 18,
                                              ),
                                              onPressed: () =>
                                                  _onReportAdClicked(
                                                      context, viewModel)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: AppConstants.horizontalMargin,
                                  right: AppConstants.horizontalMargin,
                                  top: AppConstants.horizontalMargin),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    finalAdData.title ?? '',
                                    style: TextStyle(
                                        color: AppConstants.colorText,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Rs.${finalAdData.sellingPrice}/-',
                                    style: TextStyle(
                                        color: AppConstants.colorText,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  AppFunctions.getStandardDivider(),
                                  AppFunctions.getImageText(
                                    'icons/ic_location_pin.png',
                                    finalAdData.locality ?? '',
                                  ),
                                  AppFunctions.getStandardDivider(),
                                  _getIconText(
                                    Icons.access_time,
                                    '${AppFunctions.getTimeSpan(finalAdData.dateCreated ?? '')} by ${_getUserName(finalAdData)}',
                                  ),
                                  AppFunctions.getStandardDivider(),
                                  AppFunctions.getImageText(
                                    'icons/ic_heart.png',
                                    '${finalAdData.likes} ${(finalAdData.likes == 1) ? 'like' : 'likes'}',
                                  ),
                                  AppFunctions.getStandardDivider(),
                                  AppFunctions.getImageText(
                                    'icons/ic_square_check.png',
                                    AppFunctions.getTextForCondition(
                                        condition: finalAdData.condition),
                                  ),
                                  AppFunctions.getStandardDivider(),
                                  _getIconText(
                                    Icons.format_indent_increase,
                                    finalAdData.category?.title ?? '',
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    'Details',
                                    style: TextStyle(
                                        color: AppConstants.colorText,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: AppConstants.horizontalMarginHalf,
                                  ),
                                  Text(
                                    finalAdData.details??'',
                                    style: TextStyle(
                                        color: AppConstants.colorText,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    'Safety Tips',
                                    style: TextStyle(
                                        color: AppConstants.colorText,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: AppConstants.horizontalMarginHalf,
                                  ),
                                  Text(
                                    viewModel.getSafetyNote ?? '',
                                    style: TextStyle(
                                        color: AppConstants.colorText,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    'About Seller',
                                    style: TextStyle(
                                        color: AppConstants.colorText,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      (finalAdData.userId.avatar == null)
                                          ? Icon(
                                              Icons.account_circle,
                                              size: 80,
                                              color: AppConstants.colorDarkGrey,
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                finalAdData.userId.avatar??'',
                                              ),
                                              radius: 30,
                                            ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            finalAdData
                                                .userId.userInfo.fullName??'',
                                            style: TextStyle(
                                                color: AppConstants.colorText,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            finalAdData.userId.userInfo.email??'',
                                            style: TextStyle(
                                                color: AppConstants.colorText,
                                                fontSize: 14),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
        viewModelBuilder: () => _adDetailsViewModel);
  }

  _getUserName(Ads ad) {
    String? userName = ad.userId.userInfo.fullName;
    if (userName != null && userName.split(' ').length > 1) {
      userName = userName.split(' ')[0];
    }
    return userName;
  }

  _getAdImage(Ads? ad) {
    String imgUrl = '';
    if (ad?.images != null && ad!.images!.isNotEmpty) {
      imgUrl = ad.images![0].imgKey;
    }
    return imgUrl;
  }

  Widget _getIconText(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          color: AppConstants.colorText,
          size: 22,
        ),
        SizedBox(
          width: AppConstants.horizontalMarginHalf,
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppConstants.colorText, fontSize: 14),
          ),
        )
      ],
    );
  }

  _onReportAdClicked(BuildContext context, AdDetailsViewModel viewModel) {
    var height = MediaQuery.of(context).size.height * 3 / 4;
    AppFunctions.showMasterSelectionBottomSheet(
        viewModel.onReportReasonSelected,
        context: context,
        title: 'Select Report Reason',
        bottomsheetHeight: height,
        masterListFuture: viewModel.getReportReasons(),
        adId: viewModel.getAdData?.id,
        isReporting: true,
        onMasterSelected: null);
  }

  _showOfferDialog(Ads adData, BuildContext context) {
    var textController = TextEditingController();
    textController.text = adData.sellingPrice??'0';
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Wrap(
            children: <Widget>[
              Container(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: _getAdImage(adData),
                            height: 25,
                            fit: BoxFit.fill,
                            width: 25,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Rs.${adData.sellingPrice}/-')
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Your Offer :',
                      style: TextStyle(
                          color: AppConstants.colorDarkGrey, fontSize: 14),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Rs.',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 90,
                          child: TextField(
                            controller: textController,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.transparent,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent))),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.black,
                      width: 130,
                      height: 1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: RaisedButton(
                        color: AppConstants.colorButton,
                        onPressed: () {
                          if (textController.text == null ||
                              textController.text.trim().isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'Please provide valid offer price');
                            return;
                          }
                          if (double.parse(textController.text) >
                              double.parse(adData.sellingPrice??'0')) {
                            Fluttertoast.showToast(
                                msg:
                                    'Offer price cannot be greater than actual selling price');
                            return;
                          }
                          _onSubmitOfferClicked(textController.text, context);
                        },
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              'Make an offer',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  _onDeleteAdClicked(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text('Confirm Delete'),
      content: Text(
          'Are you sure you want to delete this advertisement parmenantly ?'),
      actions: [
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text('Delete'),
          onPressed: () {
            Navigator.pop(context);
            _adDetailsViewModel.onDeleteAdConfirmed(
                () => Navigator.pop(context, {'delete': true}));
          },
        )
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  _showResponses(BuildContext context, Ads? adData) {
    var bottomsheetHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SafeArea(
            child: Container(
              height: bottomsheetHeight,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.keyboard_backspace),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        Text(
                          'Offers',
                          style: TextStyle(
                              color: AppConstants.colorText,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                      padding: EdgeInsets.all(16),
                      color: AppConstants.colorPrimaryGrey,
                      child: Row(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: _getAdImage(adData),
                            height: 50,
                            fit: BoxFit.fill,
                            width: 50,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                adData?.title ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Rs.${adData?.sellingPrice}/-',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var item = _adDetailsViewModel.responseList?[index];

                        return Column(
                          children: <Widget>[
                            Container(
                              height: 100,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    item?.fromUser.avatar != null &&
                                            item!.fromUser.avatar
                                                .trim()
                                                .isNotEmpty
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                item.fromUser.avatar),
                                            radius: 20,
                                          )
                                        : Icon(
                                            Icons.account_circle,
                                            size: 50,
                                            color: AppConstants.colorLightGrey,
                                          ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            item!.fromUser.userInfo.fullName??'',
                                            style: TextStyle(
                                                color: AppConstants.colorText,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            'Rs.${item.offer}/-',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            AppFunctions.getTimeSpan(
                                                item.dateCreated),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: AppConstants.colorPrimary,
                                      onTap: () => _onCallConfirmed(
                                          item.fromUser.userInfo.fullName??'',
                                          item.fromUser.phone,
                                          context),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        color: Colors.white,
                                        child: Icon(
                                          Icons.call,
                                          color: AppConstants.colorPrimary,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            )
                          ],
                        );
                      },
                      itemCount: _adDetailsViewModel.responseList?.length ?? 0,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _onCallConfirmed(String name, String number, BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text('Confirm'),
      content: Text('You are about to call $name, do you want to proceed ?'),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _adDetailsViewModel.callUser(number);
            },
            child: Text('Make Call')),
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  _onSubmitOfferClicked(String text, BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text('Confirm Offer'),
      content: Text('Are you sure you want to submit an offer of Rs.$text/- ?'),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
        FlatButton(
            onPressed: () {
              _adDetailsViewModel.submitOffer(text);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Submit')),
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}
