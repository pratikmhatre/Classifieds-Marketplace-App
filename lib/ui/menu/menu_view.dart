import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:digigad/ui/menu/menu_viewmodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

class MenuView extends StatefulWidget {
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>
    with AutomaticKeepAliveClientMixin {
  late MenuViewModel _menuViewModel;

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void initState() {
    super.initState();
    _menuViewModel = locator<MenuViewModel>();
    _menuViewModel.fetchAppVersion();
  }

  var _titles = [
    'Edit Profile',
    'My Posts',
    'Post Feedback',
    'Share App',
    'App Version',
    'Sign Out'
  ];

  var _icons = [
    'icons/ic_avatar.png',
    'icons/ic_posts.png',
    'icons/ic_feedback.png',
    'icons/ic_share.png',
    'icons/ic_update.png',
    'icons/ic_logout.png'
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<MenuViewModel>.reactive(
        builder: (context, viewModel, child) {
          var size = MediaQuery.of(context).size;
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: size.height,
                    width: size.width,
                    child: Container(
                      color: Color(0xBFFFFFFF),
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/img_map.jpg'),
                            fit: BoxFit.cover)),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 150,
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Settings',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'View and edit your settings',
                                      style: TextStyle(
                                          color: Colors.blueGrey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                            itemCount: _titles.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var itemName = _titles[index];
                              if (itemName.toLowerCase().contains('version') &&
                                  viewModel.getIsUpdateAvailable) {
                                itemName = 'Update Available';
                              }

                              return Card(
                                shadowColor: AppConstants.colorPrimaryGrey,
                                elevation: 1.5,
                                margin: EdgeInsets.only(
                                    top: (index == 3) || (index == 5)
                                        ? 12
                                        : 0),
                                child: InkWell(
                                  onTap: () => _onItemClicked(context, index),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24),
                                    height: 80,
                                    margin: EdgeInsets.only(
                                        top: (index == 3) ? 12 : 0),
                                    width: double.infinity,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                              height: 35,
                                              width: 35,
                                              padding: EdgeInsets.all(8),
                                              child: Image.asset(
                                                _icons[index],
                                                color:
                                                    AppConstants.colorPrimary,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppConstants
                                                    .colorPrimaryGrey,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 18,
                                            ),
                                            Expanded(
                                                child: Text(
                                              itemName,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            )),
                                            _titles[index]
                                                    .toLowerCase()
                                                    .contains('version')
                                                ? (viewModel
                                                        .getIsUpdateAvailable
                                                    ? Icon(
                                                        Icons.system_update,
                                                        color: Colors.redAccent,
                                                      )
                                                    : Text(
                                                        'v${viewModel.getAppVersion}',
                                                        style: TextStyle(
                                                            color: AppConstants
                                                                .colorButton,
                                                            fontSize: 15),
                                                      ))
                                                : Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 20,
                                                    color: AppConstants
                                                        .colorPrimary,
                                                  )
                                          ],
                                        )),
                                        Divider(
                                          height: 1,
                                          color: (index == 2) ||
                                                  (index == 4) ||
                                                  (index == _titles.length - 1)
                                              ? Colors.transparent
                                              : AppConstants.colorDarkGrey,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => _menuViewModel);
  }

  _onItemClicked(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.router.push(EditProfileViewRoute(isFromMenu: true));
        break;
      case 1:
        context.router.push(MyAdsViewRoute());
        break;
      case 2:
        _showFeedbackForm(context);
        break;
      case 3:
        AppFunctions.shareAppLink();

        break;
      case 4:
        if (_menuViewModel.getIsUpdateAvailable) {
          AppFunctions.openPlayStore();
        }
        break;
      case 5:
        _showSignOutDialog(context);
        break;
    }
  }

  void _showSignOutDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text('Sign Out'),
      content: Text('Are you sure you want to sign out of DigiGad ?'),
      actions: [
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _menuViewModel.onSignOutClicked();
              context.router.navigate(LoginViewRoute());
            },
            child: Text('Confirm Signout')),
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  void _showFeedbackForm(BuildContext context) {
    var height = MediaQuery.of(context).size.height * (1 / 2);
    var textController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: height,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feedback Form',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 8, bottom: 8, right: 8),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Your feedback helps us grow',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w100, fontSize: 16),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: AppConstants.colorLightGrey,
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Text(
                    'Thank you for making DigiGad better',
                    style: TextStyle(
                        color: AppConstants.colorPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                AppFunctions.getBigButton(
                    title: 'Submit Feedback',
                    onClick: () {
                      if (textController.text.isEmpty) {
                        Fluttertoast.showToast(msg: 'Feedback empty');
                        return;
                      }
                      _menuViewModel.submitFeedback(
                          textController.text, () => Navigator.pop(context));
                    })
              ],
            ),
          );
        });
  }
}
