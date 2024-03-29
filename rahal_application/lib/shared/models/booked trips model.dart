import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rahal_application/shared/models/trips%20model.dart';

class bookedtripmodel
{
  String?username;
  String?userid;
  String?useremail;
  String?userphone;
  String?tripbookedid;
  Map<String,dynamic>? tripbookeddata;
  Timestamp? timebooked;
  List<dynamic>? companionsdata;
  int? companionsnumbers;
  bool? isvisa;
  bool? paymentsuccess;
  double? totalprice;
  bool? canceltriprequest;
  tripsmodel? model=tripsmodel();
  String? canceltripid;
  double? coupon;
  int? discountedmoney;
  String? bookingid;
  bookedtripmodel({
    this.username,
    this.userid,
    this.useremail,
    this.userphone,
    this.tripbookedid,
    this.tripbookeddata,
    this.timebooked,
    this.companionsdata,
    this.companionsnumbers,
    this.isvisa,
    this.paymentsuccess,
    this.totalprice,
    this.model,
    this.canceltriprequest,
    this.canceltripid,
    this.coupon,
    this.discountedmoney,
    this.bookingid,
});
  bookedtripmodel.fromjson(Map<String,dynamic> json)
  {
    username=json['username'];
    userid=json['userid'];
    useremail=json['useremail'];
    userphone=json['userphone'];
    tripbookedid=json['tripbookedid'];
    tripbookeddata=json['tripbookeddata'];
    timebooked=json['timebooked'];
    companionsdata=json['companionsdata'];
    companionsnumbers=json['companionsnumbers'];
    isvisa=json['isvisa'];
    paymentsuccess=json['paymentsuccess'];
    totalprice=json['totalprice'];
    canceltriprequest=json['canceltriprequest'];
    canceltripid = json['canceltripid'];
    coupon= json['coupon'];
    discountedmoney= json['discountedmoney'];
    bookingid = json['bookingid'];
  }

  Map<String,dynamic>tomap()
  {
    return {
      'username': username,
      'userid': userid,
      'useremail': useremail,
      'userphone': userphone,
      'tripbookedid': tripbookedid,
      'tripbookeddata': {
        'id': model?.id,
        'name': model?.name,
        'price': model?.price,
        'date': model?.date,
        'location': model?.location,
        'triptype': model?.triptype,
        'seats': model?.seats,
        'images': model?.images,
        'meetingplace':model?.meetingplace,
        'tripprogram': model?.tripprogram,
        'meetingaddress': model?.meetingaddress,
        'googlemaps': model?.googlemaps,
        'movingtimes': model?.movingtimes,
        'triporganizer': model?.triporganizer,
      },
      'timebooked': timebooked,
      'companionsdata': companionsdata,
      'companionsnumbers': companionsnumbers,
      'isvisa': isvisa,
      'paymentsuccess': paymentsuccess,
      'totalprice': totalprice,
      'canceltriprequest':canceltriprequest,
      'canceltripid':canceltripid,
      'coupon':coupon,
      'discountedmoney':discountedmoney,
      'bookingid':bookingid,
    };
  }


}