import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rahal_application/home%20pages/register%20steps.dart';
import 'package:rahal_application/home%20pages/trip%20details.dart';
import 'package:rahal_application/home%20pages/trips%20categories.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../shared/models/trips model.dart';
import '../shared/styles/colors.dart';

class homepage extends StatefulWidget {
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  void initState() {

    locations=[];
    orderkey='id';
    decending=true;
    orderkeyname='افتراضي';
    governmentkey='كل المحافظات';
    governmentkey2='كل المحافظات';
    locations2=[];
    orderkey2='id';
    decending2=true;
    orderkeyname2='افتراضي';
    super.initState();
  }
  int currentIndex=0;
  int tripstypeindex=0;
  bool isselected=false;
  int selectedImageIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<dynamic> imageUrls = ['https://firebasestorage.googleapis.com/v0/b/rahal-aa1e3.appspot.com/o/trips%203%2F93181-sky-historic_site-egyptian_pyramids-camel-great_pyramid_of_giza-1920x1080.jpg?alt=media&token=7dd7e34f-6eed-4b93-b78f-4a28ecb97d11','https://firebasestorage.googleapis.com/v0/b/rahal-aa1e3.appspot.com/o/trips%203%2F93282-white_and_blue_swimming_pool_near_green_trees_and_body_of_water_during_daytime-1920x1080.jpg?alt=media&token=3e1d5934-7017-45d4-a3de-34caa0940b17'];
    List <dynamic> assetPaths = [
      'assets/images/trips types/1.jpg',
      'assets/images/trips types/2.jpg',
      'assets/images/trips types/3.jpg',
      'assets/images/trips types/4.jpg',
      'assets/images/trips types/5.jpg',
      'assets/images/trips types/6.jpg',
      'assets/images/trips types/7.jpg',
      'assets/images/trips types/8.jpg',
    ];
    List<dynamic> placespics=[
      'assets/images/places/1.jpg',
      'assets/images/places/2.jpg',
      'assets/images/places/3.jpg',
      'assets/images/places/4.jpg',
      'assets/images/places/5.jpg',
      'assets/images/places/6.jpg',
      'assets/images/places/7.jpg',
      'assets/images/places/8.jpg',
      'assets/images/places/9.jpg',
      'assets/images/places/10.jpg',
      'assets/images/places/11.jpg',
      'assets/images/places/12.jpg',
      'assets/images/places/13.jpg',
      'assets/images/places/14.jpg',
      'assets/images/places/15.jpg',
      'assets/images/places/16.jpg',
    ];
    List<dynamic> pics = [
      'assets/images/trips/1.png',
      'assets/images/trips/2.png',
      'assets/images/trips/3.png',
      'assets/images/trips/4.png',
      'assets/images/trips/5.png',
      'assets/images/trips/6.png',
      'assets/images/trips/7.png',
      'assets/images/trips/8.png',
    ];
    List<Color?> colors=[
      Colors.amber[100],
      Colors.blue[100],
      Colors.greenAccent[100],
      Colors.orange[100],
      Colors.teal[100],
      Colors.red[100],
      Colors.green[50],
      Colors.yellow[100],
    ];
    return BlocProvider(
      create: (context) => appcubit()..getuserdatafirebase()..checkconn()..getfeatured()..getofferscreen()..getcontactinfo(),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) { },
        builder: (context, state) {
          appcubit app = appcubit.get(context);
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
              ),):
           Scaffold(
              backgroundColor: Colors.blueGrey[50],
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height:63.h,//MediaQuery.of(context).size.height/1.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(60) ,bottomRight: Radius.circular(60)),
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent,defaultcolor,Colors.deepPurpleAccent, ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ConditionalBuilder(
                          condition:state is getfeatureddatasucess && state is !getofferscreenloading ,
                          fallback: (context) => Shimmer.fromColors(
                            baseColor: Colors.grey[400]??Colors.grey,
                            highlightColor: Colors.white,
                            child:Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(width: double.infinity,height: 25,decoration:BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(height: 22.h,),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                // Container(
                                //   height: 90,
                                //   child: ListView.separated(
                                //     reverse: true,
                                //     physics:BouncingScrollPhysics() ,
                                //     scrollDirection: Axis.horizontal,
                                //     separatorBuilder: (context, index) => SizedBox(width: 4),
                                //     itemCount: 20,
                                //     itemBuilder: (context, index) =>
                                //         Card(
                                //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                //           child: Container(width: 200,)
                                //         ),
                                //   ),
                                // ),
                                Row(
                                  children: [
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight:Radius.circular(10) ),),
                                        child: Container(width: 22.w,height: 80,)
                                    ),
                                    Expanded(
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),),
                                          child: Container(height: 80,)
                                      ),
                                    ),
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft:Radius.circular(10) )),
                                        child: Container(width: 22.w,height: 80,)
                                    ),
                                  ],
                                ),
                                CarouselSlider(
                                  items: assetPaths.map((assetPath) {
                                    return Container(
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 15,bottom: 15),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(30),
                                                  bottomRight: Radius.circular(10),
                                                  bottomLeft: Radius.circular(30),
                                                ),
                                              ),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(30),
                                                    bottomRight: Radius.circular(10),
                                                    bottomLeft: Radius.circular(30),
                                                  ),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(30),
                                                    bottomRight: Radius.circular(10),
                                                    bottomLeft: Radius.circular(30),
                                                  ),
                                                  child: Container(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 70.0,
                                            left: 70.0,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    // Your existing options
                                    scrollPhysics: NeverScrollableScrollPhysics(),
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    viewportFraction: 0.8,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(width: double.infinity,height: 25,decoration:BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 15.h,
                                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          builder: (context) =>Column(
                            children: [
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Text('الصفحه الرئيسية',style: TextStyle(fontSize: 25,color: Colors.white)),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          navigateTo(context, home(initialIndex: 3,));
                                        });
                                      },
                                      icon: Icon(Icons.account_circle,size: 30,))
                                ],
                              ),
                              SizedBox(height: 15,),
                              CarouselSlider(
                                items: app.offers.map((imageUrl) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        imageUrl,
                                        fit:BoxFit.cover,
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
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  // Your existing options
                                  scrollPhysics: BouncingScrollPhysics(),
                                  autoPlayCurve: accelerateEasing,
                                  reverse: true,
                                  aspectRatio: 16 / 9,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  viewportFraction: 1,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 17),
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      currentIndex = index;
                                    });
                                  },
                                ),),
                              SizedBox(height: 10,),
                              // Container(
                              //   decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                              //   padding: EdgeInsets.all(7),
                              //   child: Row(
                              //     mainAxisSize: MainAxisSize.min,
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: imageUrls.map((image) {
                              //       int index = imageUrls.indexOf(image);
                              //       return Container(
                              //         width: 8.0,
                              //         height: 8.0,
                              //         margin: EdgeInsets.symmetric(horizontal: 4.0),
                              //         decoration: BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           color: currentIndex == index ? defaultcolor : Colors.grey,
                              //         ),
                              //       );
                              //     }).toList(),
                              //   ),
                              // ),
                              SizedBox(height: 10,),
                              Container(
                                height: 13.h,//120,
                                child: ListView.separated(
                                  reverse: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) => SizedBox(width: 8),
                                  itemCount: triptypes.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            navigateTo(context,tripscategories(assetPaths[index], triptypes[index]));
                                          });
                                          print('hooooo');
                                        },
                                        child: Card(
                                          color: colors[index],
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                                          child: Container(
                                            width: 220,
                                            child: Row(
                                              textDirection: TextDirection.rtl,
                                              children: [
                                                SizedBox(width: 10),
                                                Expanded(child: Text('${triptypes[index]}',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 11.sp))),
                                                Expanded(child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Image.asset(pics[index]),
                                                )),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              // Container(
                              //   height: 90,
                              //   child: ListView.separated(
                              //     reverse: true,
                              //     physics: BouncingScrollPhysics(),
                              //     scrollDirection: Axis.horizontal,
                              //     separatorBuilder: (context, index) => SizedBox(width: 4),
                              //     itemCount: placeses.length,
                              //     itemBuilder: (context, index) =>
                              //         GestureDetector(
                              //           onTap: () {
                              //             setState(() {
                              //               locations.add(placeses[index]);
                              //               navigateTo(context, home(initialIndex: 1,));
                              //             });
                              //             print('hooooo');
                              //           },
                              //           child: Card(
                              //             color: Colors.transparent,
                              //             elevation: 7,
                              //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                              //             child: CircleAvatar(
                              //               backgroundColor: Colors.transparent,
                              //               radius: 45,
                              //               child: ClipOval(
                              //                 child: Stack(
                              //                   children: [
                              //                     Center(
                              //                       child: Container(
                              //                         height:120,
                              //                         child: Image.asset(placespics[index],fit: BoxFit.cover),
                              //                       ),
                              //                     ),
                              //                     Positioned.fill(
                              //                       child: Container(
                              //                         decoration: BoxDecoration(
                              //                           color: Colors.black.withOpacity(0.3),
                              //                         ),
                              //                         child:Center(
                              //                           child: Container(
                              //                             padding: EdgeInsets.all(3),
                              //                             constraints: BoxConstraints(minWidth: 80),
                              //                             margin: EdgeInsets.all(5),
                              //                               child: Column(
                              //                                 mainAxisAlignment: MainAxisAlignment.center,
                              //                                 children: [
                              //                                   Divider(height: 1),
                              //                                   Text(placeses[index],style: TextStyle(fontSize: 10,color: Colors.white),textAlign: TextAlign.center),
                              //                                   Divider(height: 1),
                              //                                 ],
                              //                               )),
                              //                         ) ,
                              //                         // Semi-transparent black color
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //   ),
                              // ),
                              SizedBox(height: 10,),
                              CarouselSlider(
                                items: placespics.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String assetPath = entry.value;
                                  bool isSelected = index == selectedImageIndex;
                                  return Container(
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 20,bottom: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isSelected) {
                                                  selectedImageIndex = -1;
                                                } else {
                                                  selectedImageIndex = index;
                                                }
                                              });
                                              print('hiii');
                                            },
                                            child: Card(
                                              color: Colors.transparent,
                                              elevation: 7,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(30),
                                                  bottomRight: Radius.circular(10),
                                                  bottomLeft: Radius.circular(30),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(30),
                                                        bottomRight: Radius.circular(10),
                                                        bottomLeft: Radius.circular(30),
                                                      ),
                                                    ),
                                                    clipBehavior: Clip.antiAlias,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(30),
                                                        bottomRight: Radius.circular(10),
                                                        bottomLeft: Radius.circular(30),
                                                      ),
                                                      child: Image.asset(
                                                        assetPath, // Replace with the asset path
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isSelected) // Show overlay if image is selected
                                                    Positioned.fill(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.5),
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(10),
                                                            topRight: Radius.circular(30),
                                                            bottomRight: Radius.circular(10),
                                                            bottomLeft: Radius.circular(30),
                                                          ),
                                                        ),
                                                         child:Center(
                                                           child: TextButton(
                                                          onPressed: (){
                                                             setState(() {
                                                               locations.add(placeses[index]);
                                                               navigateTo(context, home(initialIndex: 1,));                                                             });
                                                           },
                                                             style: ButtonStyle(
                                                                 splashFactory: NoSplash.splashFactory,
                                                                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                     RoundedRectangleBorder(
                                                                       borderRadius: BorderRadius.zero,
                                                                       side: BorderSide(color: Colors.white,width: 3),
                                                                     )
                                                                 )),
                                                             child: Padding(
                                                               padding: EdgeInsets.only(top: 7,bottom: 7,right:40,left: 40),
                                                               child: Text('استكشف الان',style: TextStyle(fontSize: 15.sp,color: Colors.white)),
                                                             ),),
                                                         ) ,
                                                         // Semi-transparent black color
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),

                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 60.0,
                                          left: 60.0,
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius: BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                  colors: [Colors.blueGrey, Colors.orange],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  placeses[tripstypeindex],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  // Your existing options
                                  scrollPhysics: BouncingScrollPhysics(),
                                  reverse: true,
                                  autoPlayCurve: accelerateEasing,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  viewportFraction: 0.8,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      tripstypeindex = index;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 15,),
                              Container(
                                  height: 14.h, //120
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset('assets/images/1-.png',fit: BoxFit.cover,),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Flexible(child: Text('استكشف الرحلات الان',style: TextStyle(color: Colors.white,fontSize:  22.sp ,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                                              IconButton(
                                                color: Colors.white,
                                                icon: Icon(CupertinoIcons.arrow_left_circle,size: 45),
                                                onPressed: () {
                                                  navigateTo(context, home(initialIndex: 1,));
                                              },),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 15,),
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Text('مميزة',style: TextStyle(fontSize: 25,color: Colors.black)),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          navigateTo(context, home(initialIndex: 1,));
                                        });

                                      }, child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('المزيد',style: TextStyle(fontSize: 20,color: Colors.blue),),
                                  )),
                                ],
                              ),
                              Container(
                                height: 20.h,
                                width: double.infinity,
                                child: ListView.separated(
                                    reverse: true,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) => SizedBox(width: 5,),
                                    itemCount: app.featuredtrips.length,
                                    itemBuilder: (context, index) {
                                      tripsmodel model = app.featuredtrips[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                navigateTo(context, tripdetails(id: model.id!,));
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20)),
                                              width: MediaQuery.of(context).size.width / 1.1,
                                              child:
                                              Row(
                                                textDirection: TextDirection.rtl,
                                                children: [
                                                  Container(
                                                    width: 37.w,
                                                    height: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius
                                                            .circular(20)
                                                    ),
                                                    child:ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child:model.images?[0]!=null? Image.network(
                                                        '${model.images?[0]}',
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
                                                      ):Container(),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Column(
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .end,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                                width:45.w,
                                                                child: Text('${model.name}',style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.right, maxLines: 3,
                                                                  overflow: TextOverflow.ellipsis,)),
                                                            Text('${model.price} جم',textDirection: TextDirection.rtl,
                                                                style: TextStyle(
                                                                    fontSize: 8.sp)),
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
                                                                Container(width: 17.w,child: Text('${model.location}',textDirection: TextDirection.rtl,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 9.sp))),
                                                                Icon(CupertinoIcons.calendar),
                                                                Container(width: 15.w,child: Text('${convertdateformat(model.date)}',style: TextStyle(fontSize: 9.sp))),
                                                              ]),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
