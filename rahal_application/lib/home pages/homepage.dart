import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rahal_application/home%20pages/register%20steps.dart';
import 'package:rahal_application/home%20pages/trip%20details.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:shimmer/shimmer.dart';

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
    List<String> triptypes=[
      'رحلات تاريخية',
      'رحلات للشواطئ',
      'رحلات نيلية',
      'رحلات دينية',
      'رحلات ثقافية',
      'رحلات ترفيهية',
      'نزهه',
      'رحلات متنوعة',
    ];

    return BlocProvider(
      create: (context) => appcubit()..getuserdatafirebase()..checkconn()..getfeatured()..getofferscreen() ,
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
                      height: MediaQuery.of(context).size.height/1.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(60) ,bottomRight: Radius.circular(60)),
                        gradient: LinearGradient(
                          colors: [defaultcolor, Colors.green],
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
                                    child: Container(height: 200,),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  height: 50,
                                  child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) => SizedBox(width: 4),
                                    itemCount: 4,
                                    itemBuilder: (context, index) =>
                                        Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                          child: Container(
                                            width: 90,
                                          ),
                                        ),
                                  ),
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
                                    height: 150,
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
                                  Text('الصفحه الرئيسيه',style: TextStyle(fontSize: 25,color: Colors.white)),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {},
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
                                height: 50,
                                child: ListView.separated(
                                  reverse: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) => SizedBox(width: 4),
                                  itemCount: placeses.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            locations.add(placeses[index]);
                                            navigateTo(context, home(initialIndex: 1,));
                                          });
                                          print('hooooo');
                                        },
                                        child: Card(
                                          color: Colors.blueGrey[50],
                                          elevation: 7,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                          child: Container(
                                            width: 90,
                                            child: Center(child: Text('${placeses[index]}',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 13))),
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(height: 18,),
                              CarouselSlider(
                                items: assetPaths.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String assetPath = entry.value;
                                  bool isSelected = index == selectedImageIndex;
                                  return Container(
                                    child: Stack(
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
                                                      child: Container(
                                                        child: Image.asset(
                                                          assetPath, // Replace with the asset path
                                                          fit: BoxFit.cover,
                                                        ),
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
                                                               print(triptypes[index]);
                                                             });
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
                                                               child: Text('استكشف الان',style: TextStyle(fontSize: 20,color: Colors.white)),
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
                                          right: 70.0,
                                          left: 70.0,
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
                                                  triptypes[tripstypeindex],
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

                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Text('مميزه',style: TextStyle(fontSize: 25,color: Colors.black)),
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
                                height: 180,
                                width: double.infinity,
                                child: ListView.separated(
                                    reverse: true,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) => SizedBox(width: 5,),
                                    itemCount: app.featuredtrips.length,
                                    itemBuilder: (context, index) {
                                      tripsmodel model = app.featuredtrips[index];

                                      print('datassss ${app.ids}');
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20)),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                navigateTo(context, tripdetails(id: model.id!,));
                                              });

                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(20)),
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width / 1.1,
                                              child:
                                              Row(
                                                textDirection: TextDirection.rtl,
                                                children: [
                                                  Container(
                                                    width: 150,
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
                                                                width: 180,
                                                                child: Text('${model.name}',
                                                                  style: TextStyle(
                                                                      fontSize: 30),
                                                                  textAlign: TextAlign
                                                                      .right,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow
                                                                      .ellipsis,)),
                                                            Text('${model.price} جم',textDirection: TextDirection.rtl,
                                                                style: TextStyle(
                                                                    fontSize: 15)),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Row(
                                                              textDirection: TextDirection
                                                                  .rtl,
                                                              children: [
                                                                Icon(CupertinoIcons
                                                                    .location_solid),
                                                                Container(
                                                                    width: 80,
                                                                    child: Text('${model.location}',textDirection: TextDirection.rtl,maxLines: 3,overflow: TextOverflow.ellipsis,)),

                                                                Icon(CupertinoIcons
                                                                    .calendar),
                                                                Text('${model.date}'),
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
