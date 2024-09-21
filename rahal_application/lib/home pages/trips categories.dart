import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/home%20pages/filter%20trip%20types.dart';
import 'package:rahal_application/home%20pages/trip%20details.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:shimmer/shimmer.dart';
import '../shared/components/components.dart';
import '../shared/components/constants.dart';
import '../shared/cubit/states.dart';
import '../shared/models/listtripsmodel.dart';
import 'filter.dart';

class tripscategories extends StatelessWidget {
  String image;
  String triptype;
  tripscategories(
      this.image,
      this.triptype
      );
  Color colortrip()
  {
    if(triptype=='رحلات تاريخية')
      return Colors.brown;
    else if(triptype=='رحلات للشواطئ')
      return Colors.cyan;
    else if(triptype=='رحلات نيلية')
      return Colors.brown;
    else if(triptype=='رحلات دينية')
      return Colors.brown;
    else if(triptype=='رحلات ثقافية')
      return Colors.blueAccent;
    else if(triptype=='رحلات ترفيهية')
      return Colors.purple;
    else if(triptype=='رحلات للتنزه')
      return Colors.green;
    return Colors.blueGrey;
  }
  @override
  Widget build(BuildContext context) {
    Color backgroundcolor = colortrip();
    return BlocProvider(
      create: (context) => appcubit()..gettriptypefirebase(limit: limittrips,orderkey: orderkey2,descending: decending2,locations: locations2,governments: governments2,triptype: triptype,meetingplace:governmentkey2 )..getlistdata()..getgovernmentsdata()..gettriptypedata(),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) {},
        builder: (context, state) {
          appcubit app = appcubit.get(context);
          return  WillPopScope(
            onWillPop: () async {
              navigateTo(context, home());
              return true;
            },
            child: Scaffold(
              backgroundColor: backgroundcolor,
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image(image: AssetImage(image),),
                        Positioned(
                          top: 80,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(color: Colors.white,width: 200,height: 14,),
                              Text('${triptype}',style: TextStyle(fontSize: 41,color: Colors.white,fontWeight: FontWeight.bold)),
                              Text('${triptype}',style: TextStyle(fontSize: 40,color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 130,),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            SizedBox(width: 15,),
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              color: Colors.white,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('فلتر'),
                                  Icon(Icons.filter_alt_outlined),
                                ],
                              ),
                              onPressed: (){
                                showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return filtertriptypes(imagetriptype: '${image}',triptype: '${triptype}',theme: backgroundcolor ,);
                                    });
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding:EdgeInsetsDirectional.only(start: 5,end:5 ),
                          child: Container(
                            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height/1.260),
                            decoration: BoxDecoration(
                              color: Colors.white,borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(20),topEnd:Radius.circular(20) ),),
                            child: ConditionalBuilder(
                              condition: state is !gettriptypefirebaseloading  &&state is !getlistdataloading && state is !getgovernmentsdataloading && state is !gettriptypedataloading,
                              fallback: (context) => Shimmer.fromColors(
                                baseColor: Colors.grey[400]??Colors.grey,
                                highlightColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: 3,
                                        separatorBuilder: (context, index) => SizedBox(height: 12,),
                                        itemBuilder: (context, index) => Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),),
                                          width: double.infinity,
                                          height: MediaQuery.of(context).size.height/4.3,

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              builder: (context) =>
                              app.tripsdatatypes.isEmpty?
                              Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.error_outline,color: Colors.black,size: 50),
                                      SizedBox(height: 10,),
                                      Text('عفوا لا يوجد اي رحلات',style: TextStyle(fontSize: 30,color: Colors.black),),
                                    ],
                                  ),
                                ],
                              ):
                                  Column(
                                    children: [
                                      ListView.separated(
                                      itemCount:app.tripsdatatypes.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      separatorBuilder:(context, index) => Divider(thickness: 2) ,
                                      itemBuilder:(context, index) {
                                      listtripsmodel model = app.tripsdatatypes[index];//the code of generating data
                                      return  Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15), // Adjust the circular border radius here
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text('${model.name}',style: TextStyle(fontSize: 20),maxLines: 2,overflow: TextOverflow.ellipsis,textDirection: TextDirection.rtl,),
                                              Row(textDirection: TextDirection.rtl,children: [Icon(CupertinoIcons.calendar),SizedBox(width: 7,),Text('${convertdateformat(model.date)}'),],),
                                              SizedBox(height: 5,),
                                              Text('التحرك من ${model.meetingplace}'),
                                              SizedBox(height: 5,),
                                              Row(textDirection: TextDirection.rtl,children: [Icon(CupertinoIcons.location_solid),SizedBox(width: 7,),Text('${model.location}'),],),
                                              Row(mainAxisAlignment: MainAxisAlignment.start,children: [Text('${model.price} جم'),SizedBox(width: 7,)],),
                                              SizedBox(height: 10,),
                                              defaultbutton(color: backgroundcolor,text: 'التفاصيل والحجز', function: (){
                                                navigateTo(context,tripdetails( id: '${model.id}',));
                                              })
                                            ],
                                          ),
                                        ),
                                      );
                                      },
                                      ),
                                      Divider(thickness: 2),
                                      Visibility(
                                        visible: app.showmore1,
                                        child: ConditionalBuilder(
                                          condition: state is !loadmoretriptypefirebaseloading,
                                          fallback:(context) => CircularProgressIndicator(),
                                          builder: (context) => Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: MaterialButton(
                                              elevation: 0,
                                              focusElevation: 0,
                                              disabledElevation: 0,
                                              highlightElevation: 0,
                                              splashColor: Colors.transparent,
                                              animationDuration: Duration.zero,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              color: Colors.amber,
                                              onPressed: (){
                                                  app.gettriptypefirebase(triptype: triptype ,limit: limittrips,orderkey: orderkey2,descending: decending2,locations: locations2,governments: governments2);
                                               },
                                              child: Container(
                                                padding: EdgeInsets.all(12),
                                                width: double.infinity,
                                                child: Text('اظهر المزيد',textAlign: TextAlign.center,style: TextStyle(fontSize: 15)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        IconButton(onPressed: (){navigateTo(context, home(initialIndex: 0,));}, icon: Icon(CupertinoIcons.arrow_left,color: Colors.white,)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
