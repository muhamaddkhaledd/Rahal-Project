import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class accountdatails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 90,
            ),
            SizedBox(height: 20,),
            Text('Mohamed Khaled',style: TextStyle(fontSize: 40)),
            Text('ID :4565342456',style: TextStyle(fontSize: 20)),
            Text('email : mohkhaled6100@gmail.com',style: TextStyle(fontSize: 20)),
            Text('phone:01143588294',style: TextStyle(fontSize: 20)),
            Text('birth date :2003/10/6',style: TextStyle(fontSize: 20)),
            Text('address:cairo',style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
