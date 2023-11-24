import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../shared/cubit/states.dart';

class registersteps extends StatefulWidget {

  @override
  State<registersteps> createState() => _registerstepsState();
}
int stepsnum=1;
DateTime? picked;
TextEditingController datecontroller = TextEditingController();
final formkey=GlobalKey<FormState>();
class _registerstepsState extends State<registersteps> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: stepsnum!=1?AppBar(elevation: 0,leading: IconButton(onPressed: (){
        setState(() {
          stepsnum=1;
        });
      }, icon: Icon(CupertinoIcons.arrow_left)),):null,
      body: BlocProvider(
          create: (BuildContext context) => appcubit()..getuserdatafirebase(),
          child: BlocConsumer<appcubit,appstates>(
            listener: (context, state) { },
            builder: (context, state) {
              appcubit app = appcubit.get(context);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          steps(stepsnum, context, app, state),
                        ],
                      ),
                    ),
                    Container(
                          color:
                           app.profileimage==null&&stepsnum!=1

                           ?
                          Colors.grey: defaultcolor,
                          width: double.infinity,
                          child:stepsnum==1?
                          TextButton(
                            style:datecontroller.text==null||datecontroller.text==''?ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)):ButtonStyle(),
                            onPressed: () {
                                  setState(() {
                                    if(formkey.currentState!.validate())
                                    {
                                      stepsnum++;
                                      app.edituserdata(birth: datecontroller.text);
                                    }

                                });

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('التالي',style: TextStyle(fontSize: 25,color: Colors.white),),
                            ),
                          ):
                          TextButton(
                            style:app.profileimage!=null?ButtonStyle(): ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                            onPressed: () {
                              app.profileimage==null?null: app.uploadprofileimage().then((value) {
                                navigateTo(context, home());
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('انهاء',style: TextStyle(fontSize: 25,color: Colors.white),),
                            ),
                          ),

                    ),
                  ],
                ),
              );
            },


          ),
      ),
    );
  }
}


Widget steps(int step,BuildContext context,appcubit app,appstates state)
{
  if(stepsnum==1)
  {
    return friststep(context);
  }
  else
  {
    return secoundstep(app,state,context);
  }
}
Widget friststep(BuildContext context)
{
  return Column(
    children: [
      Icon(Icons.calendar_month,size: 130),
      SizedBox(height: 30,),
      Text('ادخل تاريخ ميلادك',style: TextStyle(fontSize: 30),),
      SizedBox(height: 30,),
      Form(
        key:formkey ,
        child: TextFormField(
          validator: (value) {
            if(value!.isEmpty){
              return 'الرجاء ادخال تاريخ ميلادك';
            }
          },
          controller: datecontroller,
          decoration: InputDecoration(
              labelText: 'تاريخ الميلاد',
            labelStyle: TextStyle(fontSize: 20),
            filled: true,
            prefixIcon: Icon(Icons.date_range),
            enabledBorder: OutlineInputBorder()
          ),
          readOnly: true,
          onTap: () async {
           picked= await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),);
           if (picked != null) {
             datecontroller.text = picked.toString().split(" ")[0];
           }
          },
        ),
      ),
    ],
  );
}
Widget secoundstep(appcubit app,appstates state,BuildContext context)
{
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('اضافه صوره شخصية',style: TextStyle(fontSize: 30),),
          SizedBox(height: 40,),
          CircleAvatar(backgroundColor: Colors.blueGrey[100],radius:100,backgroundImage: app.profileimage!=null?FileImage(app.profileimage!):null,child:app.profileimage==null? Icon(Icons.camera_alt,size: 80):null,),
          SizedBox(height: 40,),
          defaultbutton(text: 'تحميل صوره',
            function: () {
            app.getprofileimage();
          },),
              TextButton(
                onPressed: () {
                  navigateTo(context, home());
                },
                child: Text('تخطي'),
              ),
        ],
      ),
    ),
  );
}

