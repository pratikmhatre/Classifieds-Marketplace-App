import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/locator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

import 'item_category_viewmodel.dart';

class ItemCategoryView extends StatefulWidget {
  @override
  _ItemCategoryViewState createState() => _ItemCategoryViewState();
}

class _ItemCategoryViewState extends State<ItemCategoryView> {
  late ItemCatgoryViewModel _itemCatgoryViewModel;
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _itemCatgoryViewModel = locator<ItemCatgoryViewModel>();
    _itemCatgoryViewModel.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ItemCatgoryViewModel>.reactive(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Select Item Category'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddCategoryDialog(context),
              child: Icon(
                Icons.add,
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Icon(
                          Icons.search,
                          color: AppConstants.colorDarkGrey,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            maxLines: 1,
                            focusNode: _searchFocus,
                            onSubmitted: (s) => viewModel.searchCategory(s),
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search Category',
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
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: AppConstants.colorText,
                          ),
                          onPressed: () {
                            _searchController.text = '';
                            viewModel.resetSearch();
                          },
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: AppConstants.colorLightGrey,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  AppFunctions.getHeaderTextView(
                      'Select from list or add new category',
                      fontSize: 16),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: viewModel.getItemCategories.length,
                        itemBuilder: (context, index) {
                          var category = viewModel.getItemCategories[index];
                          return InkWell(
                            onTap: () => Navigator.pop(context, category),
                            child: Container(
                              height: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          category.name??'',
                                          style: TextStyle(
                                              color: AppConstants.colorText,
                                              fontSize: 15),
                                        )),
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
                                  Container(
                                    height: 1,
                                    color: AppConstants.colorLightGrey,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => _itemCatgoryViewModel);
  }

  _showAddCategoryDialog(BuildContext context) {
    var nameController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                padding: MediaQuery.of(context).viewInsets,
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add New Category',
                      style: TextStyle(
                          color: AppConstants.colorText, fontSize: 18),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    AppFunctions.getTextInputField(
                      maxLength: 15,
                      hintText: 'Category Name',
                      errorText: '',
                      controller: nameController,
                      capitalization: TextCapitalization.words,inputType: TextInputType.name
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: AppConstants.colorPrimary,
                                      fontSize: 14),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppConstants.colorPrimary,
                                      width: 1)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              var name = nameController.text.trim();
                              if (name.length < 4) {
                                _showToast('Minimum 4 charecters required');
                                return;
                              }
                              _itemCatgoryViewModel.onCategoryAdded(name);

                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppConstants.colorPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              )
            ],
          );
        });
  }

  void _showToast(String s) {
    Fluttertoast.showToast(msg: s);
  }
}
