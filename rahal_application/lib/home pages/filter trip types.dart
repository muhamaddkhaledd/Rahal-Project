import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/home%20pages/trips%20categories.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:rahal_application/shared/styles/colors.dart';

import '../shared/components/components.dart';

class filtertriptypes extends StatefulWidget {

  @override
  State<filtertriptypes> createState() => _filtertriptypesState();
  String? imagetriptype;
  String? triptype;
  Color? theme;
  filtertriptypes({this.imagetriptype,this.triptype,this.theme});

}

class _filtertriptypesState extends State<filtertriptypes> {
  bool ordervisible = false;
  bool placesvisible = false;
  bool pricesvisible = false;
  bool meetingvisible=false;
  bool governmentvisible = false;
  String pricegroup='كل الاسعار';
  String sortgroup=orderkeyname2;
  List <bool> placespressed=[];
  List <bool> governmentspressed=[];
  List<String> placesfilter=[];
  List <String> governmentfilter = [];
  String governmentgroup=governmentkey2;

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

  @override
  void initState() {

    placesfilter.clear();
    governmentfilter.clear();
    for(int i=0;i<locations2.length;i++){
      placesfilter.add(locations2[i]);
    }
    for(int i=0;i<governments2.length;i++){
      governmentfilter.add(governments2[i]);
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
                          defaultfilterbutton(
                            isactive: true,
                            visible: governmentvisible,
                            ontap: (){
                              setState(() {
                                governmentvisible=!governmentvisible;
                              });
                            },
                            text: 'التحرك من محافظة',
                            underwidgets: [
                              Wrap(
                                textDirection: TextDirection.rtl,
                                spacing: 5,
                                runSpacing: 5,
                                children:
                                List.generate(egyptGovernments.length,
                                        (index) {
                                      return defaultfilteractions(
                                        title: egyptGovernments[index],
                                        pressed: governmentgroup==egyptGovernments[index]?true:false,
                                        onpressed: () {
                                          setState(() {
                                            governmentgroup = egyptGovernments[index];
                                          });
                                        },
                                        oncancel: () {
                                          setState(() {
                                            governmentgroup='كل المحافظات';
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
                        ],
                      ),
                    ),
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          color:widget.theme?? Colors.amber,
                          onPressed: (){
                            String oldname=orderkeyname;
                            selectsort2(sort: sortgroup);
                            print(orderkeyname2);
                            orderkeyname2=sortgroup;
                            locations2=placesfilter;
                            governments2=governmentfilter;
                            governmentkey2=governmentgroup;
                            print(governments2);
                            navigateTo(context, tripscategories('${widget.imagetriptype}', '${widget.triptype}'));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('تأكيد',style: TextStyle(fontSize: 20),),
                          ),),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: MaterialButton(
                          color: widget.theme??Colors.amber,
                          onPressed: (){
                            Navigator.pop(context);
                          },
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

