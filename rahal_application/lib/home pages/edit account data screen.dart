import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../shared/components/components.dart';
import '../shared/cubit/states.dart';
import '../shared/styles/colors.dart';
import 'package:rahal_application/shared/components/constants.dart';

class editaccount extends StatefulWidget {
  String screen='';
  @override
  State<editaccount> createState() => _editaccountState();
  editaccount(this.screen);
}

class _editaccountState extends State<editaccount> {
  final namechangekey = GlobalKey<FormState>();
  final emailchangekey = GlobalKey<FormState>();
  final phonechangekey = GlobalKey<FormState>();
  final addresschangekey = GlobalKey<FormState>();
  final passwordchangekey = GlobalKey<FormState>();
  final birthchangekey = GlobalKey<FormState>();
  DateTime? picked;
  var namechange=TextEditingController();
  var emailchange=TextEditingController();
  var phonechange=TextEditingController();
  var addresschange=TextEditingController();
  var passwordchange=TextEditingController();
  var oldpasswordchange=TextEditingController();
  var birthchange=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appcubit()..getuserdatafirebase(),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) {},
        builder: (context, state) {
          appcubit app = appcubit.get(context);
          return Scaffold(
            appBar: AppBar(elevation: 0,),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding:EdgeInsets.only(bottom: 170),
                child: Center(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('تعديل بينات الحساب',style: TextStyle(fontSize: 30),),
                        SizedBox(height: 30,),
                        screenselect(widget.screen, app,state),
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
  Widget screenselect(String screen,appcubit app,appstates state){
    if(screen=='changename')
      return changename(app,state);
    else if(screen=='changenumber')
      return changenumber(app,state);
    else if(screen=='changeaddress')
      return changeaddress(app,state);
    else if(screen=='changebirth')
      return changebirth(app,state);
    else if(screen=='changepassword')
      return changepassword(app,state);
    else if(screen=='changeemail')
      return changeemail(app,state);
    else return Container();
  }

  Widget changename(appcubit app,appstates state){
    return Column(
      children: [
        Form(
          key: namechangekey,
          child: Column(
            children: [
              Text('ادخل الاسم الجديد'),
              SizedBox(height: 10,),
              defaultformfield(labeltxt: 'الاسم', borderRediusSize: 10,
                validation: (value) {
                  if(value!.isEmpty)
                    return 'الرجاء كتابه اسم صالح';
                },
                control: namechange,
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        ConditionalBuilder(
          condition: state is !edituserdatafirebaseloading,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) {
            return Container(
                decoration: BoxDecoration(color: defaultcolor,borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                child: TextButton(onPressed: (){
                  if(namechangekey.currentState!.validate())
                  {
                    //code here
                    app.edituserdata(name: namechange.text).then((value) {
                      navigateTo(context, home());
                    });
                  }
                }
                  , child: Text('تأكيد',style: TextStyle(color: Colors.white,)),));
          },
        ),
      ],
    );
  }

  Widget changenumber(appcubit app,appstates state){
    return Column(
      children: [
        Form(
          key: phonechangekey,
          child: Column(
            children: [
              Text('ادخل رقم الهاتف الجديد'),
              SizedBox(height: 10,),
              defaultformfield(labeltxt: 'رقم الهاتف', borderRediusSize: 10,
                validation: (value) {
                  if(value!.isEmpty||!RegExp(r'^\d{11}$').hasMatch(value))
                    return 'الرجاء كتابة رقم هاتف صالح';
                },
                maxlength: 11,
                prefixtext: '+20',
                control: phonechange,
                keyboardtype: TextInputType.phone,
                icon: Icon(Icons.phone),
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        ConditionalBuilder(
          condition: state is !edituserdatafirebaseloading,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) {
            return Container(
                decoration: BoxDecoration(color: defaultcolor,borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                child: TextButton(onPressed: (){
                  if(phonechangekey.currentState!.validate())
                  {
                    //code here
                    app.edituserdata(phone: phonechange.text).then((value) {
                      navigateTo(context, home());
                    }).catchError((error){
                      error.toString();
                    });
                  }
                }
                  , child: Text('تأكيد',style: TextStyle(color: Colors.white,)),));
          },
        ),
      ],
    );
  }

  Widget changeaddress(appcubit app,appstates state){
    return Column(
      children: [
        Form(
          key: addresschangekey,
          child: Column(
            children: [
              Text('ادخل العنوان الجديد'),
              SizedBox(height: 10,),
              defaultformfield(labeltxt: 'العنوان', borderRediusSize: 10,
                validation: (value) {
                  if(value!.isEmpty)
                    return 'الرجاء كتابة عنوان صالح';
                },
                control: addresschange,
                keyboardtype: TextInputType.text,
                icon: Icon(Icons.house_outlined),
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        ConditionalBuilder(
          condition: state is !edituserdatafirebaseloading,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) {
            return Container(
                decoration: BoxDecoration(color: defaultcolor,borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                child: TextButton(onPressed: (){
                  if(addresschangekey.currentState!.validate())
                  {
                    //code here
                    app.edituserdata(address: addresschange.text).then((value) {
                      Navigator.pop(context);
                    }).catchError((error){
                      error.toString();
                    });
                  }
                }
                  , child: Text('تأكيد',style: TextStyle(color: Colors.white,)),));
          },
        ),
      ],
    );
  }

  Widget changebirth(appcubit app,appstates state){
    return Column(
      children: [
        Form(
          key:birthchangekey ,
          child: TextFormField(
            validator: (value) {
              if(value!.isEmpty){
                return 'الرجاء ادخال تاريخ ميلادك';
              }
            },

            controller: birthchange,
            decoration: InputDecoration(
                labelText: 'تاريخ الميلاد',
                labelStyle: TextStyle(fontSize: 20),
                filled: true,
                prefixIcon: Icon(Icons.date_range),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            readOnly: true,
            onTap: () async {
              picked= await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),);
              if (picked != null) {
                birthchange.text = picked.toString().split(" ")[0];
              }
            },
          ),
        ),
        SizedBox(height: 10,),
        ConditionalBuilder(
          condition: state is !edituserdatafirebaseloading,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) {
            return Container(
                decoration: BoxDecoration(color: defaultcolor,borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                child: TextButton(onPressed: (){
                  if(birthchangekey.currentState!.validate())
                  {
                    app.edituserdata(birth: birthchange.text).then((value) {
                      Navigator.pop(context);
                    });
                  }
                }
                  , child: Text('تأكيد',style: TextStyle(color: Colors.white,)),));
          },
        ),
      ],
    );
  }

  Widget changepassword(appcubit app,appstates state){
    return Column(
      children: [
        Form(
          key: passwordchangekey,
          child: Column(
            children: [
              Text('تغيير كلمه المرور'),
              SizedBox(height: 10,),
              defaultformfield(labeltxt: 'كلمه المرور القديمة', borderRediusSize: 10,
                validation: (value) {
                  if(value!.isEmpty||oldpasswordchange.text!=constusers.password)
                    return 'الرجاء كتابة كلمة مرور صحيحة';
                },
                control: oldpasswordchange,
                keyboardtype: TextInputType.text,
                ispassword: true,
              ),
              SizedBox(height: 10,),
              defaultformfield(labeltxt: 'كلمه المرور الجديدة', borderRediusSize: 10,
                validation: (value) {
                  if(value!.isEmpty||!RegExp( r'^.{8,}$').hasMatch(value))
                    return 'كلمه المرور التي ادخلتها قصيره جدا';
                },
                control: passwordchange,
                keyboardtype: TextInputType.text,
                ispassword: true,
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        ConditionalBuilder(
          condition: state is !edituserdatafirebaseloading,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) {
            return Container(
                decoration: BoxDecoration(color: defaultcolor,borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                child: TextButton(onPressed: (){
                  if(passwordchangekey.currentState!.validate())
                  {
                    //code here
                      app.edituserdata(password: passwordchange.text).then((value) {
                        Navigator.pop(context);
                      }).catchError((error) {
                        error.toString();
                      });

                  }
                }
                  , child: Text('تأكيد',style: TextStyle(color: Colors.white,)),));
          },
        ),
      ],
    );
  }

  Widget changeemail(appcubit app,appstates state){
    return Column(
      children: [
        Form(
          key: emailchangekey,
          child: Column(
            children: [
              Text('ادخل البريد الالكتروني الجديد'),
              SizedBox(height: 10,),
              defaultformfield(labeltxt: 'البريد الالكتروني', borderRediusSize: 10,
                validation: (value) {
                  if(app.emailExists||value!.isEmpty||!RegExp(r'^[\w-\.#$%&@!]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)){
                    return !app.emailExists?'الرجاء كتابه بريد الكتروني صالح':'البريد الالكتروني الذي ادخلته موجود بالفعل';
                  }
                },
                control: emailchange,
                keyboardtype: TextInputType.emailAddress,
                icon: Icon(Icons.email_outlined),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        ConditionalBuilder(
          condition: state is !edituserdatafirebaseloading,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) {
            return Container(
                decoration: BoxDecoration(color: defaultcolor,borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                child: TextButton(onPressed: ()async {
                  await app.checkEmailExists(emailchange.text);
                  if(emailchangekey.currentState!.validate())
                  {
                    app.edituserdata(email: emailchange.text).then((value) {
                      navigateTo(context, home());
                    }).catchError((error){
                      error.toString();
                    });
                  }
                }
                  , child: Text('تأكيد',style: TextStyle(color: Colors.white,)),));
          },
        ),
      ],
    );
  }
}
