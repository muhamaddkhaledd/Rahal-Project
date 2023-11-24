class loginmodel
{
   bool? status;
   String? message;
   userdata? data;
  loginmodel.fromjson(Map<String,dynamic> json)
  {
    status=json['status'];
    message=json['message'];
    if (json['data'] != null)
    {
      try {
        data = userdata.fromjson(json['data']);
      } catch (e) {
        // If an error occurs while parsing userdata, set data to null.
        print('Error while parsing userdata: $e');
        data = null;
      }
    }
    else {
      data = null;
    }
  }

}


class userdata
{
   String? id;
   String? name;
   String? email;
   String? phone;
   String? image;
   String? points;
   String? credit;
   String? token;
  userdata.fromjson(Map<String,dynamic> json)
  {

     id=json['id'].toString();
     name=json['name'];
     email=json['email'];
     phone=json['phone'];
     image=json['image'];
     points=json['points'].toString();
     credit=json['credit'].toString();
     token=json['token'];
  }
}