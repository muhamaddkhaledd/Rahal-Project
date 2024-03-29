import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/home%20pages/filter.dart';
import 'package:rahal_application/home%20pages/trip%20details.dart';
import 'package:rahal_application/login%20and%20register%20homepage.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/models/trips%20model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../shared/cubit/states.dart';
import '../shared/models/listtripsmodel.dart';
import '../shared/styles/colors.dart';
import 'package:shimmer/shimmer.dart';

class specialtrip extends StatefulWidget {
  @override
  State<specialtrip> createState() => _specialtripState();
}

class _specialtripState extends State<specialtrip> {

  bool logoutvisibleflag=false;
  int limit =3;
  bool connection=true;
  bool ordervisible=false;

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
        create: (context) => appcubit()..getuserdatafirebase()..gettripsdatafirebase(limit: limit,orderkey: orderkey,descending: decending,locations: locations,governments: governments)..checkconn(),
        child:
        BlocConsumer<appcubit,appstates>
          (listener: (context, state) { },
            builder: (context, state) {
              appcubit app = appcubit.get(context);
              print(app.connection);
              return StreamBuilder<ConnectivityResult>(
                stream:Connectivity().onConnectivityChanged ,
                builder:(context, snapshot) =>snapshot.data==ConnectivityResult.none||app.connection==false?
                Center(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.xmark_octagon),
                      SizedBox(width: 5,),
                      Text('خطا لا يوجد اتصال بالانترنت'),
                    ],
                  ),)
                    :Scaffold(
                  backgroundColor: defaultcolor,
                  appBar: AppBar(elevation: 0,toolbarHeight: 15,backgroundColor:defaultcolor, automaticallyImplyLeading: false,),
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      physics:BouncingScrollPhysics(),//state is gettripsdatafirebasesucess? BouncingScrollPhysics():NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Divider(),
                          ConditionalBuilder(
                            condition:state is !gettripsdatafirebaseloading,
                            fallback: (context) => Shimmer.fromColors(
                              baseColor: Colors.grey[400]??Colors.grey,
                              highlightColor: Colors.white,
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
                                      height: MediaQuery.of(context).size.height/4.9,

                                    ),
                                  ),
                                ],
                              ),
                            ),
                            builder: (context) => Column(
                              children: [
                                app.datass.isEmpty?
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Icon(Icons.error_outline,color: Colors.white,size: 30),
                                      SizedBox(height: 10,),
                                      Text('عفوا لا يوجد اي رحلات',style: TextStyle(fontSize: 20,color: Colors.white),),
                                    ],
                                  ),
                                )
                                    :ListView.separated(
                                  itemCount: app.datass.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder:(context, index) => SizedBox(height: 12,) ,
                                  itemBuilder:(context, index) {
                                    listtripsmodel model = app.datass[index];//the code of generating data
                                    return  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15), // Adjust the circular border radius here
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              textDirection: TextDirection.rtl,
                                              children: [
                                                Text('${model.name}',style: TextStyle(fontSize: 40),),
                                                Spacer(),
                                                IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_border)),
                                              ],
                                            ),
                                            Row(textDirection: TextDirection.rtl,children: [Icon(CupertinoIcons.calendar),SizedBox(width: 7,),Text('${model.date}'),],),
                                            SizedBox(height: 5,),
                                            Row(textDirection: TextDirection.rtl,children: [Icon(CupertinoIcons.location_solid),SizedBox(width: 7,),Text('${model.location}'),],),
                                            Row(mainAxisAlignment: MainAxisAlignment.start,children: [Text('${model.price.toString()} جم'),SizedBox(width: 7,)],),
                                            SizedBox(height: 15,),
                                            defaultbutton(text: 'التفاصيل والحجز', function: (){
                                             // navigateTo(context,tripdetails( model: model,));
                                            })
                                          ],
                                        ),
                                      ),
                                    );
                                  },

                                ),
                                SizedBox(height: 10,),
                                Visibility(
                                  visible: app.showmore,
                                  child: ConditionalBuilder(
                                    condition: state is !loadmoredatafirebaseloading,
                                    fallback:(context) => CircularProgressIndicator(),
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
                                        setState(() {
                                          app.gettripsdatafirebase(limit: limit,orderkey: orderkey,descending: decending,locations: locations,governments: governments);
                                        });

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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ) ,
              );}
        ));
  }
}
