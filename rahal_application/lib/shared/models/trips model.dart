import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class tripsmodel
{
  String? id ;
  String? name;
  String? location;
  Timestamp? date;
  int? price;
  String? meetingplace;
  String? movingtimes;
  String? meetingaddress;
  String? triporganizer;
  String? tripprogram;
  int? seats;
  List<dynamic>? images;
  GeoPoint? googlemaps;
  String? triptype;

  List<dynamic>? orginizersphones;
  Map<String,dynamic>? orginizerssocial;
  int? childage;
  int? childpay;
  List<dynamic>? placesvisit;
  int? nights;
  String? hotelorvillagename;//can be null
  int? hotelstars; //can be null
  List<dynamic>? roomtypes; //can be null
  List<dynamic>? meals;
  String? tripplaceaddress;
  List<dynamic>? services;//can be null
  String? moretripdetails; //can be null

  tripsmodel.fromjson(Map<String,dynamic> json)
  {
    id= json['id'];
    name = json['name'];
    date = json['date'];
    price = json['price'];
    location = json['location'];
    meetingplace = json['meetingplace'];
    movingtimes = json['movingtimes'];
    meetingaddress = json['meetingaddress'];
    triporganizer = json['triporganizer'];
    tripprogram = json['tripprogram'];
    seats = json['seats'];
    images = json['images'];
    googlemaps=json['googlemaps'];
    triptype = json['triptype'];

    orginizersphones = json['orginizersphones'];
    orginizerssocial = json['orginizerssocial'];
    childage = json['childage'];
    childpay = json['childpay'];
    placesvisit = json['placesvisit'];
    nights = json['nights'];
    hotelorvillagename = json['hotelorvillagename'];
    hotelstars = json['hotelstars'];
    roomtypes = json['roomtypes'];
    meals = json['meals'];
    tripplaceaddress = json['tripplaceaddress'];
    services = json['services'];
    moretripdetails = json['moretripdetails'];
  }
  tripsmodel({
    this.id,
    this.name,
    this.location,
    this.date,
    this.price,
    this.meetingplace,
    this.movingtimes,
    this.meetingaddress,
    this.triporganizer,
    this.tripprogram,
    this.images,
    this.googlemaps,
    this.triptype,
    this.orginizersphones,
    this.orginizerssocial,
    this.childage,
    this.childpay,
    this.placesvisit,
    this.nights,
    this.hotelorvillagename,
    this.hotelstars,
    this.roomtypes,
    this.meals,
    this.tripplaceaddress,
    this.services,
    this.moretripdetails,
});
}