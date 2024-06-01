import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:digigad/resources/locator.dart';

void main() async{
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  var _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    // initFirebase();
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        cursorColor: AppConstants.colorPrimary,
        fontFamily: 'Poppins',
        accentColor: AppConstants.colorPrimary,
        hintColor: AppConstants.colorHint,
      ),
    );
  }
}

