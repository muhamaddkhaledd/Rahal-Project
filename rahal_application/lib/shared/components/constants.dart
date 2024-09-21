import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rahal_application/shared/network/local/cache_helper.dart';

import '../models/booked trips model.dart';
import '../models/usersdata_model.dart';

List<Map> data = [];
String uid =cachehelper.getshareddata(key: 'uid') ?? '';

int limittrips=15;
usersdatafirebase constusers = usersdatafirebase();

String orderkey='id';
bool decending=true;
String orderkeyname='افتراضي';

List<dynamic> placeses =[
  'القاهرة',
  'العين السخنة',
  'الاسكندرية',
  'الجيزة',
  'الغردقة',
  'الساحل الشمالي',
  'دهب',
  'شرم الشيخ',
  'الجونة',
  'مرسي علم',
  'مرسي مطروح',
  'العلمين',
  'سيوة',
  'الفيوم',
  'الاقصر',
  'اسوان',
];
List<dynamic> egyptGovernments = [
  'القاهرة',
  'الإسكندرية',
  'الجيزة',
  'المنيا',
  'القليوبية',
  'البحر الأحمر',
  'الشرقية',
  'الغربية',
  'الدقهلية',
  'كفر الشيخ',
  'أسوان',
  'أسيوط',
  'الفيوم',
  'بني سويف',
  'سوهاج',
  'قنا',
  'شمال سيناء',
  'جنوب سيناء',
  'الوادي الجديد',
  'مطروح',
  'البحيرة',
  'الإسماعيلية',
];
List<dynamic> triptypes=[
  'رحلات تاريخية',
  'رحلات للشواطئ',
  'رحلات نيلية',
  'رحلات دينية',
  'رحلات ثقافية',
  'رحلات ترفيهية',
  'رحلات للتنزه',
  'رحلات متنوعة',
];

List<dynamic> contactemails=[];
List<dynamic> contactphonenumbers=[];

// List<String> triptypes=[
//   'رحلات تاريخي',
//   'رحلات للشواطئ',
//   'رحلات نيلي',
//   'رحلات ديني',
//   'رحلات ثقافي',
//   'رحلات ترفيهي',
//   'رحلات للتنزه',
//   'رحلات متنوع',
// ];
// List<String> placeses =[
//   'العين السخنه',
//   'القاهره',
//   'الاسكندريه',
//   'الجيزه',
//   'الغردقه',
//   'الساحل الشمالي',
//   'دهب',
//   'شرم الشيخ',
//   'الجونه',
//   'مرسي علم',
//   'مرسي مطروح',
//   'العلمين',
// ];
// List<String> egyptGovernments = [
//   'كل المحافظات',
//   'القاهر',
//   'الإسكندري',
//   'الجيز',
//   'المنيا',
//   'القليوبي',
//   'البحر الأحمر',
//   'الشرقي',
//   'الغربي',
//   'الدقهلي',
//   'كفر الشيخ',
//   'أسوان',
//   'أسيوط',
//   'الفيوم',
//   'بني سويف',
//   'سوهاج',
//   'قنا',
//   'شمال سيناء',
//   'جنوب سيناء',
//   'الوادي الجديد',
//   'مطروح',
//   'البحير',
//   'الإسماعيلي',
// ];

List<String> locations=[];
List<String> governments=[];
List<bool> locpress=[];
void selectsort({
  String? sort,
})
{
  if(sort=='افتراضي')
  {
    orderkey='id';
    decending=true;
  }
  else if(sort=='السعر من الاقل الي الاكثر')
  {
    orderkey='price';
    decending=false;
  }
  else if(sort=='السعر من الاكثر الي الاقل')
  {
    orderkey='price';
    decending=true;
  }
  else if(sort=='الموعد من الاحدث الي الابعد')
  {
    orderkey='date';
    decending=false;
  }
  else if(sort=='الموعد من الابعد الي الاحدث')
  {
    orderkey='date';
    decending=true;
  }


}

//--filter trips types sort variables :
String orderkey2='id';
bool decending2=true;
String orderkeyname2='افتراضي';
String governmentkey='كل المحافظات';
String governmentkey2='كل المحافظات';
List<String> locations2=[];
List<String> governments2=[];
List<bool> locpress2=[];
void selectsort2({
  String? sort,
})
{
  if(sort=='افتراضي')
  {
    orderkey2='id';
    decending2=true;
  }
  else if(sort=='السعر من الاقل الي الاكثر')
  {
    orderkey2='price';
    decending2=false;
  }
  else if(sort=='السعر من الاكثر الي الاقل')
  {
    orderkey2='price';
    decending2=true;
  }
  else if(sort=='الموعد من الاحدث الي الابعد')
  {
    orderkey2='date';
    decending2=true;
  }
  else if(sort=='الموعد من الابعد الي الاحدث')
  {
    orderkey2='date';
    decending2=false;
  }


}
// date2 = json['date'];
// DateTime? dat = date2?.toDate();
// date = dat!=null?DateFormat('dd-MM-yyyy').format(dat):null;
String? convertdateformat(Timestamp? time){
  DateTime? date = time?.toDate();
   return date!=null?DateFormat('dd-MM-yyyy').format(date):null;
}
String? convertdatetimeformat(Timestamp? time){
  DateTime? date = time?.toDate();
  return date!=null?DateFormat('dd-MM-yyyy HH:mm:ss').format(date):null;
}
String agedetector(String age){
  if(age=='adult')
    return 'بالغ';
  else
    return 'طفل';
}

//--end of filter trips types sort



class apiconstants
{
  //https://accept.paymob.com/api/auth/tokens
  static const String baseurl = 'https://accept.paymob.com/api';
  static const String getauthtoken='/auth/tokens';
  static const String paymentapikey="ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T0RneU5USTBMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuaEJsQTZDZW5aZTF0dW5FZk12emdjVXdEX1pVZkluenBacnlFT3BtWWI4QkdHc1pZaEVCS3NqcGpOeGVEVUVUT2FoejRha0tsdERackdQMjhCeWtCa2c=";
  static const String getorderid='/ecommerce/orders';
  static const String getpaymentid='/acceptance/payment_keys';
  static const String getrefcode='/acceptance/payments/pay';
  static String paymentfristtoken='';
  static String paymentorderid='';
  static String finaltoken='';
  static String refcode='';

  static String integrationidkiosk="4121437";
  static String integrationidkcart="4118208";
}

void printLongString(String longString) {
  final int chunkSize = 100; // Adjust the chunk size as needed
  int offset = 0;

  while (offset < longString.length) {
    final String chunk = longString.substring(offset, offset + chunkSize);
    print(chunk);
    offset += chunkSize;
  }
}

List<bookedtripmodel> constsavedtrips = [];