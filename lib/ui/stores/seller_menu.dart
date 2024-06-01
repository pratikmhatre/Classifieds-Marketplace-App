import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:flutter/material.dart';

class SellerMenu extends StatelessWidget {
  final List menu = [
    'Seller Registration',
    'Seller Dashboard',
    'Item Registration',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, position) {
            return InkWell(
              onTap: () => _handleClick(position,context),
              child: Container(
                height: 60,
                child: Center(
                    child: Text(
                  menu[position],
                  style: TextStyle(fontSize: 20),
                )),
              ),
            );
          },
          itemCount: menu.length,
        ),
      ),
    );
  }

  _handleClick(int position, BuildContext buildContext) {
    switch (position) {
      case 0:
        buildContext.router.push(SellerRegistrationViewRoute());
        break;

      case 1:
        // buildContext.router.push(SellerDashboardViewRoute(storeList:storelis ));
        // ExtendedNavigator.ofRouter<RoutesHolder>().pushSellerDashboard();
        break;

      case 2:
        buildContext.router.push(ItemRegistrationViewRoute());
        break;
    }
  }
}
