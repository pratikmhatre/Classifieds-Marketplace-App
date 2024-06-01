import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  final bool isFromDashboard;
  final _searchNode = FocusNode();
  final _searchController = TextEditingController();
  final String? searchQuery;

  SearchView({this.isFromDashboard = true, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    _searchNode.requestFocus();
    if (searchQuery != null && searchQuery!.trim().isNotEmpty) {
      _searchController.text = searchQuery!;
    }
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppConstants.horizontalMargin),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: AppConstants.horizontalMargin),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: AppConstants.colorText,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 55,
                    margin: EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalMargin),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 5)
                      ],
                      border: Border.all(
                        color: Color(0xAAEEEEEE),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'icons/ic_search.png',
                            width: 24,
                            height: 24,
                            color: AppConstants.colorText,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: TextField(
                                focusNode: _searchNode,
                                textInputAction: TextInputAction.search,
                                maxLines: 1,
                                onSubmitted: (query) {
                                  if (isFromDashboard) {
                                    context.router.navigate(AdlistViewRoute(
                                        categoryId: null,
                                        searchQuery: query,
                                        adListType: AdListType.SearchAds));
                                  } else {
                                    //:TODO : Send argument back
                                    context.router.pop();
                                    /*ExtendedNavigator.ofRouter<Router>()
                                        .pop(query);*/
                                  }
                                },
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: AppConstants.defaultSearchLabel,
                                  hintStyle:
                                      TextStyle(color: AppConstants.colorHint),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: AppConstants.colorText,
                            ),
                            onPressed: () => _searchController.text = '',
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Image.asset('images/img_empty_search.png'),
            ),
          )
        ],
      )),
    );
  }
}
