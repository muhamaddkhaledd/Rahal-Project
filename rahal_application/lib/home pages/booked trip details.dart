import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rahal_application/home%20pages/trip%20details.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/models/booked%20trips%20model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/components/components.dart';
import '../shared/styles/colors.dart';

class bookedtripdetails extends StatefulWidget {
  bookedtripmodel model;
  bookedtripdetails({
    required this.model,
});

  @override
  State<bookedtripdetails> createState() => _bookedtripdetailsState();
}

class _bookedtripdetailsState extends State<bookedtripdetails> {
  bool istripdetails=false;

  Widget camp(bookedtripmodel model){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: model.companionsnumbers==0?
        Center(child: Text('لا يوجد اي مرافقين')):
        SingleChildScrollView(
          child: Column(
            children: [
              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('عدد جميع المرافقين'),
                    Spacer(),
                    Expanded(child: Text('${model.companionsnumbers}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: model.companionsdata!.length,
                separatorBuilder: (context, index) => Divider(
                  thickness: 0.2,
                  color: Colors.black,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Text('اسم المرافق (${index+1})'),
                            Spacer(),
                            Expanded(child: Text('${model.companionsdata?[index]['companionname']}')),
                          ]),
                      Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Text('العمر'),
                            Spacer(),
                            Text(agedetector(model.companionsdata?[index]['campanionage'])),
                          ]),
                      Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Text('رقم الهاتف'),
                            Spacer(),
                            Text(model.companionsdata?[index]['companionphone']!=''?'${model.companionsdata?[index]['companionphone']}':'       -'),
                          ]),

                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bookeddetails(bookedtripmodel model){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('الحجز بأسم'),
                    Expanded(child: Text('${model.username}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('رقم الهاتف'),
                    Expanded(child: Text('${model.userphone}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('موعد حجز الرحلة'),
                    Expanded(child: Text('${convertdatetimeformat(model.timebooked)}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('كود الرحلة'),
                    Expanded(child: Text('${model.tripbookeddata?['id']}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('اسم الرحلة'),
                    Expanded(child: Text('${model.tripbookeddata?['name']}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),



              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('موعد الرحلة'),
                    Expanded(child: Text('${convertdateformat(model.tripbookeddata?['date'])}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('سعر الرحلة'),
                    Expanded(child: Text('${model.tripbookeddata?['price']}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('نوع الرحلة'),
                    Expanded(child: Text('${model.tripbookeddata?['triptype']}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('مكان الرحلة'),
                    Expanded(child: Text('${model.tripbookeddata?['location']}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('مكان التجمع'),
                    Expanded(child: Text('${model.tripbookeddata?['meetingplace']}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('منظم الرحلة'),
                    Expanded(child: Text('${model.tripbookeddata?['triporganizer']}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('Google Maps مكان التجمع علي'),
                    Expanded(child: GestureDetector(child: Text('اضغط هنا',style: TextStyle(color: Colors.indigo),),
                    onTap: () async{
                     GeoPoint maps =model.tripbookeddata?['googlemaps']??GeoPoint(30.0444, 31.2357);
                     print(maps);
                     await launch('https://www.google.com/maps/search/?api=1&query=${maps?.latitude},${maps?.longitude}');
                      },
                   )),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('عدد المرافقين'),
                    Expanded(child: Text('${model.companionsnumbers}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('نسبة الخصم'),
                    Expanded(child: Text('${((model.coupon??0)*100).round()} %')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('المبلغ المخصوم'),
                    Expanded(child: Text('-${(widget.model.discountedmoney)??0}')),
                  ]),
              Divider(
                thickness: 0.2,
                color: Colors.black,
              ),

              Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('المبلغ المدفوع'),
                    Expanded(child: Text('${model.totalprice}')),
                  ]),


              // Visibility(visible: bookmodel.companionsnumbers!=0,child: Divider(
              //   thickness: 0.2,
              //   color: Colors.black,
              // ),),
              // Visibility(visible: bookmodel.companionsnumbers!=0,child: Text('تفاصيل المرافقين')),
              // ListView.separated(
              //   shrinkWrap: true,
              //   itemCount: bookmodel.companionsdata!.length,
              //   separatorBuilder: (context, index) => SizedBox(),
              //   itemBuilder: (context, index) {
              //     return Column(
              //       children: [
              //         Row(
              //             textDirection: TextDirection.rtl,
              //             children: [
              //               Text('اسم المرافق (${index+1})'),
              //               Spacer(),
              //               Text('${bookmodel.companionsdata?[index]['companionname']}'),
              //             ]),
              //         Row(
              //             textDirection: TextDirection.rtl,
              //             children: [
              //               Text('رقم الهاتف'),
              //               Spacer(),
              //               Text(bookmodel.companionsdata?[index]['companionphone']!=''?'${bookmodel.companionsdata?[index]['companionphone']}':'       -'),
              //             ]),
              //       ],
              //     );
              //   },
              // ),
            ],),
        ),
      ),
    );
  }

  Widget choosestep(bool istripdetailss,bookedtripmodel model){
    if(istripdetailss==false)
      return bookeddetails(model);
    else
      return camp(model);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Text('تفاصيل الحجز'),
        //bookedtripdetails(model: model),
        choosestep(istripdetails, widget.model),
        Padding(
          padding: EdgeInsets.only(left: 10,right: 10),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    navigateTo(context,tripdetails( id: widget.model.tripbookeddata!['id'],));
                  },
                  child: Text('تفاصيل الرحلة' ,style: TextStyle(color: Colors.white,fontSize: 15),),
                  color: defaultcolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      istripdetails=!istripdetails;
                    });
                  },
                  child: Text(istripdetails?'رجوع':'تفاصيل المرافقين' ,style: TextStyle(color: Colors.white,fontSize: 15),),
                  color: defaultcolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
