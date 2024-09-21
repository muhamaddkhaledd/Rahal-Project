import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rahal_application/home%20pages/booked%20trip%20details.dart';
import 'package:rahal_application/home%20pages/trip%20details.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:rahal_application/shared/models/booked%20trips%20model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../shared/components/components.dart';
import '../shared/styles/colors.dart';
import 'cancel trip.dart';
class mytrips extends StatefulWidget {



  @override
  State<mytrips> createState() => _mytripsState();
}

class _mytripsState extends State<mytrips> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appcubit()..getuserdatafirebase()..getbookedtripsdata(limit: limittrips ,descending:true ),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) { },
        builder: (context, state) {
          appcubit app = appcubit.get(context);


          return Scaffold(
            appBar: AppBar(elevation: 0,backgroundColor:defaultcolor, automaticallyImplyLeading: false,),
            backgroundColor: defaultcolor,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: uid==''||uid==null?
                  Center(child: Text('الرجاء تسجيل الدخول او انشاء حساب اولا',style: TextStyle(color: Colors.white,fontSize: 15),))
                  :ConditionalBuilder(
                condition: state is !getbookedtripsdataloading,
                fallback: (context) => Center(child: SpinKitRing( color: Colors.white,)),
                builder: (context) {
                  return app.bookedtripsdata.isNotEmpty?
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.separated(
                          itemCount: app.bookedtripsdata.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => SizedBox(),
                          itemBuilder: (context, index) {
                            bookedtripmodel model = app.bookedtripsdata[index];
                            DateTime? d1 = model.tripbookeddata?['date'].toDate().subtract(Duration(days: 1));
                            DateTime? d2 = Timestamp.now().toDate();
                            int? comparetime = d1?.compareTo(d2);
                            print(comparetime);
                            return Card(
                              color: Colors.white,
                              elevation: 4,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${model.tripbookeddata?['name']}',style: TextStyle(fontSize: 20),textDirection: TextDirection.rtl,maxLines: 2,overflow: TextOverflow.ellipsis),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text('${convertdatetimeformat(model.timebooked)} : توقيت حجز الرحلة',style: TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text('${model.companionsnumbers}: عدد المرافقين',style: TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Expanded(
                                          child: Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Icon(CupertinoIcons.location_solid),
                                            Expanded(child: Text('${model.tripbookeddata?['location']}',style: TextStyle(fontSize: 15),textDirection: TextDirection.rtl,)),
                                          ],
                                        )),
                                        Expanded(
                                            child: Row(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Icon(CupertinoIcons.calendar),
                                              SizedBox(width: 5,),
                                              Expanded(child: Text('${convertdateformat(model.tripbookeddata?['date'])}',style: TextStyle(fontSize: 15),textDirection: TextDirection.rtl,)),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: Text('تم دفع ${model.totalprice}',style: TextStyle(fontSize: 15))),
                                      ],
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Visibility(
                                          visible: comparetime==1?true:false,
                                          child: Expanded(
                                            child: MaterialButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(25.0),
                                                      topRight: Radius.circular(25.0),
                                                    ),
                                                  ),
                                                    context: context,
                                                    builder: (context) {
                                                      return canceltrip(model: model,);
                                                    },
                                                );
                                              },
                                              child: Text('طلب الغاء الحجز' ,style: TextStyle(color: Colors.white,fontSize: 15),),
                                              color: Colors.red[600],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(visible: comparetime==1?true:false,child: SizedBox(width: 10,)),
                                        Expanded(
                                          child: MaterialButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(25.0),
                                                      topRight: Radius.circular(25.0),
                                                    ),
                                                  ),
                                                  context: context,
                                                  builder: (context) {
                                                    return bookedtripdetails(model: model,);
                                                  });
                                            },
                                            child: Text('تفاصيل الحجز' ,style: TextStyle(color: Colors.white,fontSize: 15),),
                                            color: defaultcolor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10,),
                        Visibility(
                          visible: app.showmore3,
                          child: ConditionalBuilder(
                            condition: state is !loadmorebookedtripsdataloading,
                            fallback:(context) => CircularProgressIndicator(color: Colors.blue,),
                            builder: (context) => MaterialButton(
                              elevation: 0,
                              focusElevation: 0,
                              disabledElevation: 0,
                              highlightElevation: 0,
                              splashColor: Colors.transparent,
                              animationDuration: Duration.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              color: Colors.amber,
                              onPressed: (){
                                app.getbookedtripsdata(limit: limittrips,descending:true );
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                width: double.infinity,
                                child: Text('اظهر المزيد',textAlign: TextAlign.center,style: TextStyle(fontSize: 15)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
                      :Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,size: 100,color: Colors.white,),
                        Text('لا يوجد رحلات تم حجزها',style: TextStyle(fontSize: 35,color: Colors.white),textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
