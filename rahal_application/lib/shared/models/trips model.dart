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
});
}