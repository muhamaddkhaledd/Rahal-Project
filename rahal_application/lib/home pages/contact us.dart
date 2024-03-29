import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class contact extends StatelessWidget {
  int pageindex;
  contact({
    required this.pageindex
});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => appcubit(),
      child: BlocConsumer<appcubit,appstates>(
        listener: (context, state) {},
        builder: (context, state) {
          appcubit app = appcubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(child: selectindex(pageindex,app,state)),
            ),
          );
        },
      ),
    );
  }
}

Widget proplem(appcubit app, appstates state){
  final formkey=GlobalKey<FormState>();
  var name=TextEditingController();
  var email=TextEditingController();
  var title=TextEditingController();
  var message=TextEditingController();
  return Form(
    key: formkey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('الابلاغ عن مشكلة',textDirection: TextDirection.rtl,style: TextStyle(fontSize: 20)),
        defaultformfield(labeltxt: 'الاسم', borderRediusSize:0,control: name,validation: (value) {
          if(value!.isEmpty)
            return 'الرجاء كتابه الاسم';
        },),
        defaultformfield(labeltxt: 'البريد الالكتروني', borderRediusSize:0,control: email,validation: (value) {
          if(value!.isEmpty||!RegExp(r'^[\w-\.#$%&@!]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value))
            return 'الرجاء كتابه بريد الكتروني صالح';
        },),
        defaultformfield(labeltxt: 'عنوان للمشكله (اختياري)', borderRediusSize:0,control: title,),

        defaultformfield(labeltxt: 'الرساله', borderRediusSize:0,minlines: 5,control: message,validation: (value) {
          if(value!.isEmpty)
            return 'الرجاء كتابه الرساله';
        },),
        SizedBox(height: 15,),
        ConditionalBuilder(
          condition: state is !sendcomplaintloading,
          fallback:(context) => Center(child: CircularProgressIndicator()),
          builder: (context) {
            return defaultbutton(text: 'ارسال', function: () async{
              if(formkey.currentState!.validate()){
                await app.sendcomplaint(username: name.text ,email:email.text ,complainttitle:title.text ,complaintmessage:message.text,userid: constusers.id )
                  .then((value) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(title: Text('تم ارسال مشكلتك وسيتم التواصل معك عبر البريد الالكتروني في اقرب وقت'),actions: [TextButton(onPressed: () {
                             navigateTo(context, home(initialIndex: 3,));
                          }, child: Text('حسنا'))],);
                        },);
                });
              }
            },);
          },
        ),
      ],
    ),
  );
}

Widget termsandpolicies(){
  String rules= '''
  1- الموافقة على الشروط
- باستخدام تطبيق رحال، فإنك توافق على جميع الشروط والأحكام المذكور هنا.

2- الاستخدام المسموح به
- يُسمح باستخدام تطبيق رحال لحجز الرحلات وتنظيم السفر فقط.
- يُمنع استخدام التطبيق بأي طريق غير قانوني أو غير مصرح بها.

3- الحسابات والمعلومات الشخصية
- يجب على المستخدمين تقديم معلومات شخصية دقيقة ومحدثة عند إنشاء حساب على تطبيق رحال.
- نحن نحتفظ بحق إلغاء حسابات المستخدمين الذين يقدمون معلومات زائفة.

4- الدفع والمدفوعات
- يتم قبول الدفعات عبر البطاقات الائتمانية وطرق الدفع الإلكترونية المعتمدة.
- لن نتحمل مسؤولية أي مشكلة تتعلق بمعالجة الدفعات من قبل الجهات الخارجية.

5- سياسة الإلغاء والاسترداد
- يُمكن للمستخدمين إلغاء الحجوزات وفقًا لشروط الإلغاء المحددة لكل رحلة بعد طلب الالغاء بشرط قبول الطلب.
- قد يتم تطبيق رسوم إلغاء وفقًا للشروط المحددة.
- قد يتم قبول طلب الغاء الرحلة او رفضه بشرط سياسات يضعها مُنظم الرحلة

6- سياس الخصوصية
- نحن نحترم خصوصية معلومات المستخدمين ونلتزم بحمايتها وفقًا لسياسة الخصوصية للتطبيق.

التعويض والمسؤولية
- نحن غير مسؤولين عن أي خسائر أو أضرار ناتجة عن استخدام تطبيق رحال.
- نحن غير مسؤولين عن حجز الرحلة عن طريق الخطأ.
- التطبيق غير مسؤول عن اي رحلات خارج تنظيمة موجودة داخل التطبيق والمسؤول عن الرحلة هي الشركه المُنظمة للرحلة.

7- الامتثال القانوني
- يجب على المستخدمين الالتزام بجميع القوانين واللوائح المحلية والدولية ذات الصلة أثناء استخدام التطبيق.

8- تغييرات الشروط والأحكام
- نحتفظ بالحق في تغيير شروط الاستخدام والأحكام في أي وقت دون إشعار مسبق.
  ''';
  return Text(rules,textDirection: TextDirection.rtl,);
}

Widget emails(appcubit app){
  return Column(
    children: [
      SizedBox(height:80,),
      Center(child: Text('البريد الالكتروني الخاص بنا',style: TextStyle(fontSize: 30),textDirection: TextDirection.rtl,)),
      ListView.builder(
        itemCount: contactemails.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Center(child: Text('${contactemails[index]}',style: TextStyle(fontSize: 20),textDirection: TextDirection.rtl,));
        },
      ),
    ],
  );
}

Widget ourphonenumbers(appcubit app){
  return Column(
    children: [
      SizedBox(height:80,),
      Text('ارقام التواصل معنا',style: TextStyle(fontSize: 30),),
      ListView.builder(
        itemCount: contactphonenumbers.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Center(child: Text('${contactphonenumbers[index]}',style: TextStyle(fontSize: 20),textDirection: TextDirection.rtl,));
        },
      ),
    ],
  );
}


Widget selectindex(int index, appcubit app, appstates state){
  if(index==1){
    return proplem(app,state);
  }
  else if(index == 2){
    return termsandpolicies();
  }
  else if(index == 3){
    return emails(app);
  }
  else if(index == 4){
    return ourphonenumbers(app);
  }
  return Container();
}