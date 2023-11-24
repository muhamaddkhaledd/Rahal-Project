class favtripsmodel
{
String? id;
String? name;
String? location;

favtripsmodel.fromjson(Map <String,dynamic> json)
{
  id=json['id'];
  name=json['name'];
  location=json['location'];
}
}