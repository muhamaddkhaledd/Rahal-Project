import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahal_application/home%20pages/saved%20trips.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/login%20and%20register%20homepage.dart';
import 'package:rahal_application/shared/components/constants.dart';
import 'package:rahal_application/shared/cubit/cubit.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:rahal_application/shared/styles/colors.dart';

import '../shared/components/components.dart';
import 'edit account data screen.dart';

class myaccount extends StatefulWidget {

  @override
  State<myaccount> createState() => _myaccountState();
}

class _myaccountState extends State<myaccount> {
  @override
  bool accountvisible=false;
  bool favtripsvisible=false;
  bool securityvisible=false;
  bool dataeditvisible =false;
  bool helpvisible=false;
  bool settingsvisible=false;
  bool contactusvisible=false;
  bool isnotificationactive=false;
  bool isdarkmodeactive=false;

  final namechangekey = GlobalKey<FormState>();
  final emailchangekey = GlobalKey<FormState>();
  final phonechangekey = GlobalKey<FormState>();
  final addresschangekey = GlobalKey<FormState>();
  final passwordchangekey = GlobalKey<FormState>();

  var namechange=TextEditingController();
  var emailchange=TextEditingController();
  var phonechange=TextEditingController();
  var addresschange=TextEditingController();
  var passwordchange=TextEditingController();
  var oldpasswordchange=TextEditingController();
  var birthchange=TextEditingController();
  bool showaccdetails=false;
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>appcubit(),
      child: BlocConsumer<appcubit,appstates>(
       listener: (context, state) {},
       builder: (context, state) {
         appcubit app = appcubit.get(context);
         return Scaffold(
           backgroundColor: defaultcolor,
           appBar: AppBar(elevation: 0,backgroundColor: defaultcolor,toolbarHeight: 10),
           body: Padding(
             padding: const EdgeInsets.all(8.0),
             child: SingleChildScrollView(
               physics: BouncingScrollPhysics(),
               child: Column(
                 children: [
                  Container(
                     width: double.infinity,
                     decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                     child: Column(
                       textDirection: TextDirection.rtl,
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Stack(
                             alignment: AlignmentDirectional.bottomEnd,
                             children: [
                               CircleAvatar(radius: 75,child:constusers.profileimage==null||constusers.profileimage==''? Icon(Icons.account_circle,size: 150):null,backgroundImage:constusers.profileimage!=null? NetworkImage('${constusers.profileimage}'):null),
                               Visibility(
                                 visible: uid!='',
                                 child: GestureDetector(
                                     child: CircleAvatar(backgroundColor: Colors.cyan,child: Icon(Icons.camera_alt,color: Colors.white),),
                                   onTap: () {
                                     showModalBottomSheet(
                                         backgroundColor: Colors.white,
                                         shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.only(
                                             topLeft: Radius.circular(25.0),
                                             topRight: Radius.circular(25.0),
                                           ),
                                         ),
                                         isScrollControlled: true,
                                         context: context,
                                         builder: (context) {
                                           return Padding(
                                             padding: const EdgeInsets.all(15.0),
                                             child: Column(
                                               mainAxisSize: MainAxisSize.min,
                                               children: [
                                                 defaultprofilebuttons(text: 'تغيير الصوره الشخصية', icon: CupertinoIcons.camera, function: (){
                                                   app.getprofileimage().then((value) {
                                                     app.uploadprofileimage();
                                                     navigateTo(context, home());
                                                   });
                                                 }),
                                                 defaultprofilebuttons(text: 'ازاله الصوره الشخصية', icon: Icons.highlight_remove, function: (){
                                                   app.edituserdata(profileimage: '').then((value) {
                                                     navigateTo(context, home());
                                                   });
                                                 }),
                                               ],
                                             ),
                                           );
                                         });
                                   },
                                 ),
                               ),
                             ],
                           ),
                         ),
                         Padding(
                           padding: EdgeInsets.only(left: 8,right: 8),
                           child: Text('${constusers.name}',style: TextStyle(fontSize: 30)),
                         ),
                         Visibility(
                           visible: showaccdetails,
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Column(
                               children: [
                                 Text('ID : ${constusers.id}',style: TextStyle(fontSize: 20)),
                                 Text('${constusers.email}',style: TextStyle(fontSize: 20)),
                                 Text('${constusers.phone}',style: TextStyle(fontSize: 20)),
                                 Text('${constusers.birth} : تاريخ الميلاد',style: TextStyle(fontSize: 20)),
                                 Text('${constusers.address} : العنوان ',style: TextStyle(fontSize: 20)),
                               ],
                             ),
                           ),
                         ),
                         Visibility(
                           visible: uid!='',
                           child: MaterialButton(
                             elevation: 0,
                             focusElevation: 0,
                             disabledElevation: 0,
                             highlightElevation: 0,
                             splashColor: Colors.transparent,
                             animationDuration: Duration.zero,
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight:Radius.circular(15) ,bottomLeft: Radius.circular(15))),
                             color: Colors.amber,
                             onPressed: (){
                               setState(() {
                                 showaccdetails=!showaccdetails;
                               });
                             },
                             child: Container(
                               padding: EdgeInsets.all(15),
                               width: double.infinity,
                               child: Text(!showaccdetails?'اظهار المعلومات الشخصية':'اخفاء المعلومات الشخصية',textAlign: TextAlign.center,style: TextStyle(fontSize: 15)),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: 15,),
                   defaultprofilesettings(
                       disable: uid=='',
                       visible: false,
                       underwidgets: [],
                       text: 'الرحلات المحفوظة ',
                       begicon: Icons.bookmark_border,
                       ontap: (){
                         navigateTo(context, savedtrips());
                       }),
                   SizedBox(height: 15,),
                   defaultprofilesettings(
                       disable: uid=='',
                       visible: false,
                       underwidgets: [],
                       text: 'سجل رحلاتي ',
                       begicon: Icons.history_outlined,
                       ontap: (){

                       }),
                   //SizedBox(height: 15,),
                   // defaultprofilesettings(
                   //   isactive: uid==''?false:true,
                   //   text: 'حسابي ',
                   //   visible: accountvisible,
                   //   begicon: Icons.account_circle_outlined,
                   //   ontap: () {
                   //     setState(() {
                   //       accountvisible=!accountvisible;
                   //     });
                   //   },
                   //   underwidgets:
                   //   [
                   //
                   //     Row(
                   //       textDirection: TextDirection.rtl,
                   //       children: [
                   //         Text('الاسم بالكامل'),
                   //         Spacer(),
                   //         Text('${constusers.name}'),
                   //       ],
                   //     ),
                   //     Row(
                   //       textDirection: TextDirection.rtl,
                   //       children: [
                   //         Text('البريد الالكتروني'),
                   //         Spacer(),
                   //         Text('${constusers.email}'),
                   //       ],
                   //     ),
                   //     Row(
                   //       textDirection: TextDirection.rtl,
                   //       children: [
                   //         Text('رقم الهاتف'),
                   //         Spacer(),
                   //         Text('${constusers.phone}'),
                   //
                   //       ],
                   //     ),
                   //     Row(
                   //       textDirection: TextDirection.rtl,
                   //       children: [
                   //         Text('تاريخ الميلاد'),
                   //         Spacer(),
                   //         Text('${constusers.birth}'),
                   //
                   //
                   //       ],
                   //     ),
                   //     Row(
                   //       textDirection: TextDirection.rtl,
                   //       children: [
                   //         Text('العنوان'),
                   //         Spacer(),
                   //         Text('${constusers.address}'),
                   //
                   //       ],
                   //     ),
                   //   ] ,
                   // ),
                   SizedBox(height: 15,),
                   defaultprofilesettings(
                     disable: uid=='',
                     isactive: uid==''?false:true,
                     text: 'تحديث بيانات الحساب ',
                     visible: dataeditvisible,
                     begicon: Icons.update_outlined,
                     ontap: () {
                       setState(() {
                         dataeditvisible=!dataeditvisible;
                       });
                     },
                     underwidgets:
                     [
                       defaultprofilebuttons(text: 'تغيير الاسم', icon: Icons.perm_identity, function: (){
                         navigateTo(context, editaccount('changename'));
                       }),
                       defaultprofilebuttons(text: 'تحديث رقم الهاتف', icon: Icons.local_phone_outlined, function: (){
                         navigateTo(context, editaccount('changenumber'));
                       }),
                       defaultprofilebuttons(text: 'تحديث العنوان', icon: Icons.house_outlined, function: (){
                         navigateTo(context, editaccount('changeaddress'));
                       }),
                       defaultprofilebuttons(text: 'تغيير تاريخ الميلاد', icon: Icons.date_range_outlined, function: (){
                         navigateTo(context, editaccount('changebirth'));
                       }),
                     ] ,
                   ),
                   SizedBox(height: 15,),
                   defaultprofilesettings(
                     disable: uid=='',
                     isactive: uid==''?false:true,
                     text: 'الامان والخصوصيه ',
                     visible: securityvisible,
                     begicon: Icons.lock_outline,
                     ontap: () {
                       setState(() {
                         securityvisible=!securityvisible;
                       });
                     },
                     underwidgets:
                     [
                       defaultprofilebuttons(text: 'تغيير كلمه المرور', icon: Icons.password, function: (){
                         navigateTo(context, editaccount('changepassword'));
                       }),
                       defaultprofilebuttons(text: 'تغيير البريد الالكتروني', icon: Icons.email_outlined, function: (){
                         navigateTo(context, editaccount('changeemail'));
                       }),
                     ] ,
                   ),
                   SizedBox(height: 15,),
                   defaultprofilesettings(
                     text: 'المساعده والدعم ',
                     visible: helpvisible,
                     begicon: Icons.support,
                     ontap: () {
                       setState(() {
                         helpvisible=!helpvisible;
                       });
                     },
                     underwidgets:
                     [
                       defaultprofilebuttons(text: 'الابلاغ عن مشكله', icon: Icons.error_outline, function: (){}),
                       defaultprofilebuttons(text: 'الشروط والسياسات', icon: Icons.book_outlined, function: (){}),
                     ] ,
                   ),
                   SizedBox(height: 15,),
                   defaultprofilesettings(
                     text: 'التواصل معنا ',
                     visible: contactusvisible,
                     begicon: Icons.local_phone_outlined,
                     ontap: () {
                       setState(() {
                         contactusvisible=!contactusvisible;
                       });
                     },
                     underwidgets:
                     [
                       defaultprofilebuttons(text: 'البريد الالكتروني الخاص بنا', icon: Icons.alternate_email_outlined, function: (){}),
                       defaultprofilebuttons(text: 'ارقامنا', icon: Icons.numbers, function: (){}),
                     ] ,
                   ),
                   SizedBox(height: 15,),
                   defaultprofilesettings(
                     text: 'الاعدادات ',
                     visible: settingsvisible,
                     begicon: Icons.settings,
                     ontap: () {
                       setState(() {
                         settingsvisible=!settingsvisible;
                       });
                     },
                     underwidgets:
                     [
                       Row(
                         textDirection: TextDirection.rtl,
                         children: [
                           Icon(Icons.notifications_none_outlined),
                           Text('الاشعارات',style: TextStyle(fontSize: 20),),
                           Spacer(),
                           Switch(value: isnotificationactive, onChanged: (value) {
                             setState(() {
                               isnotificationactive=value;
                             });
                           },)
                         ],
                       ),
                       Row(
                         textDirection: TextDirection.rtl,
                         children: [
                           Icon(Icons.dark_mode_outlined),
                           Text('الوضع المظلم',style: TextStyle(fontSize: 20),),
                           Spacer(),
                           Switch(value: isdarkmodeactive, onChanged: (value) {
                             setState(() {
                               isdarkmodeactive=value;
                             });
                           },)
                         ],
                       ),
                     ] ,
                   ),
                   SizedBox(height: 15,),
                   defaultprofilesettings(
                     visible: false,
                     underwidgets: [],
                     begicon:uid!=''? Icons.logout:Icons.login_outlined,
                     text: uid!=''?'تسجيل الخروج ':'تسجيل الدخول ',
                     ontap: () {
                       setState(() {
                         uid!=''?
                         showDialog(
                           context: context,
                           builder: (BuildContext context) {
                             return CupertinoAlertDialog(
                               title: Text('تسجيل الخروج'),
                               content: Text('هل انت متأكد انك تريد تسجيل الخروج'),
                               actions: [
                                 CupertinoDialogAction(
                                   child: Text('نعم'),
                                   onPressed: () {
                                     app.userlogout(context);
                                   },
                                 ),
                                 CupertinoDialogAction(
                                   child: Text('الرجوع'),
                                   onPressed: () {
                                     Navigator.of(context).pop(); // Close the dialog
                                   },
                                 ),
                               ],
                             );
                           },
                         ):navigateTo(context,login_register_home());
                       });
                     },
                   ),
                 ],
               ),
             ),
           ),
         );
       },
      ),
    );
  }
}
