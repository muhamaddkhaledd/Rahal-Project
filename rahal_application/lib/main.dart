import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/onboarding.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/login and register homepage.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/network/local/cache_helper.dart';
import 'package:rahal_application/shared/network/remote/dio_helper.dart';
import 'package:sizer/sizer.dart';
import 'package:rahal_application/sqltest.dart';

import 'dashboard.dart';
import 'home pages/booked trip details.dart';
import 'home pages/edit account data screen.dart';
import 'home pages/register steps.dart';
import 'home pages/specialtrip.dart';
import 'home pages/test.dart';
import 'home pages/trips categories.dart';
import 'login.dart';


void main()async {
  //el code dah 3l4an feh async fl main 3l4an y4ta8al el app kowayes :
  WidgetsFlutterBinding.ensureInitialized();
  //end of the code
  await Firebase.initializeApp()
      .then((value) => print("connected hello" + value.options.asMap.toString()))
      .catchError((e) => print('error broo${e.toString()}'));
  await cachehelper.init();
  await diohelper.init();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    bool isonboarding = cachehelper.getshareddata(key: 'onboarding')??true;
    bool viewhomepage=false;
    bool isbirthdaymissed = constusers.birth==null?true:false;

    if(cachehelper.getshareddata(key: 'viewhomepage')==true||cachehelper.getshareddata(key: 'uid')!=null||cachehelper.getshareddata(key: 'uid')==''){
      viewhomepage = true;
    }
    Widget homescreen(){
      if(isonboarding==true)
        return onboardingscreen();
      else if(viewhomepage==true)
        return home();
      else
        return login_register_home();
    }

    //if(isonboarging==null)
      //isonboarging=true;
    //uid= cachehelper.getshareddata(key: 'uid');

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(color: Colors.black),),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.deepOrange,
              elevation: 20,
            ),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: defaultarabicfont,
          ),
          home:homescreen() ,// home(),//isonboarging ?onboardingscreen():login_register_home(),
        );
      },
    );
  }
}

