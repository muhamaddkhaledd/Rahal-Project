import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/login%20and%20register%20homepage.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/models/booked%20trips%20model.dart';
import 'package:rahal_application/shared/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../shared/cubit/states.dart';
import '../shared/models/trips model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class paymentscreen extends StatefulWidget {
  tripsmodel model;
  paymentscreen({required this.model});
  @override
  State<paymentscreen> createState() => _paymentscreenState();

}

class _paymentscreenState extends State<paymentscreen> {


 var coubon=TextEditingController();
 final coubonkey=GlobalKey<FormState>();

  late int totalprice;
 late int moneydiscounted;
  double? offer;
  int selectedNumber = 0;
  String? paymentmethod;
  bool isvisa=true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TextEditingController> namecontrol=[];
  List<TextEditingController> phonecontrol=[];
  Map<String,dynamic> mapdata = {
    'bookingname':[],
    'tripname':[],
    'tripdate':[],
    'triporganizer':[],
    'isvisa':[],
    'coupons':[],
    'totalprice':[],
    'companions_number':[],
    'name':[],
    'phone':[],
    'age':[],
  } ;
  List<String> age=[];
 List<Map<String,dynamic>> companionsdatas=[];
 bookedtripmodel bookmodel=bookedtripmodel();
 bool back=true;
 Map<String,dynamic> bookingdata={};
 List <FocusNode> focus =[];
 bool isfocous()
 {
   for(int i=0;i<focus.length;i++){
     if(focus[i].hasFocus){
       return true;
     }
   }
   return false;
 }
 //steps widgets section
  int pagenum =1;
  Widget steps(int index,appstates state,appcubit app)
  {
    if(index==1)
    {
      return friststep(app,state);
    }
    if(index==2)
    {
      return secoundstep(isvisa,state,app);
    }
    if(index==3)
    {
      return thirdstep();
    }
    return Expanded(child: Container());
  }

  Widget friststep(appcubit app,appstates state)
  {
    companionsdatas.clear();
    bookingdata.clear();
    bookmodel=bookedtripmodel();

    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [

            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text('الحجز بأسم'),
                        Expanded(child: Text('${constusers.name}')),
                      ]),
                  Divider(
                    thickness: 0.2,
                    color: Colors.black,
                  ),
                  Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text('اسم الرحلة'),
                        Expanded(child: Text('${widget.model.name}',maxLines: 2,)),
                      ]),
                  Divider(
                    thickness: 0.2,
                    color: Colors.black,
                  ),
                  Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text('موعد الرحلة'),
                        Expanded(child: Text('${convertdateformat(widget.model.date)}')),
                      ]),
                  Divider(
                    thickness: 0.2,
                    color: Colors.black,
                  ),
                  Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text('منظم الرحلة'),
                        Expanded(child: Text('${widget.model.triporganizer}')),
                      ]),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Text('اختار طريقه الدفع'),
                  SizedBox(height: 10,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isvisa=false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: !isvisa?defaultcolor: Colors.grey),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('فوري باي',style: TextStyle(color: Colors.white,fontSize: 25),),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30,),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isvisa=true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color:isvisa?defaultcolor: Colors.grey),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('فيزا',style: TextStyle(color: Colors.white,fontSize: 25),),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
              child: Column(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(' اضف كوبون خصم',style: TextStyle(fontSize: 20,),),
                        Spacer(),
                        IconButton(onPressed: (){
                          showDialog(context: context,
                          builder:(context) {
                            return defaultdialogbox(
                                title_text:'ادخل كوبون خصم',
                                context: context,
                                content:
                                Form(
                                  key: coubonkey,
                                  child: Column(
                                    children: [
                                      defaultformfield(labeltxt: '', borderRediusSize: 15,control:coubon,
                                      validation: (value) {
                                        if(value!.isEmpty){
                                          return'error';
                                        }
                                      },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  Row(
                                     textDirection: TextDirection.rtl,
                                     children: [
                                      ConditionalBuilder(
                                        condition: state is !coupouncheckloading,
                                        fallback: (context) => Center(child: CircularProgressIndicator()),
                                        builder: (context) => MaterialButton(
                                          onPressed: ()async {
                                            if(coubonkey.currentState!.validate()) {
                                              await app.coupouncheck(
                                                  coubon.text).then((value) {
                                                    setState(() {
                                                      print(app.offer);
                                                      offer = app.offer;
                                                      Navigator.pop(context);
                                                    });

                                              });
                                            }
                                        },child: Text('ادخال'),),
                                      ),
                                      MaterialButton(onPressed: (){
                                        Navigator.pop(context);
                                      },child: Text('رجوع'),),
                                    ],
                                  ),

                                ]);
                          }, );
                        }, icon: Icon(Icons.add_circle_outline)),
                      ]),
                  offer!=null?Text('% ${(offer!*100).round()} خصم -',style: TextStyle(color: Colors.red),):Container(),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
              child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text('عدد المرافقين ',style: TextStyle(fontSize: 20,),),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<int>(
                        elevation: 0,
                        style: TextStyle(fontSize: 20,color: Colors.black),
                        value: selectedNumber,
                        items: List<DropdownMenuItem<int>>.generate(11,
                              (index) => DropdownMenuItem<int>(
                            value: index ,
                            child: Text((index ).toString()),
                          ),),
                        onChanged:(value) {
                          setState(() {
                            selectedNumber = value!;

                            age.clear();
                            for(int i=0;i<selectedNumber;i++){
                              age.add('adult');
                            }
                            namecontrol.clear();
                            for(int i=0;i<selectedNumber;i++){
                              namecontrol.add(TextEditingController());
                            }
                            phonecontrol.clear();
                            for(int i=0;i<selectedNumber;i++){
                              phonecontrol.add(TextEditingController());
                            }
                            print(namecontrol.length);
                            print(phonecontrol.length);
                            print(age.length);


                            // while (mapdata['name'].length > selectedNumber) {
                            //   // Remove extra items from the 'name' list
                            //   mapdata['name'].removeLast();
                            //   mapdata['phone'].removeLast();
                            //   mapdata['age'].removeLast();
                            //   namecontrol.removeLast();
                            //   phonecontrol.removeLast();
                            // }

                          }
                          );
                        },
                      ),
                    ),
                  ]),
            ),
            SizedBox(height: 15,),
            Visibility(
              visible: selectedNumber>0?true:false,
              child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(Icons.error_outline,color: Colors.white,),
                    SizedBox(width: 5,),
                    Text('من فضلك ادخل جميع بيانات المرافقين',style: TextStyle(color: Colors.white),),
                  ]),
            ),
            SizedBox(height: 15,),
            Form(
              key: _formKey,
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 15,),
                itemCount: selectedNumber,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {

                  // if (index >= mapdata['name'].length) {
                  //   mapdata['name'].add('');
                  //   mapdata['phone'].add('');
                  //   // age.add('adult');
                  //   //print(age.length);
                  // }
                    focus.add(FocusNode());

                  

                  return Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Text('ادخل بيانات المرافق رقم ${index+1}'),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'الاسم',),
                          focusNode: focus[index],
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'الرجاء كتابة الاسم';
                            }
                          },
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            // mapdata['name'][index] = value;
                          },
                          controller: namecontrol[index],
                        ),
                        Visibility(
                          visible:age[index]=='adult'?true:false,
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'رقم الهاتف',prefixText: '+20',),
                            validator: (value) {
                              if(value!.isEmpty || value.length<11){
                                return 'الرجاء كتابة رقم الهاتف لا يقل عن 11 رقم';
                              }
                            },
                            maxLength: 11,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              //mapdata['phone'][index]=value;
                            },
                            controller: phonecontrol[index],
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text('طفل'),
                                Radio(value: 'child', groupValue:  age[index], onChanged: (value) {
                                  setState(() {
                                    age[index]='child';
                                  });
                                },)
                              ],
                            ),
                            Row(
                              children: [
                                Text('بالغ'),
                                Radio(value: 'adult', groupValue:   age[index], onChanged: (value) {
                                  setState(() {
                                    age[index]='adult';
                                  });
                                },)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),);
                },),
            ),
            Visibility(
                visible: isfocous(),
                child: SizedBox(height: 220,)),
          ],
        ),
      ),
    );
  }

  Widget secoundstep(bool visa,appstates state,appcubit app)
  {
    final Completer<WebViewController> _controller = Completer<WebViewController>();
    if(visa==true)
    {
      return ConditionalBuilder(
        condition: state is getpaymentrequestsucess,
        fallback: (context) => Expanded(child: Container(height: 900,color: Colors.white,child: Center(child: SpinKitFadingCircle(
          color: defaultcolor,
        )))),
        builder:(context) => Expanded(child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(height: 850,
                  child: WebView(
                initialUrl: '${apiconstants
                  .baseurl}/acceptance/iframes/782680?payment_token=${apiconstants
                  .finaltoken}',
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onPageFinished: (url) {
                  setState(() {
                    print(url);
                    _controller.future.then((controller) {
                      controller.scrollTo(0, 0);
                    });

                    print('helllooo hommmies ');
                    app.getqueryparms(url).then((value){
                      setState(() {
                        if(value==true){
                          back=false;
                          access=true;
                          bookmodel.timebooked=Timestamp.now();
                          bookmodel.paymentsuccess=true;
                          app.sendbookeddata(bookmodel,bookmodel.companionsnumbers??0).then((value) {
                            //bookmodel=bookedtripmodel();
                            print('after success : ${bookmodel.isvisa}');
                            print('after success : ${bookmodel.timebooked}');
                            print('after success : ${bookmodel.username}');
                          });
                        }
                      });
                    });
                  });
                },
                javascriptMode: JavascriptMode.unrestricted,

                gestureNavigationEnabled: true,
              )),
            ],
          ),
        )),

      );
    }
    else{
      return Expanded(
          child: Container(height: 900,color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('سيتم اضافه خدمه فوري باي قريبا',style: TextStyle(fontSize: 20)),
              ],
            ),));
    }
  }

  Widget thirdstep()
  {
    return Expanded(
        child: Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('تفاصيل الحجز'),
            ],
          ),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),
            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('الحجز بأسم'),
                  Expanded(child: Text('${bookmodel.username}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),

            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('رقم الهاتف'),
                  Expanded(child: Text('${bookmodel.userphone}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),

            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('موعد حجز الرحلة'),
                  Expanded(child: Text('${convertdatetimeformat(bookmodel.timebooked)}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),

            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('كود الرحلة'),
                  Expanded(child: Text('${bookmodel.model?.id}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),

            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('اسم الرحلة'),
                  Expanded(child: Text('${bookmodel.model?.name}',maxLines: 2,overflow: TextOverflow.ellipsis,)),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),



            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('موعد الرحلة'),
                  Expanded(child: Text('${convertdateformat(bookmodel.model?.date)}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),

            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('سعر الرحلة'),
                  Expanded(child: Text('${bookmodel.model?.price}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),
            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('نوع الرحلة'),
                  Expanded(child: Text('${bookmodel.model?.triptype}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),
            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('مكان الرحلة'),
                  Expanded(child: Text('${bookmodel.model?.location}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),
            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('منظم الرحلة'),
                  Expanded(child: Text('${bookmodel.model?.triporganizer}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),

            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('Google Maps مكان التجمع علي'),
                  Expanded(child: GestureDetector(child: Text('اضغط هنا',style: TextStyle(color: Colors.indigo),),
                    onTap: () async{
                      GeoPoint maps =bookmodel.model?.googlemaps??GeoPoint(30.0444, 31.2357);
                      print(maps);
                      await launch('https://www.google.com/maps/search/?api=1&query=${maps?.latitude},${maps?.longitude}');
                    },
                  )),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),

            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('عدد المرافقين'),
                  Expanded(child: Text('${bookmodel.companionsnumbers}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),

            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('نسبة الخصم'),
                  Expanded(child: Text('${((bookmodel.coupon??0)*100).round()} %')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),

            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('المبلغ المخصوم'),
                  Expanded(child: Text('-${(bookmodel.discountedmoney)??0}')),
                ]),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),
            Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('المبلغ المدفوع'),
                  Expanded(child: Text('${bookmodel.totalprice}')),
                ]),

            Visibility(visible: bookmodel.companionsnumbers!=0,child: Divider(
              thickness: 0.2,
              color: Colors.black,
            ),),
            Visibility(visible: bookmodel.companionsnumbers!=0,child: Text('تفاصيل المرافقين')),
            ListView.separated(
              shrinkWrap: true,
              itemCount: bookmodel.companionsdata!.length,
              separatorBuilder: (context, index) => SizedBox(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text('اسم المرافق (${index+1})'),
                          Expanded(child: Text('${bookmodel.companionsdata?[index]['companionname']}')),
                        ]),
                    Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text('رقم الهاتف'),
                          Expanded(child: Text(bookmodel.companionsdata?[index]['companionphone']!=''?'${bookmodel.companionsdata?[index]['companionphone']}':'       -')),
                        ]),
                    Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text('العمر'),
                          Expanded(child: Text(agedetector(bookmodel.companionsdata?[index]['campanionage']))),
                        ]),
                  ],
                );
              },
            ),
        ],),
      ),
    )
    );
  }

  Widget notlogin()
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Icon(Icons.error_outline,size: 200),
      Text('الرجاء تسجيل الدخول او انشاء حساب اولا لتفعيل الحجز',style: TextStyle(fontSize: 30),textAlign: TextAlign.center),
      SizedBox(height: 15,),
      MaterialButton(
        onPressed: (){
          navigateTo(context, login_register_home());
        },
        child: Text('تسجيل الدخول او انشاء حساب',style: TextStyle(fontSize: 25)),
        color: Colors.amber,
        elevation: 0,
        splashColor: Colors.transparent,
        highlightElevation: 0,
        padding: EdgeInsets.all(10),
      ),
      SizedBox(height: 30,),
    ],);
  }
  bool access=true;
  @override
  Widget build(BuildContext context) {
    int x=0;
    if(offer!=null) {
      x = (offer! * widget.model.price!).round()*100;
    }
    print(x);
    moneydiscounted = (widget.model.price!*(offer??0)).round();
    totalprice = ((widget.model.price)!*(selectedNumber+1) *100 ) - x ;
    return BlocProvider(
      create: (context) => appcubit()..getauthtoken(),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) {
          // if(state is getpaymentrequestsucess) {}
          appcubit app = appcubit.get(context);
        },
        builder: (context, state) {
          appcubit app = appcubit.get(context);

          // if (state is getpaymentrequesterror) {
          //   Future.delayed(Duration.zero, () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return CupertinoAlertDialog(
          //           title: Text('خطأ'),
          //           content: Text('يرجي المحاوله مره اخري'),
          //           actions: [
          //             CupertinoDialogAction(
          //               child: Text('حسنا'),
          //               onPressed: () {
          //                 Navigator.of(context).pop(); // Close the dialog
          //               },
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //     app.emit(initialstate());
          //   });
          // }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child:uid==''?notlogin():
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('عملية حجز',style: TextStyle(fontSize: 30,color: Colors.white),),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    defaultcircle(textfield: '1', fieldcolor: Colors.amber),
                    Container(
                      height: 4,
                      width: 40,
                      color:pagenum!=1? Colors.amber:Colors.grey,
                    ),
                    defaultcircle(textfield: '2', fieldcolor: pagenum==2||pagenum==3? Colors.amber:Colors.grey),
                    Container(
                      height: 4,
                      width: 40,
                      color: pagenum==3? Colors.amber:Colors.grey,
                    ),
                    defaultcircle(textfield: '3', fieldcolor: pagenum==3? Colors.amber:Colors.grey),
                  ],
                ),
                SizedBox(height: 10,),
                Visibility(
                    visible: pagenum!=1?true:false,
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        IconButton(icon: Icon(CupertinoIcons.arrow_right,color: Colors.white,), onPressed: () {
                          setState(() {
                            if(back) {
                              pagenum--;
                              if (pagenum == 1) {
                                access = true;
                                namecontrol.clear();
                                phonecontrol.clear();
                                selectedNumber = 0;
                              }
                              else if (pagenum == 2) {
                                access = false;
                              }
                              else if (pagenum == 3) {
                                access = true;
                              }
                            }
                          });
                        },),
                      ],
                    )),
                steps(pagenum,state,app),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: MaterialButton(onPressed: ()async{

                            if(pagenum==1) {
                              await app.checkdocumentexistence('${widget.model.id}').then((value) async {
                              await app.checktripavailablility('${widget.model.id}',selectedNumber).then((value)  {

                              if (_formKey.currentState!.validate()) {

                                if (value == true && app.check==false) {
                                  access=false;
                                  // for (int i = 0; i < selectedNumber; i++) {
                                  //   mapdata['name'][i] = namecontrol[i].text;
                                  // }
                                  // for (int i = 0; i < selectedNumber; i++) {
                                  //   if (mapdata['age'][i] == 'adult')
                                  //     mapdata['phone'][i] = phonecontrol[i].text;
                                  //   else
                                  //     mapdata['phone'][i] = 'child';
                                  // }

                                  for (int i = 0; i < selectedNumber; i++) {
                                    if (age[i] == 'adult') {
                                      companionsdatas.add({
                                        'companionname': namecontrol[i].text,
                                        'companionphone': phonecontrol[i].text,
                                        'campanionage': age[i],
                                      });
                                    }
                                    else if (age[i] == 'child') {
                                      companionsdatas.add({
                                        'companionname': namecontrol[i].text,
                                        'companionphone': '',
                                        'campanionage': age[i],
                                      });
                                    }
                                  }

                                  print(companionsdatas);
                                  // bookingdata={
                                  //   'username':'${constusers.name}',
                                  //   'userid':'${constusers.id}',
                                  //   'useremail':'${constusers.email}',
                                  //   'userphone':'${constusers.phone}',
                                  //   'tripbookedid':widget.model.id,
                                  //   'tripbookeddata':{
                                  //     'id':widget.model.id,
                                  //     'name':widget.model.name,
                                  //     'price':widget.model.price,
                                  //     'date':widget.model.date,
                                  //     'location':widget.model.location,
                                  //     'triptype':widget.model.triptype,
                                  //     'seats':widget.model.seats,
                                  //     'images':widget.model.images,
                                  //     'meetingplace':widget.model.meetingplace,
                                  //     'tripprogram':widget.model.tripprogram,
                                  //     'meetingaddress':widget.model.meetingaddress,
                                  //     'googlemaps':widget.model.googlemaps,
                                  //     'movingtimes':widget.model.movingtimes,
                                  //     'triporganizer':widget.model.triporganizer,
                                  //   },
                                  //   'timebooked':FieldValue.serverTimestamp(),
                                  //   'companionsdata':companionsdatas,
                                  //   'companionsnumbers':companionsdatas.length,
                                  //   'isvisa':isvisa,
                                  //   'paymentsuccess':false,
                                  //   'totalprice':totalprice/100,
                                  // };

                                  bookmodel =
                                      bookedtripmodel(
                                        username: '${constusers.name}',
                                        userid: '${constusers.id}',
                                        useremail: '${constusers.email}',
                                        userphone: '${constusers.phone}',
                                        tripbookedid: widget.model.id,
                                        model: widget.model,
                                        timebooked: Timestamp.now(),
                                        companionsdata: companionsdatas,
                                        companionsnumbers: companionsdatas.length,
                                        isvisa: isvisa,
                                        paymentsuccess: false,
                                        totalprice: totalprice / 100,
                                        canceltriprequest: false,
                                        coupon: offer,
                                        discountedmoney: moneydiscounted,
                                      );

                                  print(bookmodel.paymentsuccess);

                                  app.getorderid(
                                      name: constusers.name!,
                                      email: constusers.email!,
                                      phone: constusers.phone!,
                                      price: totalprice);
                                  print('sucess');
                                  setState(() {
                                    pagenum++;
                                  });
                                }
                                else{
                                  showDialog(context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Column(
                                            children: [
                                              Icon(Icons.cancel_outlined,size: 50),
                                              SizedBox(height: 10,),
                                              Text('عفوا لا يوجد مقاعد متاحه لحجزها يمكنك تقليل عدد المرافقين او محاولة الحجز لاحقا حين يتوفر مقاعد',style: TextStyle(fontSize: 17),textDirection: TextDirection.rtl),
                                            ],
                                          ),

                                          actions: [
                                            TextButton(onPressed:() {
                                              navigateTo(context, home(initialIndex: 0,));
                                          }, child: Text('حسنا فهمت'))],
                                        );
                                      },
                                  );
                                }
                              }
                              });
                              });
                            }
                            else if(pagenum==2&&access==true)
                            {
                              access=true;
                              setState(() {
                                pagenum++;

                              });
                            }
                            else if(pagenum==3)
                            {
                              Navigator.pop(context);
                            }
                          },

                            color: access?Colors.amberAccent:Colors.grey,
                            child: ConditionalBuilder(
                              condition:state is !checkdocumentexistenceloading && state is !checktripavailablilityloading ,
                              fallback: (context) => Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: SpinKitRing(color: defaultcolor),
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: pagenum==3?Text('انهاء',style: TextStyle(fontSize: 40)):
                                  Text('التالي',style: TextStyle(fontSize: 40)),
                                );
                              },
                            ),),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          children: [
                            Text('المجموع',style: TextStyle(fontSize: 20,color: Colors.white),),
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    Text('${(totalprice/100).round()}',style: TextStyle(fontSize: 40,color: Colors.white,),),
                                    Text(' جم',style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                                Visibility(
                                  visible: offer!=null,
                                  child: Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                        decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 5,right: 5,top: 2),
                                          child: Text('- ${moneydiscounted} جم',style: TextStyle(color: Colors.white,fontSize: 10),textDirection: TextDirection.rtl),
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


