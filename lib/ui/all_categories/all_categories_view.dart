import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/ad_functions.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:digigad/ui/all_categories/all_categories_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AllCategoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    var allCategoriesViewModel = locator<AllCategoriesViewmodel>();
    return ViewModelBuilder<AllCategoriesViewmodel>.nonReactive(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppConstants.colorPrimary,
              title: Text(
                'Select Category',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,),
              ),
            ),
            body: Container(
              child: FutureBuilder<List<MasterData>>(
                  future: viewModel.fetchCategoriesFromDb(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData || snapshot.data!.isEmpty
                        ? Center(child: AdFunctions.getEmptyState())
                        : ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var master = snapshot.data![index];
                              return InkWell(
                                onTap: () {
                                  AutoRouter.of(buildContext).navigate(AdlistViewRoute(searchQuery: null, categoryId: master.id.toString(), adListType: AdListType.CategoryAds));
                                },
                                child: Container(
                                  height: 70,
                                  margin:
                                      EdgeInsets.only(top: index == 0 ? 8 : 0),
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Text(
                                                master.title,
                                                style: TextStyle(
                                                    color: AppConstants.colorText,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 16,
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
                                        visible:
                                            index != snapshot.data!.length - 1,
                                        child: Container(
                                          color: AppConstants.colorLightGrey,
                                          height: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  }),
            ),
          );
        },
        viewModelBuilder: () => allCategoriesViewModel);
  }
}
