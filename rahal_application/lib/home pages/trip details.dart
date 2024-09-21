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
import 'package:url_launcher/url_launcher.dart';
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
List<String> orginizersphones=['01143588294','01287652588','012787788374'];
Map<String,dynamic> orginizerssocial={'فيسبوك':'https://www.facebook.com/profile.php?id=100056933597915','انستجرام':'','تويتر':'','سنابشات':''};
int childage=10;
int childpay=200;
List<String> placesvisit=['كافية نسمة','فندق ماس'];
int nights=0;
String hotelname='فندق ماس';
int hotelstars=3;
List<int> roomtypes=[1,2,3,4];
List<String> hotelmeals=['افطار','غداء','عشاء'];
String hoteladdress='اسوان';
String moretripdetails='يوجد اكوابارك ومسابح';

String? datastostring(List<dynamic>? datas){
  String str='';
  if(datas!=null) {
    for (String i in datas) {
      if (i == datas.last)
        str += '$i';
      else
        str += '$i ,';
    }
  }
  return str;
}
Widget roomstypes(String roomtype){
  if(roomtype=='single'){
    return Container(
      padding: EdgeInsetsDirectional.only(top:5 ,bottom: 5,start: 10,end: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(6.0),),
      child: Icon(CupertinoIcons.person),
    );
  }
  if(roomtype=='double'){
    return Container(
      padding: EdgeInsetsDirectional.only(top:5 ,bottom: 5,start: 10,end: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(6.0),),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(CupertinoIcons.person),
          Icon(CupertinoIcons.person),
        ],
      ),
    );
  }
  if(roomtype=='triple'){
    return Container(
      padding: EdgeInsetsDirectional.only(top:5 ,bottom: 5,start: 10,end: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(6.0),),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(CupertinoIcons.person),
          Icon(CupertinoIcons.person),
          Icon(CupertinoIcons.person),
        ],
      ),
    );
  }
  else if(roomtype=='suite'){
    return Container(
      padding: EdgeInsetsDirectional.only(
          top: 5, bottom: 5, start: 10, end: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(6.0),),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(Icons.business_outlined),
          SizedBox(width: 5),
          Text('جناح'),
        ],
      ),
    );
  }
  else return Container();
}

List<String> services = [
  'مسبح خارجي',
  'مطعم',
  'انترنت',
  'شرفة',
  'حديقة',
  'تكييف',
  'خدمة الغرف',
  'شاطئ البحر',
  'موقف سيارات',
  'بوفيه مفتوح',
  'وجبات خفيفة',
  'غرف لغير المدخنين',
  'بار',
  'اكوابارك',
  'منتجع صحي',
  'أنشطة رياضية',
  'صالة ألعاب رياضية'
];
Widget servicescontainer(String text,IconData icon){
  return Container(
    padding: EdgeInsetsDirectional.only(top:5 ,bottom: 5,start: 10,end: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.circular(6.0),),
    child: Row(
      textDirection: TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        SizedBox(width: 6,),
        Text('$text'),
      ],
    ),
  );
}
Widget serviceslist(String services){


  if (services == 'مسبح خارجي') {
    return servicescontainer(services,Icons.pool);
  } else if (services == 'مطعم') {
    return servicescontainer(services,Icons.restaurant);
  } else if (services == 'انترنت') {
    return servicescontainer(services,CupertinoIcons.wifi);
  } else if (services == 'شرفة') {
    return servicescontainer(services,Icons.home_outlined);
  } else if (services == 'حديقة') {
    return servicescontainer(services,Icons.park_outlined);
  } else if (services == 'تكييف') {
    return servicescontainer(services,Icons.ac_unit);
  } else if (services == 'خدمة الغرف') {
    return servicescontainer(services,Icons.room_service_outlined);
  } else if (services == 'شاطئ البحر') {
    return servicescontainer(services,Icons.beach_access_outlined);
  } else if (services == 'موقف سيارات') {
    return servicescontainer(services,Icons.local_parking_rounded);
  } else if (services == 'بوفيه مفتوح') {
    return servicescontainer(services,Icons.fastfood_outlined);
  } else if (services == 'وجبات خفيفة') {
    return servicescontainer(services,Icons.emoji_food_beverage_outlined);
  } else if (services == 'غرف لغير المدخنين') {
    return servicescontainer(services,Icons.smoke_free);
  } else if (services == 'بار') {
    return servicescontainer(services,Icons.wine_bar);
  } else if (services == 'اكوابارك') {
    return servicescontainer(services,Icons.pool_rounded);
  } else if (services == 'منتجع صحي') {
    return servicescontainer(services,Icons.spa_outlined);
  } else if (services == 'أنشطة رياضية') {
    return servicescontainer(services,Icons.golf_course_sharp);
  } else if (services == 'صالة ألعاب رياضية') {
    return servicescontainer(services,Icons.fitness_center);
  } else {
    // Handle unknown service
  }
  return Container();
}


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
                              decoration: BoxDecoration(color: Colors.grey[350],borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text('السعر',style: TextStyle(fontSize:20),),
                                        Expanded(child: Text('${app.modelid!.price.toString()}',style: TextStyle(fontSize:20),)),
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
                                        Expanded(child: Text('${app.modelid!.location}',style: TextStyle(fontSize:20),)),
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
                                        Expanded(child: Text('${convertdateformat(app.modelid!.date)}',style: TextStyle(fontSize:20),)),
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
                                        Expanded(child: Text('${app.modelid!.meetingplace}',style: TextStyle(fontSize:20),)),
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
                                        Expanded(child: Text('${app.modelid!.triptype}',style: TextStyle(fontSize:20),)),
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
                                        Expanded(child: Text('${app.modelid!.triporganizer}',style: TextStyle(fontSize:20),)),
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
                                        Expanded(child: Text('${app.modelid!.seats.toString()}',style: TextStyle(fontSize:20),)),
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
                                    Text('عنوان مكان التحرك',style: TextStyle(fontSize: 25),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text('${app.modelid!.meetingaddress}',textDirection: TextDirection.rtl),
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
                                    Icon(Icons.menu),
                                    SizedBox(width: 7,),
                                    Text('تفاصيل عن الرحلة',style: TextStyle(fontSize: 25),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text('الاطفال المرافقين تحت ${app.modelid!.childage.toString()} سنة يتم دفع ${app.modelid!.childpay.toString()} جم لهم',textDirection: TextDirection.rtl),
                                Text('الاماكن المُراد زيارتها :${datastostring(app.modelid!.placesvisit)}',textDirection: TextDirection.rtl),
                                Text('عدد الليالي : ${app.modelid!.nights}',textDirection: TextDirection.rtl),
                                Visibility(
                                  visible: app.modelid!.hotelorvillagename!=null,
                                    child: Text('اسم الفندق / القرية السياحية : ${app.modelid!.hotelorvillagename}',textDirection: TextDirection.rtl)
                                ),
                                Visibility(
                                  visible: app.modelid!.hotelstars!=null,
                                  child: Wrap(
                                    textDirection: TextDirection.rtl,
                                    spacing: 0,
                                    runSpacing: 0,
                                    children:List.generate(5, (index) {
                                      if(app.modelid!.hotelstars!=null) {
                                        if (index >app.modelid!.hotelstars! - 1) {
                                          return Icon(
                                            Icons.star_border, size: 13,);
                                        }
                                      }
                                      return Icon(Icons.star,size: 13,);
                                    }
                                    ),
                                  ),
                                ),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Icon(Icons.location_on_outlined),
                                          Expanded(child: Text('${app.modelid!.tripplaceaddress}',textDirection: TextDirection.rtl,))
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Icon(Icons.restaurant),
                                          Expanded(child: Text('${datastostring(app.modelid!.meals)}',textDirection: TextDirection.rtl,))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(visible: app.modelid!.roomtypes!=null,child: SizedBox(height: 5,)),
                                Visibility(
                                  visible: app.modelid!.roomtypes!=null,
                                  child: Wrap(
                                    textDirection: TextDirection.rtl,
                                    spacing: 5,
                                    runSpacing: 5,
                                    children:List.generate(app.modelid!.roomtypes?.length??0, (index){
                                    return roomstypes(app.modelid!.roomtypes?[index]??'');
                                  } ),),
                                ),
                                Visibility(visible: app.modelid!.services!=null,child: SizedBox(height: 15,)),
                                Visibility(visible: app.modelid!.services!=null,child: Text('خدمات')),
                                Visibility(visible: app.modelid!.services!=null,child: SizedBox(height: 10,)),
                                Visibility(
                                  visible: app.modelid!.services!=null,
                                  child: Container(
                                    height: 40,
                                    child: ListView.separated(
                                      reverse: true,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: app.modelid!.services?.length??0,
                                        itemBuilder: (context, index) {
                                          return serviceslist(app.modelid!.services?[index]);
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(width: 6,);
                                        },
                                    ),
                                  ),
                                ),
                                Visibility(visible: app.modelid!.moretripdetails!=null,child: SizedBox(height: 10,)),
                                Visibility(visible: app.modelid!.moretripdetails!=null,child: Text(': تفاصيل اخري')),
                                Visibility(visible: app.modelid!.moretripdetails!=null,child: Text('${app.modelid!.moretripdetails}')),
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
                                    Icon(Icons.checklist),
                                    SizedBox(width: 7,),
                                    Text('تفاصيل عن مُنظم الرحلة',style: TextStyle(fontSize: 25),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('اسم مُنظم الرحلة : ${app.modelid!.triporganizer}',textDirection: TextDirection.rtl),
                                    Text('ارقام هاتف للتواصل : ${datastostring(app.modelid!.orginizersphones)}',textDirection: TextDirection.rtl),
                                    Visibility(visible: app.modelid?.orginizerssocial !=null ,child: Text('روابط صفحات التواصل الاجتماعي : ',textDirection: TextDirection.rtl)),
                                    Wrap(
                                      textDirection: TextDirection.rtl,
                                      spacing: 15,
                                      runSpacing: 4,
                                      children:
                                      List.generate(
                                          app.modelid?.orginizerssocial?.length??0,(index) {
                                        return GestureDetector(onTap: () {launch('${app.modelid!.orginizerssocial?.values.toList()[index]}');},child: Text('${app.modelid!.orginizerssocial?.keys.toList()[index]}',style: TextStyle(color: Colors.blue),),);
                                      }
                                      ),
                                    ),

                                  ],
                                ),
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
                                text: 'اضف الرحلة الي العناصر المحفوظة',
                                icon: Icons.bookmark_border,
                                function: () {
                                  app.savetrips(app.modelid!);
                                  app.favbool=true;
                              },
                              ):
                              defaultprofilebuttons(
                                text: 'ازالة الرحلة من العناصر المحفوظة',
                                icon: Icons.bookmark,
                                function: () {
                                  app.removesavetrips(app.modelid!);
                                  app.favbool=false;
                                },
                              )
                              ,
                            ),
                          ),
                          defaultmapscreen(
                              title: 'مكان التحرك علي الخريطة',
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
