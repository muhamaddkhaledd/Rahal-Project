import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:rahal_application/shared/network/dbdata.dart';
import 'package:rahal_application/shared/network/local/cache_helper.dart';
class loginpage extends StatefulWidget {
  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
bool defaultlanguageisarabic=true;

var email=TextEditingController();
var phonenumber=TextEditingController();
var password=TextEditingController();
final formkey=GlobalKey<FormState>();
bool isemail=true;
bool ischanged=false;
bool hidepassword=true;
Sqldb sqldb = Sqldb();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appcubit(),
      child: BlocConsumer<appcubit,appstates>(
        listener:(context, state) {
          if(state is loginsucess)
          {
            cachehelper.saveshareddata(key: 'uid', value: state.uid).then((value) {
              //app.getuserdatafirebase();
              uid = state.uid!;

              navigateTo(context,home());
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
                        Text('اهلا بك',style: TextStyle(
                            fontFamily: defaultarabicfont,
                            color: Colors.black,
                            fontSize: 50),
                        ),
                        SizedBox(height: 20,),
                        defaultformfield(labeltxt:isemail? 'البريد الالكتروني':'رقم الهاتف',borderRediusSize: 20,icon:isemail? Icon(Icons.email) : Icon(Icons.phone), control: isemail? email : phonenumber, keyboardtype: isemail? TextInputType.emailAddress : TextInputType.phone, prefixtext: isemail? null:'+20',
                          validation: (value)
                          {
                            if(isemail){
                              if(value!.isEmpty||!RegExp(r'^[\w-\.#$%&@!]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value))
                                return 'من فضلك ادخل بريد الكتروني صالح';
                            }else{
                              if(value!.isEmpty||!RegExp(r'^\d{11}$').hasMatch(value))
                                return 'من فضلك ادخل رقم هاتف صالح لا يقل عن 11 رقم';
                            }
                          },
                          onchange: (value) {
                            setState(() {

                            });
                          },
                        ),
                        SizedBox(height: 20,),
                        defaultformfield(labeltxt: 'كلمه المرور',borderRediusSize: 20, icon: Icon(Icons.lock), control: password, keyboardtype:TextInputType.visiblePassword , ispassword: hidepassword,suffixicon: IconButton(onPressed: (){setState(() {hidepassword=!hidepassword;});}, icon: Icon(hidepassword? CupertinoIcons.eye_fill:CupertinoIcons.eye_slash_fill)),validation: (value) {
                          if(value!.isEmpty||!RegExp( r'^.{8,}$').hasMatch(value))
                            return 'كلمه المرور التي ادخلتها قصيره جدا';
                        },),
                        SizedBox(height: 20,),
                        defaultbutton(text: 'الدخول',
                            condition: state is !loginloading,
                            function: (){
                          ischanged=true;
                          if(formkey.currentState!.validate())
                          {
                            //enter the process
                            app.userfirebaselogin(email: email.text, password: password.text);
                            print(FirebaseAuth.instance.currentUser?.uid);
                          }
                        }),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  setState(() {
                                    isemail=!isemail;
                                  });
                                },

                                child: Text('اضغط هنا ',style: TextStyle(color: Colors.blue),)),
                            isemail ?Text('الدخول برقم الهاتف'):Text('الدخول بالبريد الالكتروني'),
                            SizedBox(height: 100,),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  setState(() {
                                    navigateTo(context, home());
                                  });
                                },

                                child: Text('اضغط هنا ',style: TextStyle(color: Colors.blue),)),
                            Text('تسجيل الدخول لاحقا ؟'),
                          ],
                        ),

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
