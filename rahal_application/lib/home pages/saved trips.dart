import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rahal_application/home%20pages/trip%20details.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../shared/components/components.dart';
import '../shared/cubit/states.dart';
import '../shared/models/trips model.dart';

class savedtrips extends StatefulWidget {

  @override
  State<savedtrips> createState() => _savedtripsState();
}

class _savedtripsState extends State<savedtrips> {
  bool showmore=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: defaultcolor,
        leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white, // Set the color here
        ),
        onPressed: () {
          // Implement your back button functionality here
          Navigator.of(context).pop();
        },
      ),
      ),
      backgroundColor: defaultcolor,
      body: BlocProvider(
        create: (context) => appcubit()..getfavourites(),
        child: BlocConsumer<appcubit,appstates>(
          listener: (context, state) { },
          builder: (context, state) {
            appcubit app = appcubit.get(context);

            return ConditionalBuilder(
              condition: state is !getfavouritesloading,
              fallback: (context) => Center(child: SpinKitRotatingCircle(color: Colors.white),),
              builder: (context) => SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(left: 10,right:10 ,top: 15),
                  child:app.fav.length==0?
                  Center(child: Text('لا يوجد اي رحلات محفوظة',style: TextStyle(fontSize: 20,color: Colors.white),))
                      :Column(
                        children: [
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Text('الرحلات المحفوظة',style: TextStyle(fontSize: 20,color: Colors.white),),
                            ],
                          ),
                          SizedBox(height: 7,),
                          Container(
                           decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                           child: Column(
                          children: [
                            ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  tripsmodel model = app.fav[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        print('hii');
                                        setState(() {
                                          navigateTo(context, tripdetails(id: '${model.id}'));
                                        });

                                      },
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 90,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius
                                                    .circular(15)
                                            ),
                                            child:ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: model.images?[0]!=null? Image.network(
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
                                                        size: 25,
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ) :Container(),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('${model.name}',style: TextStyle(fontSize: 20),textDirection: TextDirection.rtl,maxLines: 2,overflow: TextOverflow.ellipsis),
                                                Row(
                                                  textDirection: TextDirection.rtl,
                                                  children: [
                                                    Icon(CupertinoIcons.location_solid),
                                                    Text('${model.location}'),
                                                  ],
                                                ),
                                                Row(
                                                  textDirection: TextDirection.rtl,
                                                  children: [
                                                    Icon(CupertinoIcons.calendar),
                                                    Text('${convertdateformat(model.date)}'),
                                                  ],
                                                ),
                                              ],),
                                          ),
                                          IconButton(onPressed: (){
                                            showModalBottomSheet(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10.0),
                                                    topRight: Radius.circular(10.0),
                                                  ),
                                                ),
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        defaultprofilebuttons(text: 'الدخول الي تفاصيل الرحلة', icon: CupertinoIcons.arrow_right, function: (){
                                                          navigateTo(context, tripdetails(id: '${model.id}'));
                                                        }),
                                                        defaultprofilebuttons(text: 'ازاله الرحلة من الرحلات المحفوظ', icon: Icons.highlight_remove, function: (){
                                                          app.removesavetrips(model);
                                                          app.fav.remove(model);
                                                          Navigator.pop(context);
                                                        }),
                                                      ],
                                                    ),
                                                  );
                                                });

                                          }, icon: Icon(Icons.more_horiz))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(thickness: 2,indent: 4,endIndent: 4),
                                itemCount: app.fav.length>4&&showmore==false?4:app.fav.length),
                            Visibility(
                              visible: showmore==false&&app.fav.length>4,
                              child: MaterialButton(
                                elevation: 0,
                                focusElevation: 0,
                                disabledElevation: 0,
                                highlightElevation: 0,
                                splashColor: Colors.transparent,
                                animationDuration: Duration.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight:Radius.circular(15) ,bottomLeft: Radius.circular(15))),
                                  color: Colors.amber,
                                  onPressed: (){
                                  setState(() {
                                    showmore=true;
                                  });
                                  },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  width: double.infinity,
                                  child: Text('اظهر المزيد',textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
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
            );
          },
        ),
      ),
    );
  }
}
