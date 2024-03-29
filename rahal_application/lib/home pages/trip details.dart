import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rahal_application/home%20pages/payment%20screen.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../shared/components/constants.dart';
import '../shared/cubit/states.dart';
import '../shared/models/trips model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class tripdetails extends StatefulWidget {
String id;
tripdetails({required this.id});

  @override
  State<tripdetails> createState() => _tripdetailsState();
}

class _tripdetailsState extends State<tripdetails> {
int currentIndex = 0;
LatLng? position;
bool isloading=false;
bool tripavilable=true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appcubit()..gettripdata(widget.id)..isfromfavourates(widget.id)..checkdocumentexistence(widget.id),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) {} ,
        builder: (context, state) {
          appcubit app = appcubit.get(context);
          if(app.modelid?.date?.compareTo(Timestamp.now())==-1 || app.check ||app.modelid?.seats==0 ){
            tripavilable=false;
          }
          print('the num isss ${app.modelid?.date?.compareTo(Timestamp.now())}');
          List<dynamic> imageUrls = app.modelid?.images?? [];
          print('type : ${app.modelid?.googlemaps}');
          if (app.modelid?.googlemaps != null) {
            position = LatLng(
              app.modelid!.googlemaps!.latitude ?? 0.0,
              app.modelid!.googlemaps!.longitude ?? 0.0,
            );
          }
          print('homie is ${app.check}');
          return Scaffold(
            appBar: AppBar(elevation: 0,),
            body: ConditionalBuilder(
              condition:state is !gettripdataloading && state is !isfromfavouratesloading && state is !checkdocumentexistenceloading,
              fallback: (context) => Center(child: SpinKitRing(
                color: defaultcolor,
              )),
              builder: (context) {
                if(imageUrls.isEmpty){
                  imageUrls.add('');
                }
                return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [

                          SizedBox(height: 20,),
                          CarouselSlider(
                            items: imageUrls.map((imageUrl) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey, // Placeholder color
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child:imageUrls.contains('')?null:
                                Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      // Image has finished loading
                                      return child;
                                    } else {
                                      // Display a CircularProgressIndicator while loading
                                      return Center(
                                        child: SpinKitThreeBounce(
                                          color: Colors.white,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              // Your existing options
                              scrollPhysics: BouncingScrollPhysics(),

                              aspectRatio: 16 / 9,
                              viewportFraction: 0.9,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imageUrls.map((image) {
                              int index = imageUrls.indexOf(image);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentIndex == index ? defaultcolor : Colors.grey,
                                ),
                              );
                            }).toList(),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text('${app.modelid!.name}',style: TextStyle(fontSize: 17),textDirection: TextDirection.rtl,),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(right: 20),
                          //   child: Row(
                          //     textDirection: TextDirection.rtl,
                          //     children: [
                          //       CircleAvatar(radius: 17,child: Icon(Icons.favorite_border,size: 25,color: Colors.white),backgroundColor: Colors.blueGrey),
                          //     ],
                          //   ),
                          // ),
                          Visibility(
                            visible: !tripavilable,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20,left: 20),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                Icon(Icons.error_outline),
                                SizedBox(width: 5,),
                                Expanded(child: Text('عفوا لا يمكنك حجز الرحلة بسبب انها غير متوفرة او تم حجز كل المقاعد او لقد قمت بحجزها من قبل',textDirection: TextDirection.rtl,)),
                              ],),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.blueGrey[100],borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text('السعر',style: TextStyle(fontSize:20),),
                                        Spacer(),
                                        Text('${app.modelid!.price.toString()}',style: TextStyle(fontSize:20),),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.2,
                                      color: Colors.black,
                                      height: 21,
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text('مكان الرحلة',style: TextStyle(fontSize:20),),
                                        Spacer(),
                                        Text('${app.modelid!.location}',style: TextStyle(fontSize:20),),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.2,
                                      color: Colors.black,
                                      height: 21,
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text('موعد الرحلة',style: TextStyle(fontSize:20),),
                                        Spacer(),
                                        Text('${convertdateformat(app.modelid!.date)}',style: TextStyle(fontSize:20),),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.2,
                                      color: Colors.black,
                                      height: 21,
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text('التحرك من',style: TextStyle(fontSize:20),),
                                        Spacer(),
                                        Text('${app.modelid!.meetingplace}',style: TextStyle(fontSize:20),),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.2,
                                      color: Colors.black,
                                      height: 21,
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text('نوع الرحلة',style: TextStyle(fontSize:20),),
                                        Spacer(),
                                        Text('${app.modelid!.triptype}',style: TextStyle(fontSize:20),),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.2,
                                      color: Colors.black,
                                      height: 21,
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text('منظم الرحلة',style: TextStyle(fontSize:20),),
                                        Spacer(),
                                        Text('${app.modelid!.triporganizer}',style: TextStyle(fontSize:20),),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.2,
                                      color: Colors.black,
                                      height: 21,
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text('المقاعد المتاحة',style: TextStyle(fontSize:20),),
                                        Spacer(),
                                        Text('${app.modelid!.seats.toString()}',style: TextStyle(fontSize:20),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 80,),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Icon(Icons.file_copy_outlined),
                                    SizedBox(width: 7,),
                                    Text('برنامج الرحلة',style: TextStyle(fontSize: 25),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text('${app.modelid!.tripprogram}',textDirection: TextDirection.rtl),
                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Icon(Icons.access_time_outlined),
                                    SizedBox(width: 7,),
                                    Text('مواعيد التحركات',style: TextStyle(fontSize: 25),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text('${app.modelid!.movingtimes}',textDirection: TextDirection.rtl),
                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Icon(Icons.location_on_outlined),
                                    SizedBox(width: 7,),
                                    Text('عنوان مكان التجمع',style: TextStyle(fontSize: 25),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text('${app.modelid!.meetingaddress}',textDirection: TextDirection.rtl),
                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          Visibility(
                            visible: uid!='',
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child:app.favbool==false?
                              defaultprofilebuttons(
                                text: 'اضف الرحل الي العناصر المحفوظة',
                                icon: Icons.bookmark_border,
                                function: () {
                                  app.savetrips(app.modelid!);
                                  app.favbool=true;
                              },
                              ):
                              defaultprofilebuttons(
                                text: 'ازاله الرحل من العناصر المحفوظة',
                                icon: Icons.bookmark,
                                function: () {
                                  app.removesavetrips(app.modelid!);
                                  app.favbool=false;
                                },
                              )
                              ,
                            ),
                          ),
                          defaultmapscreen(title: 'مكان التجمع علي الخريطة',
                              addressonpointer: app.modelid?.meetingaddress??'',
                              position: position??LatLng(30.0444, 31.2357)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    child: MaterialButton(onPressed: () async {
                      if(tripavilable) {
                        showModalBottomSheet(
                            backgroundColor: defaultcolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 1.1,
                                child: paymentscreen(
                                    model: app.modelid ?? tripsmodel()),
                              );
                            });
                      }
                    },
                      child: Text('احجز الان' ,style: TextStyle(color: Colors.white,fontSize: 20),),
                      color: tripavilable?defaultcolor:Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),

                    ),
                  ),
                ],
              );}
            ),
          );
        },
      ),
    );
  }
}
