import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:rahal_application/shared/styles/colors.dart';

import '../shared/components/components.dart';

class filter extends StatefulWidget {

  @override
  State<filter> createState() => _filterState();


}

class _filterState extends State<filter> {
  bool ordervisible = false;
  bool placesvisible = false;
  bool pricesvisible = false;
  bool meetingvisible=false;
  String pricegroup='كل الاسعار';
  String sortgroup=orderkeyname;
  List <bool> placespressed=[];
  List <bool> governmentspressed=[];
  List<String> placesfilter=[];
  List <String> governmentfilter = [];

  List<String> price =[
    'كل الاسعار',
    'من 0 الي 50',
    'من 50 الي 100',
    'من 100 الي 250',
    'من 250 الي 400',
    '400 فيما فوق',
  ];
  List<String> sort = [
    'افتراضي',
    'السعر من الاقل الي الاكثر',
    'السعر من الاكثر الي الاقل',
    'الموعد من الاحدث الي الابعد',
    'الموعد من الابعد الي الاحدث',
  ];
  List<String> egyptGovernments = [
    'القاهرة',
    'الإسكندرية',
    'الجيزة',
    'المنيا',
    'القليوبية',
    'البحر الأحمر',
    'الشرقية',
    'الغربية',
    'الدقهلية',
    'كفر الشيخ',
    'أسوان',
    'أسيوط',
    'الفيوم',
    'بني سويف',
    'سوهاج',
    'قنا',
    'شمال سيناء',
    'جنوب سيناء',
    'الوادي الجديد',
    'مطروح',
    'البحيرة',
    'الإسماعيلية',
  ];
@override
  void initState() {

    placesfilter.clear();
    governmentfilter.clear();
    for(int i=0;i<locations.length;i++){
      placesfilter.add(locations[i]);
    }
    for(int i=0;i<governments.length;i++){
      governmentfilter.add(governments[i]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>appcubit(),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) {},
        builder: (context, state) {
          appcubit app = appcubit.get(context);
          return Container(
            height: MediaQuery.of(context).size.height/1.6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('فلتر الرحلات',style: TextStyle(fontSize: 20)),
                          ),

                          Divider(
                            thickness: 0.2,
                            color: Colors.black,
                            height: 0,
                          ),
                          defaultfilterbutton(
                            isactive: true,
                            visible: ordervisible,
                            ontap: (){
                              setState(() {
                                ordervisible=!ordervisible;
                              });
                            },
                            text: 'ترتيب حسب',
                            underwidgets: [
                              Wrap(
                                textDirection: TextDirection.rtl,
                                spacing: 5,
                                runSpacing: 5,
                                children:
                                List.generate(sort.length,
                                        (index) {
                                      return defaultfilteractions(
                                        title: sort[index],
                                        pressed: sortgroup==sort[index]?true:false,
                                        onpressed: () {
                                          setState(() {
                                            sortgroup=sort[index];
                                          });
                                        },
                                        oncancel: () {
                                          setState(() {
                                            sortgroup='افتراضي';
                                          });
                                        },
                                      );
                                    }),

                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                          Divider(
                            thickness: 0.2,
                            color: Colors.black,
                            height: 0,
                          ),
                          defaultfilterbutton(
                            visible: placesvisible,
                            ontap: (){
                              setState(() {
                                placesvisible=!placesvisible;
                              });
                            },
                            text: 'اماكن الرحلات',
                            underwidgets: [
                              Wrap(
                                textDirection: TextDirection.rtl,
                                spacing: 3,
                                runSpacing: 3,
                                children:
                                List.generate(
                                    placeses.length,
                                        (index) {
                                      placespressed.add(false);
                                      return defaultfilteractions(
                                        title: placeses[index],
                                        pressed: placesfilter.contains(placeses[index]),
                                        onpressed: () {
                                          setState(() {
                                            if(placesfilter.contains(placeses[index])==false)
                                            {
                                              placesfilter.add(placeses[index]);
                                            }
                                            placespressed[index]=true;
                                            print(placesfilter);
                                            print(locations);
                                          });
                                        },
                                        oncancel: () {
                                          setState(() {
                                            placespressed[index]=false;
                                            placesfilter.remove(placeses[index]);
                                            print(placesfilter);
                                          });
                                        },
                                      );}),
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                          Divider(
                            thickness: 0.2,
                            color: Colors.black,
                            height: 0,
                          ),
                          // defaultfilterbutton(
                          //   text: 'الاسعار',
                          //   ontap: (){
                          //     setState(() {
                          //       pricesvisible=!pricesvisible;
                          //     });
                          //   },
                          //   visible: pricesvisible,
                          //   underwidgets: [
                          //     Wrap(
                          //       textDirection: TextDirection.rtl,
                          //       spacing: 5,
                          //       runSpacing: 5,
                          //       children:
                          //       List.generate(price.length,
                          //               (index) {
                          //             return defaultfilteractions(
                          //               title: price[index],
                          //               pressed: pricegroup==price[index]?true:false,
                          //               onpressed: () {
                          //                 setState(() {
                          //                   pricegroup=price[index];
                          //                 });
                          //               },
                          //               oncancel: () {
                          //                 setState(() {
                          //                   pricegroup='';
                          //                 });
                          //               },
                          //             );
                          //           }),
                          //
                          //     ),
                          //     SizedBox(height: 10,),
                          //   ],
                          // ),
                          // Divider(
                          //   thickness: 0.2,
                          //   color: Colors.black,
                          //   height: 0,
                          // ),
                          // defaultfilterbutton(
                          //   visible:meetingvisible,
                          //   ontap: (){
                          //     setState(() {
                          //       meetingvisible=!meetingvisible;
                          //     });
                          //   },
                          //   text: 'محافظات اماكن التجمع',
                          //   underwidgets: [
                          //     Wrap(
                          //       textDirection: TextDirection.rtl,
                          //       spacing: 3,
                          //       runSpacing: 3,
                          //       children:
                          //       List.generate(
                          //           egyptGovernments.length,
                          //               (index) {
                          //             governmentspressed.add(false);
                          //             return defaultfilteractions(
                          //               title: egyptGovernments[index],
                          //               pressed: governmentfilter.contains(egyptGovernments[index]),
                          //               onpressed: () {
                          //                 setState(() {
                          //                   if(governmentfilter.contains(egyptGovernments[index])==false)
                          //                   {
                          //                     governmentfilter.add(egyptGovernments[index]);
                          //                   }
                          //                   governmentspressed[index]=true;
                          //                   print(governmentfilter);
                          //                 });
                          //               },
                          //               oncancel: () {
                          //                 setState(() {
                          //                   governmentspressed[index]=false;
                          //                   governmentfilter.remove(egyptGovernments[index]);
                          //                   print(governmentfilter);
                          //                 });
                          //               },
                          //             );}),
                          //     ),
                          //     SizedBox(height: 10,),
                          //   ],
                          // ),
                          Divider(
                            thickness: 0.2,
                            color: Colors.black,
                            height: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          color: Colors.amber,
                          onPressed: (){
                            String oldname=orderkeyname;
                            selectsort(sort: sortgroup);
                            print(orderkeyname);
                            orderkeyname=sortgroup;
                            locations=placesfilter;
                            governments=governmentfilter;
                            print(governments);
                            navigateTo(context, home(initialIndex: 1,));

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('تأكيد',style: TextStyle(fontSize: 20),),
                          ),),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: MaterialButton(
                          color: Colors.amber,
                          onPressed: (){},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('رجوع',style: TextStyle(fontSize: 20),),
                          ),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


}

