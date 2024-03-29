import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rahal_application/login.dart';
import 'package:rahal_application/register.dart';
import 'package:rahal_application/shared/network/dbdata.dart';
import 'package:rahal_application/shared/network/localdatabase.dart';
import 'package:rahal_application/shared/network/sqlite.dart';





class login_register_home extends StatefulWidget {
  @override
  _login_register_homeState createState() => _login_register_homeState();
}

class _login_register_homeState extends State<login_register_home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
          SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(elevation: 0,toolbarHeight: 20,automaticallyImplyLeading: false,),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(child: Text('حساب جديد',style: TextStyle(fontSize: 20,color: Colors.black),),),
                Tab(child: Text('تسجيل الدخول',style: TextStyle(fontSize: 20,color: Colors.black),),),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  register(),
                  loginpage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


