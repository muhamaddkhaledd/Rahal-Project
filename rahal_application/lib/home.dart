import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rahal_application/home%20pages/alltrips.dart';
import 'package:rahal_application/home%20pages/choose%20trip.dart';
import 'package:rahal_application/home%20pages/my%20account.dart';
import 'package:rahal_application/home%20pages/my%20trips.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/models/usersdata_model.dart';
import 'package:rahal_application/shared/styles/colors.dart';

import 'home pages/homepage.dart';

class home extends StatefulWidget {
  @override
  final int initialIndex;
  State<home> createState() => _homeState(index: initialIndex);
  usersdatafirebase users = usersdatafirebase();
  home({this.initialIndex = 0});
}

class _homeState extends State<home> {
 int index;
 _homeState({this.index = 0});
 List<Widget>screens=
 [
   homepage(),
   maintrip(),
   //choosetrip(),
   mytrips(),
   myaccount(),
 ];
@override

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(index==0) {
          setState(() {
            SystemNavigator.pop();
          });

        }
        else{
          setState(() {
            navigateTo(context, home(initialIndex: 0,));
          });

        }
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              index=value;
            });
          },
          items:
        [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.beach_access),label: 'الرحلات'),
          //BottomNavigationBarItem(icon: Icon(Icons.add),label: 'انشئ رحلة'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.tickets_fill),label: 'رحلاتي'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: 'حسابي'),
        ],selectedItemColor: defaultcolor,
          currentIndex: index,
          type: BottomNavigationBarType.fixed,

        ),
        body: screens[index],
      ),
    );
  }
}
