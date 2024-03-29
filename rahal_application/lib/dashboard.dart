import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/styles/colors.dart';

class dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formkey=GlobalKey<FormState>();
    var addtripcontroler = TextEditingController();
    return Scaffold(
      appBar: AppBar(elevation: 0,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('لوحه التحكم',style: TextStyle(fontSize: 30)),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(': مجموع الرحلات',style: TextStyle(fontSize: 20)),
                ],
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: defaultcolor),
                height: 570,
                child: ListView.separated(
                  itemCount: 3,
                  separatorBuilder:(context, index) => SizedBox(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          height: 160,
                          child:
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width:290,
                                            child: Text('trip',
                                              style: TextStyle(
                                                  fontSize: 30),
                                              textAlign: TextAlign
                                                  .right,
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,)),
                                        Text('100 جم',textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize: 15)),
                                        Text('التحرك من القاهره'),
                                        Text(': الاماكن المتبقيه'),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Icon(CupertinoIcons.location_solid),
                                            Container(
                                                width: 70,
                                                child: Text('giza',textDirection: TextDirection.rtl,maxLines: 3,overflow: TextOverflow.ellipsis,)),
                                            Icon(CupertinoIcons.calendar),
                                            Text('20.3.2023'),
                                          ]),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(onPressed: (){}, icon:CircleAvatar(child: Icon(CupertinoIcons.arrow_left)),),
                            ],
                          ),
                        ),
                      ),
                    );
                  },),
              ),
              SizedBox(height: 10,),
              Text('اضافه رحلة',style: TextStyle(fontSize: 30)),
              Form(
                key:formkey ,
                  child:
                  Column(
                    children: [
                      defaultformfield(
                          labeltxt: 'اسم الرحلة',
                          borderRediusSize: 15,
                        keyboardtype: TextInputType.name,
                        control: addtripcontroler,
                      ),
                      defaultformfield(
                        labeltxt: 'سعر الرحلة',
                        borderRediusSize: 15,
                        keyboardtype: TextInputType.number,
                        control: addtripcontroler,
                      ),
                      defaultformfield(
                        labeltxt: 'سعر الرحلة',
                        borderRediusSize: 15,
                        keyboardtype: TextInputType.number,
                        control: addtripcontroler,
                      ),
                    ],
                  ),

              ),
              SizedBox(height: 300,)
            ],
          ),
        ),
      ),
    );
  }
}
