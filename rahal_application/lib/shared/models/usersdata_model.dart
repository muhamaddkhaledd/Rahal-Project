class usersdatafirebase
{
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? password;
  String? birth;
  String? profileimage;
  usersdatafirebase({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.password,
    this.birth,
    this.profileimage,
});
  usersdatafirebase.fromjson(Map<String,dynamic>json)
  {
    id=json['id'];
    name=json['name'];
    email=json['email'];
    phone=json['phone'];
    address=json['address'];
    password=json['password'];
    birth=json['birth'];
    profileimage=json['profileimage'];
  }
  Map<String,dynamic>tomap()
  {
    return {
      'id':id,
      'name':name,
      'email':email,
      'phone':phone,
      'address':address,
      'password':password,
      'birth':birth,
      'profileimage':profileimage
    };
  }
  Map<String,dynamic>edituser(){
    Map<String,dynamic>users= {};
    if(id!=null){
    users.addAll({'id':id});}
    else if(name!=null){
      users.addAll({'name':name});}
    else if(email!=null){
      users.addAll({'email':email});}
    else if(phone!=null){
      users.addAll({'phone':phone});}
    else if(address!=null){
      users.addAll({'address':address});}
    else if(password!=null){
      users.addAll({'password':password});}
    else if(birth!=null){
      users.addAll({'birth':birth});}
    else if(profileimage!=null){
      users.addAll({'profileimage':profileimage});}

    return users;
  }

}