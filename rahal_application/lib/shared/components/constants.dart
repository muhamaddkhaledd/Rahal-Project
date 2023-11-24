import 'package:rahal_application/shared/network/local/cache_helper.dart';

import '../models/usersdata_model.dart';

List<Map> data = [];
String uid =cachehelper.getshareddata(key: 'uid') ?? '';


usersdatafirebase constusers = usersdatafirebase();

String orderkey='id';
bool decending=true;
String orderkeyname='افتراضي';
List<String> placeses =[
  'العين السخنه',
  'القاهره',
  'الاسكندريه',
  'الجيزه',
  'الغردقه',
  'الساحل الشمالي',
  'دهب',
  'شرم الشيخ',
  'الجونه',
  'مرسي علم',
  'مرسي مطروح',
  'العلمين',
];
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
    decending=true;
  }
  else if(sort=='الموعد من الابعد الي الاحدث')
  {
    orderkey='';
    decending=true;
  }


}



class apiconstants
{
  //https://accept.paymob.com/api/auth/tokens
  static const String baseurl = 'https://accept.paymob.com/api';
  static const String getauthtoken='/auth/tokens';
  static const String paymentapikey='ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T0RneU5USTBMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuaEJsQTZDZW5aZTF0dW5FZk12emdjVXdEX1pVZkluenBacnlFT3BtWWI4QkdHc1pZaEVCS3NqcGpOeGVEVUVUT2FoejRha0tsdERackdQMjhCeWtCa2c=';
  static const String getorderid='/ecommerce/orders';
  static const String getpaymentid='/acceptance/payment_keys';
  static const String getrefcode='/acceptance/payments/pay';
  static String paymentfristtoken='';
  static String paymentorderid='';
  static String finaltoken='';
  static String refcode='';

  static String integrationidkiosk='4121437';
  static String integrationidkcart='4118208';
}