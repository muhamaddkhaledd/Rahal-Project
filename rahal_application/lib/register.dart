import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/home%20pages/register%20steps.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:rahal_application/shared/network/local/cache_helper.dart';
class register extends StatefulWidget {
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  bool defaultlanguageisarabic=true;

  final formkey=GlobalKey<FormState>();

  var fullname =TextEditingController();

  var email=TextEditingController();

  var phonenumber=TextEditingController();

  var password=TextEditingController();

  var passwordconfirm=TextEditingController();

  var address=TextEditingController();
  bool ischanged=false;
  bool hidepassword1=true;
  bool hidepassword2=true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appcubit(),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) {
          if(state is loginsucess)
          {
            cachehelper.saveshareddata(key: 'uid', value: state.uid).then((value) {
              //app.getuserdatafirebase();
              uid = state.uid!;

              navigateTo(context,registersteps());
            });
          }
          if (state is loginerror) {
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text('خطأ'),
                    content: Text('البيانات التي ادخلتها خاطئه او تم انقطاع اتصال الانترنت'),
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

            });
          }
        },
        builder: (context, state) {
          appcubit app = appcubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: ischanged ? AutovalidateMode.onUserInteraction:AutovalidateMode.disabled,
                    key: formkey,
                    child: Column(
                      children: [
                        Text('املأ بيناتك',style: TextStyle(
                            fontFamily: defaultarabicfont,
                            color: Colors.black,
                            fontSize: 50),
                        ),
                        SizedBox(height: 20,),
                        defaultformfield(labeltxt:'الاسم بالكامل',borderRediusSize: 20,icon: Icon(Icons.perm_identity_rounded) , control:  fullname , keyboardtype:  TextInputType.name ,validation: (value) {if(value!.isEmpty)return'من فضلك ادخل الاسم بالكامل';}, ),
                        SizedBox(height: 15,),
                        defaultformfield(labeltxt:'البريد الالكتروني',borderRediusSize: 20,icon: Icon(Icons.email) , control:  email , keyboardtype:  TextInputType.emailAddress ,validation: (value) {if(value!.isEmpty||!RegExp(r'^[\w-\.#$%&@!]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value))return'من فضلك ادخل بريد الكتروني صالح';},  ),
                        SizedBox(height: 15,),
                        defaultformfield(labeltxt:'رقم الهاتف',borderRediusSize: 20,icon: Icon(Icons.phone), control:  phonenumber, keyboardtype: TextInputType.phone,prefixtext:'+20',validation: (value) {if(value!.isEmpty||!RegExp(r'^\d{11}$').hasMatch(value))return'من فضلك ادخل رقم هاتف صالح لا يقل عن 11 رقم';},maxlength: 11),
                        SizedBox(height: 15,),
                        defaultformfield(labeltxt: 'كلمة المرور',borderRediusSize: 20, icon: Icon(Icons.lock), control: password, keyboardtype:TextInputType.visiblePassword , ispassword: hidepassword1,suffixicon: IconButton(onPressed: (){setState(() {hidepassword1=!hidepassword1;});}, icon: Icon(hidepassword1? CupertinoIcons.eye_fill:CupertinoIcons.eye_slash_fill)),validation: (value) {
                          if(value!.isEmpty||!RegExp( r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{8,}$').hasMatch(value))
                            return 'يجب ان تحتوي كلمة المرور علي اكثر من 8 كلمات وعلي الاقل رقم وحرف';
                        },),
                        SizedBox(height: 15,),
                        defaultformfield(labeltxt: 'تأكيد كلمه المرور',borderRediusSize: 20, icon: Icon(Icons.lock), control: passwordconfirm, keyboardtype:TextInputType.visiblePassword , ispassword: hidepassword2,suffixicon: IconButton(onPressed: (){setState(() {hidepassword2=!hidepassword2;});}, icon: Icon(hidepassword2? CupertinoIcons.eye_fill:CupertinoIcons.eye_slash_fill)),validation: (value) {
                          if(value!.isEmpty) {
                            return 'الرجاء تأكيد كلمه المرور';}

                          else if(value!=password.text){
                            return 'كلمتا المرور التي ادخلتها غير متطابقتان';

                          }

                        },),
                        SizedBox(height: 15,),
                        defaultformfield(labeltxt:'العنوان بالكامل',borderRediusSize: 20,icon: Icon(Icons.home) , control:  address , keyboardtype:  TextInputType.text ,validation: (value) {if(value!.isEmpty)return'من فضلك ادخل العنوان بالكامل';}, ),
                        SizedBox(height: 15,),
                        defaultbutton(text: 'التسجيل',
                            condition: state is !registerloading,
                            function: (){
                          setState(() {
                            ischanged=true;
                          });
                          if(formkey.currentState!.validate())
                          {
                            //enter the process
                            app.userfirebaseregister(name: fullname.text, email: email.text, phone: phonenumber.text, password: password.text, address: address.text,birth: null,profileimage: null)
                                .then((value) {
                              app.userfirebaselogin(email: email.text, password: password.text);
                            });

                          }
                        }),
                        SizedBox(height: 40,),




                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
