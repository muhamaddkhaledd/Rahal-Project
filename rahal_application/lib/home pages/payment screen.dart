import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/login%20and%20register%20homepage.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/styles/colors.dart';
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


 WebViewController webcontroler = WebViewController();
 var coubon=TextEditingController();
 final coubonkey=GlobalKey<FormState>();

  late int totalprice;
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
  Widget steps(int index,appstates state,WebViewController webcontroler,appcubit app)
  {
    if(index==1)
    {
      return friststep(app,state);
    }
    if(index==2)
    {
      return secoundstep(isvisa,state,webcontroler);
    }
    if(index==3)
    {
      return thirdstep();
    }
    return Expanded(child: Container());
  }

  Widget friststep(appcubit app,appstates state)
  {
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
                        Spacer(),
                        Text('${constusers.name}'),
                      ]),
                  Divider(
                    thickness: 0.2,
                    color: Colors.black,
                  ),
                  Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text('اسم الرحله'),
                        Spacer(),
                        Text('${widget.model.name}'),
                      ]),
                  Divider(
                    thickness: 0.2,
                    color: Colors.black,
                  ),
                  Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text('موعد الرحله'),
                        Spacer(),
                        Text('${widget.model.date}'),
                      ]),
                  Divider(
                    thickness: 0.2,
                    color: Colors.black,
                  ),
                  Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text('منظم الرحله'),
                        Spacer(),
                        Text('${widget.model.triporganizer}'),
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
                                                print(app.offer);
                                                offer = app.offer;
                                                Navigator.pop(context);
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

                            while (mapdata['name'].length > selectedNumber) {
                              // Remove extra items from the 'name' list
                              mapdata['name'].removeLast();
                              mapdata['phone'].removeLast();
                              mapdata['age'].removeLast();
                              namecontrol.removeLast();
                              phonecontrol.removeLast();
                            }
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

                  if (index >= mapdata['name'].length) {
                    mapdata['name'].add('');
                    mapdata['phone'].add('');
                    mapdata['age'].add('adult');
                    namecontrol.add(TextEditingController());
                    phonecontrol.add(TextEditingController());
                    focus.add(FocusNode());
                  }
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
                              return 'الرجاء كتابه الاسم';
                            }
                          },
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            // mapdata['name'][index] = value;
                          },
                          controller: namecontrol[index],
                        ),
                        Visibility(
                          visible: mapdata['age'][index]=='adult'?true:false,
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'رقم الهاتف',prefixText: '+20',),
                            validator: (value) {
                              if(value!.isEmpty || value.length<11){
                                return 'الرجاء كتايه رقم الهاتف لا يقل عن 11 رقم';
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
                                Radio(value: 'child', groupValue:  mapdata['age'][index], onChanged: (value) {
                                  setState(() {
                                    mapdata['age'][index]='child';
                                    mapdata['phone'][index]='child';
                                  });
                                },)
                              ],
                            ),
                            Row(
                              children: [
                                Text('بالغ'),
                                Radio(value: 'adult', groupValue:   mapdata['age'][index], onChanged: (value) {
                                  setState(() {
                                    mapdata['age'][index]='adult';
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

  Widget secoundstep(bool visa,appstates state,WebViewController webcontroler)
  {
    if(visa==true)
    {

      return ConditionalBuilder(
        condition: state is !getpaymentrequestloading,
        fallback: (context) => Expanded(child: Center(child: CircularProgressIndicator())),
        builder:(context) => Expanded(child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(height: 900,child: WebViewWidget(controller:webcontroler )),
            ],
          ),
        )),

      );
    }
    else{
      return Expanded(child: Container());
    }
  }

  Widget thirdstep()
  {
    return Expanded(child: Container());
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

  @override
  Widget build(BuildContext context) {
    totalprice = (widget.model.price)!*(selectedNumber+1) *100  ?? 0;

    return BlocProvider(
      create: (context) => appcubit()..getauthtoken(),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) {
          if(state is getpaymentrequestsucess) {
            webcontroler = WebViewController()
              ..loadRequest(Uri.parse('${apiconstants
                  .baseurl}/acceptance/iframes/782681?payment_token=${apiconstants
                  .finaltoken}'));
          }
        },
        builder: (context, state) {
          appcubit app = appcubit.get(context);

          if (state is getpaymentrequesterror) {
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text('خطأ'),
                    content: Text('يرجي المحاوله مره اخري'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('حسنا'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
              app.emit(initialstate());
            });
          }
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
                      Text('عمليه حجز',style: TextStyle(fontSize: 30,color: Colors.white),),
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
                        IconButton(icon: Icon(CupertinoIcons.arrow_right), onPressed: () {
                          setState(() {
                            pagenum--;
                          });
                        },),
                      ],
                    )),
                steps(pagenum,state,webcontroler,app),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: MaterialButton(onPressed: (){
                            if(pagenum==1) {
                              if (_formKey.currentState!.validate()) {
                                for (int i = 0; i < selectedNumber; i++) {
                                  mapdata['name'][i] = namecontrol[i].text;
                                }
                                for (int i = 0; i < selectedNumber; i++) {
                                  if (mapdata['age'][i] == 'adult')
                                    mapdata['phone'][i] = phonecontrol[i].text;
                                  else
                                    mapdata['phone'][i] = 'child';
                                }

                                  app.getorderid(
                                      name: constusers.name!,
                                      email: constusers.email!,
                                      phone: constusers.phone!,
                                      price: totalprice.toString());



                                  print('sucess');
                                  mapdata['isvisa'] = isvisa;
                                  print(mapdata);
                                  setState(() {
                                    pagenum++;
                                  });


                              }
                            }
                            else if(pagenum==2)
                            {
                              setState(() {
                                pagenum++;
                              });
                            }
                            else
                            {

                            }
                          },

                            color: Colors.amberAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('التالي',style: TextStyle(fontSize: 40)),
                            ),),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          children: [
                            Text('المجموع',style: TextStyle(fontSize: 20,color: Colors.white),),
                            Text('${totalprice/100}',style: TextStyle(fontSize: 40,color: Colors.white),),
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


