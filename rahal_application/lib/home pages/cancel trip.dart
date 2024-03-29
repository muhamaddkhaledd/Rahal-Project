import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:rahal_application/shared/models/trips%20model.dart';
import 'package:rahal_application/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../shared/components/components.dart';
import '../shared/components/constants.dart';
import '../shared/models/booked trips model.dart';

class canceltrip extends StatefulWidget {
  bookedtripmodel model;
  canceltrip({
    required this.model,
  });

  @override
  State<canceltrip> createState() => _canceltripState();
}

class _canceltripState extends State<canceltrip> {
  String conditions = '- يتم طلب الغاء الرحلة ويمكن الموافقه علي الطلب او رفضه.\n'
      '- سيتم الرد علي العميل في اسرع وقت لاخطاره بقبول او رفض طلب الغاء الرحلة.\n'
      '- لتمكين استخدام خدمه الغاء الطلب يجب ان يتم استخدام الخدمه قبل موعد انطلاق الرحلة بيومين.\n'
      '- سيتم التواصل مع العميل لمعرفه سبب المشكله التي ادت به الي الغاء الرحلة ومحاوله حلها اولا ثم الغائها ان لم يجد العميل حلا للمشكله.\n'
      '- ان تم الموافقه علي طلب الغاء الرحلة سيتم التواصل مع العميل لتحويل واسترجاع امواله.\n'
      '- قبول او رفض طلب الغاء الرحلة مبني علي شروط وسياسات يضعها المنظم.\n'
      '- الحد الاقصي لالغاء مقاعد الرحلة للمرافقين هو اربعه مقاعد.\n'
      '- يرجي العلم انه ان لم يتم التواصل هاتفيا مع العميل بعد تفعيل طلب الغاء الرحلة علي انه تم رفض طلب الغاء رحلته.\n';
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    pressed = widget.model.canceltriprequest??false;
    return BlocProvider(
      create: (context) => appcubit(),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) {},
        builder: (context, state) {
          appcubit app = appcubit.get(context);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10,),
              Text('طلب الغاء الرحلة'),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(': سياسه الغاء الرحلة'),

                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(conditions,textDirection: TextDirection.rtl,)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if(pressed==false) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'هل انت متأكد انك تريد تفعيل طلب الغاء رحلتك ؟',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 20)),
                              Text(
                                  '- ملحوظه :طلب الغاء رحلتك ليس معناه ان الرحلة سوف يتم الغائها فورا بل هو طلب لألغائها وسيتم مراجعته والتواصل مع العميل واخطاره بقبول الطلب او الرفض',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13)),
                            ],
                          ),
                          actions: [
                            Row(
                              children: [
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 2, color: defaultcolor)),
                                  child: Text('الغاء'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: ConditionalBuilder(
                                    condition: state is !canceltriprequestloading,
                                    fallback: (context) => CircularProgressIndicator(),
                                    builder: (context) {
                                      return MaterialButton(
                                        color: defaultcolor,
                                        child: Text('تأكيد', style: TextStyle(
                                            color: Colors.white)),
                                        onPressed: () {
                                          print(widget.model
                                              .tripbookeddata?['location']);

                                          app.canceltriprequest(widget.model).then((value) {
                                            setState(() {
                                              print(widget.model.model?.location);
                                              print(widget.model.model?.name);
                                              widget.model.canceltriprequest =true;
                                              widget.model.canceltripid='${app.canceltripreqid}';
                                              pressed = true;
                                              Navigator.pop(context);
                                            });
                                          });
                                        },);
                                    },
                                  ),
                                ),
                              ],),
                          ],

                        );
                      },
                    );
                  }
                  else{
                    app.deletecanceltriprequest(widget.model).then((value) {
                      setState(() {
                        widget.model.canceltriprequest =false;
                        pressed = false;
                      });
                    });
                  }
                },
                child: pressed?
                ConditionalBuilder(
                  condition: state is !deletecanceltriprequestloading,
                  fallback: (context) => CircularProgressIndicator(),
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border:Border.all(color: Colors.red,width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text('الغاء تفعيل طلب الغاء الرحلة',style: TextStyle(fontSize:15 ,color: Colors.black)),
                      ),
                    );
                  },
                )
                    :Container(
                  decoration: BoxDecoration(
                    color:Colors.red[600],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:Text('تفعيل طلب الغاء الرحلة',style: TextStyle(fontSize:15 ,color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          );
        },
      ),
    );
  }
}
