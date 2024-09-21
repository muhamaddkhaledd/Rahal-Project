import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class listtripsmodel
{
  String? id ;
  String? name;
  String? location;
  Timestamp? date;
  int? price;
  String? triptype;
  String? meetingplace;
  listtripsmodel.fromjson(Map<String,dynamic> json)
  {
    id= json['id'];
    name = json['name'];
    date = json['date'];
    price = json['price'];
    location = json['location'];
    triptype = json['triptype'];
    meetingplace = json['meetingplace'];
  }
  listtripsmodel({
    this.id,
    this.name,
    this.location,
    this.date,
    this.price,
    this.triptype,
    this.meetingplace,
  });
}