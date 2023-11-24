import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:rahal_application/shared/network/dbdata.dart';

class sqltest extends StatelessWidget {
  @override
  String str ='data';



  Sqldb sqldata = Sqldb();

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appcubit(),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) {},
        builder:(context, state)
        {
          appcubit app = appcubit.get(context);

          return Scaffold(
          appBar:AppBar(elevation: 0) ,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  app.insertdbase('hi');
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey[350],borderRadius: BorderRadius.circular(20),),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 30,backgroundColor: Colors.blue,child: Text('n',style:TextStyle(fontSize: 40),),),
                      SizedBox(width: 10,),
                      Text('${data[index]['name']}',style:TextStyle(fontSize: 30),)

                    ],
                  ),
                ),
              ),
              itemCount: data.length,
              separatorBuilder: (context, index) =>SizedBox(height: 20,),
            ),

          ),
        );
        }
      ),
    );
  }
}
