import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/login%20and%20register%20homepage.dart';
import 'package:rahal_application/shared/components/components.dart';
import 'package:rahal_application/shared/cubit/states.dart';
import 'package:rahal_application/shared/models/login_model.dart';
import 'package:rahal_application/shared/models/trips%20model.dart';
import 'package:rahal_application/shared/models/usersdata_model.dart';
import 'package:rahal_application/shared/network/local/cache_helper.dart';
import 'package:rahal_application/shared/network/remote/dio_helper.dart';
import '../components/constants.dart';
import '../models/trips model.dart';
import '../network/dbdata.dart';
import 'package:firebase_storage/firebase_storage.dart';
class appcubit extends Cubit<appstates> {
  appcubit() :super (initialstate()){
    readdata();

  }
  //local database section
  static appcubit get(context) => BlocProvider.of(context);
  Sqldb sqldata = Sqldb();
  loginmodel? logindata;
  void readdata(){
    sqldata.readData("SELECT * FROM 'data'").then((value) { data = value;print(data);});
    emit(sqlreadstate());
  }
  void insertdbase(String name){
    sqldata.insertData("INSERT INTO 'data' ('name') VALUES('${name}')");
    emit(sqlinsertstate());
    readdata();
    print('data added');
  }
  //--end of local database section--
  //data with api section

  void userlogin({
  required String email,
  required String password,
  })
   {
     emit(loginloading());

    diohelper.postdata(
        url: 'login',
        data: {
         'email':email,
         'password':password,
        }).then((value) {
          print(value.data);
          logindata = loginmodel.fromjson(value.data);
          print(logindata?.data?.name);

        //emit(loginsucess());
        }

    ).catchError((error){
      emit(loginerror(error.toString()));
    });
   }

  //--end of data with api section--


  //--the start of data with firebase section--:
  void userfirebaselogin({
  required String email,
  required String password
})
  {
    emit(loginloading());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
    .then((value) {
      print(value.user?.phoneNumber);
      emit(loginsucess(value.user?.uid));
    }).catchError((error){
      emit(loginerror(error.toString()));
    });
  }

  Future<void> userfirebaseregister({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
    required String? birth,
    required String? profileimage,
})
  async {
    emit(registerloading());
   await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
    .then((value) {
      usercreatedata(id: value.user!.uid, name: name, email: email, phone: phone, address: address,password: password,birth: birth, profileimage: profileimage);
      print(value);
    }).catchError((error){
      registererror(error.toString());
    });
  }
  void usercreatedata({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
    required String? birth,
    required String? profileimage,
})
  {
    usersdatafirebase model=usersdatafirebase(
      id: id,
      name: name,
      email: email,
      phone: phone,
      address: address,
      password :password,
      birth: birth,
      profileimage: birth,
    );
    print('user data start');
    FirebaseFirestore.instance
    .collection('users')
    .doc(id)
    .set(model.tomap())
    .then((value) {
      print('sucessss');
      emit(usercreatedatasucess());
    }).catchError((error)
    {
      emit(usercreatedataerror(error.toString()));
    });
  }
  void getuserdatafirebase()
  {

    if(uid!='') {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((value) {
        constusers = usersdatafirebase.fromjson(value.data()!);
        print(value.data());
      }).catchError((error) {
        emit(getdatafirebaseerror(error.toString()));
      });
    }
    else{
      constusers = usersdatafirebase(name: 'Guest',id: '');
    }
  }


  tripsmodel? model;
  List<tripsmodel> datass=[];
  DocumentSnapshot?  documentSnapshot;
  bool showmore=true;
  bool isactive=true;
  void gettripsdatafirebase({
    int? limit,
    List<String>? locations,
    List<String>? governments,
    required String orderkey,
    required bool descending,
  })async
  {
    if (documentSnapshot==null) {
      emit(gettripsdatafirebaseloading());
      Query query = FirebaseFirestore.instance.collection('trips');
      if (locations != null && locations.isNotEmpty) {
      query = query.where('location', whereIn: locations);
      }
      //query = query.where('price',isGreaterThanOrEqualTo: 0,isLessThanOrEqualTo: 50,);
      query = query.orderBy(orderkey, descending: descending);
      query.limit(limit!).get().then((value) {
        if (value.docs.isEmpty) {
          showmore=false;
          emit(gettripsdatafirebasesucess());
        }
        //json code here
        value.docs.forEach((element) {
          final data = element.data() as Map<String, dynamic>;
          datass.add(tripsmodel.fromjson(data));
          documentSnapshot = value.docs.last;
          print('the doc is :${documentSnapshot!.data()}');
          if(datass.length<limit){
            showmore=false;
          }
          else{
            showmore=true;
          }
          emit(gettripsdatafirebasesucess());
        });
      }).catchError((error) {
        emit(gettripsdatafirebaseerror(error.toString()));
      });
    }

    else {
      emit(loadmoredatafirebaseloading());
      Query query = FirebaseFirestore.instance.collection('trips').limit(limit!);
        if (locations != null && locations.isNotEmpty) {
          query = query.where('location', whereIn: locations);
         }
         query = query.orderBy(orderkey, descending: descending);
         query.startAfterDocument(documentSnapshot!).get().then((value) {
           if (value.docs.isEmpty) {
             emit(gettripsdatafirebasesucess());
           }
        //json code here
        value.docs.forEach((element) {
         final data = element.data() as Map<String, dynamic>;
          datass.add(tripsmodel.fromjson(data));
          documentSnapshot = value.docs.last;
          print('the doc is :${documentSnapshot!.data()}');

           FirebaseFirestore.instance
              .collection('trips')
              .where('location',whereIn: locations!.isNotEmpty?locations:null)

              .orderBy(orderkey,descending: descending)
              .startAfterDocument(documentSnapshot!)
              .get()
              .then((value) {
                print(value);
            if(value.docs.isEmpty){
              print('empty');
              showmore=false;
              emit(loadmoredatafirebasesucess());
              emit(gettripsdatafirebasesucess());
            }
          });
          emit(gettripsdatafirebasesucess());

        });
      })
          .catchError((error) {
        emit(gettripsdatafirebaseerror(error.toString()));
      });
    }

  }

  tripsmodel? modelid;
  Future<void> gettripdata(String id)async
  {
    emit(gettripdataloading());
   await FirebaseFirestore.instance
        .collection('trips')
        .doc(id)
        .get()
        .then((value) {
          modelid=tripsmodel.fromjson(value.data()!);
      emit(gettripdatasucess());
    }).catchError((error){
      emit(gettripdataerror(error.toString()));
    });

  }


  Future<void> edituserdata({
     String? name,
     String? email,
     String? phone,
     String? address,
     String? password,
    String? birth,
    String? profileimage,
})
  async {
    emit(edituserdatafirebaseloading());
    usersdatafirebase user = usersdatafirebase(name: name,email: email,phone: phone,address: address,password: password,birth: birth,profileimage:profileimage );

    User? users = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: users!.email!,
        password: constusers.password!, // Replace with user's current password
      );
      await users.reauthenticateWithCredential(credential);
    }
    if(email!=null){
      FirebaseAuth.instance.currentUser?.updateEmail(email).then((value) {});
    }
    else if(password!=null){
      FirebaseAuth.instance.currentUser?.updatePassword(password).then((value) {});
    }

    FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .update(user.edituser())
    .then((value) {
      emit(edituserdatafirebasesucess());
    }).catchError((error){
      emit(edituserdatafirebaseerror(error.toString()));
    });
  }

  bool emailExists = false;
  Future<void> checkEmailExists(String email) async {
    try {
      final userCredential = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (userCredential != null && userCredential.isNotEmpty) {
          emailExists = true;
      } else {
          emailExists = false;
      }
    } catch (e) {
      print("Error checking email existence: $e");
    }
  }
  double? offer;
  Future<void> coupouncheck(String coupoun)async
  {
    emit(coupouncheckloading());
    await FirebaseFirestore.instance
        .collection('coupons')
        .doc('1')
        .get()
        .then((value) {
        offer=value.data()![coupoun];
        emit(coupounchecksucess());
    }).catchError((error){
      emit(coupouncheckerror(error.toString()));
    });
  }

  void userlogout(BuildContext context)
  {
    emit(userlogoutloading());
    FirebaseAuth.instance
    .signOut()
    .then((value){
      uid ='';
      cachehelper.saveshareddata(key: 'uid', value: uid);
      print(cachehelper.getshareddata(key: 'uid'));
      navigateTo(context, home());
      print(uid);
      emit(userlogoutsucess());
    })
    .catchError((error){
      emit(userlogouterror(error.toString()));
    });
  }

  Future<void> setfavourites()async
  {

  }


  List<dynamic> ids = [];

  void getfeatured()async
  {
    emit(getfeaturedloading());
    await FirebaseFirestore.instance
    .collection('home')
    .doc('featured')
    .get()
    .then((value) {
      value.data()!['id'].forEach((element) {
        getfeatureddata(element).then((value) {
          print('data $element');
        });
        print(element);
        emit(getfeaturedsucess());
      });
      print(ids);

    }).catchError((error){
      emit(getfeaturederror(error.toString()));
    });
  }
  List<tripsmodel> featuredtrips=[];
  Future<void> getfeatureddata(String id)async
  {
    emit(getfeatureddataloading());
    await FirebaseFirestore.instance
        .collection('trips')
        .doc(id)
        .get()
        .then((value) {
      featuredtrips.add(tripsmodel.fromjson(value.data()!));
      emit(getfeatureddatasucess());
    }).catchError((error){
      emit(getfeatureddataerror(error.toString()));
    });

  }
  //section of saved trips for firebase
  List<tripsmodel> fav = [];
  Future<void> getfavourites() async {
    String idss = '';
    emit(getfavouritesloading());
    try {
      final favoriteDocs = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favourites')
          .get();

      // Create a list of favorite document IDs
      final favoriteIds = favoriteDocs.docs.map((doc) => doc['id']).toList();

      for (final id in favoriteIds) {
        final tripDoc = await FirebaseFirestore.instance
            .collection('trips')
            .doc(id)
            .get();

        if (tripDoc.exists) {
          fav.add(tripsmodel.fromjson(tripDoc.data()!));
        }
      }
      emit(getfavouritessucess());
    } catch (error) {
      emit(getfavouriteserror(error.toString()));

    }
  }


  void savetrips(tripsmodel model)async
  {
    emit(savetripsloading());
    await FirebaseFirestore.instance.
    collection('users')
    .doc(uid)
    .collection('favourites')
    .doc(model.id)
    .set({
      'id':'${model.id}',
      // 'name':'${model.name}',
      // 'date':'${model.date}',
      // 'location':'${model.location}'
    }).then((value) {
      print('done');
      emit(savetripssucess());
    }).catchError((error){
      emit(savetripserror(error.toString()));
    });
  }

  void removesavetrips(tripsmodel model)async
  {
    emit(removesavetripsloading());
    await FirebaseFirestore.instance.
    collection('users')
        .doc(uid)
        .collection('favourites')
        .doc(model.id)
        .delete()
    .then((value) {
      print('done');
      emit(removesavetripssucess());
    }).catchError((error){
      emit(removesavetripserror(error.toString()));
    });
  }

  bool favbool=false;
  Future<void> isfromfavourates(String id)async{
    emit(isfromfavouratesloading());

    await FirebaseFirestore.instance.
    collection('users')
    .doc(uid)
    .collection('favourites')
    .get()
    .then((value) {
      print(id);
      value.docs.forEach((element) {
        print(element.data()['id']);

        if(element.data()['id']==id){
          favbool=true;
        }
        emit(isfromfavouratesssucess());
      });
    });
  }
  //--end of section of saved trips for firebase--


  List<dynamic> offers=[];
  Future<void> getofferscreen() async
  {
    emit(getofferscreenloading());
    await FirebaseFirestore.instance
    .collection('home')
    .doc('offers')
    .get().then((value) {
      offers=value.data()!['links'];
      print(offers);
      emit(getofferscreensucess());
    }).catchError((error){
      emit(getofferscreenerror(error));
    });
  }



  //the end of data with firebase section--

  //start of picker section--

  File? profileimage;
  ImagePicker picker = ImagePicker();
  Future<void>getprofileimage()async
  {
    final pickedfile=await picker.pickImage(source: ImageSource.gallery);
    if(pickedfile!=null)
    {
      profileimage = File(pickedfile.path);
      emit(getprofileimagesucess());
    }
    else
    {
      emit(getprofileimageerror());
    }

  }
  String? imageprofileurl;
  Future<void> uploadprofileimage()async
  {
    emit(uploadprofileimageloading());
    await FirebaseStorage.instance.
    ref().
    child('profile pictures/${constusers.id}').
    putFile(profileimage!).
    then((value) {
      value.ref.getDownloadURL().
      then((value) {
        print(value);
        edituserdata(profileimage: value).then((value) {});
        imageprofileurl=value;
        emit(uploadprofileimagesucess());
      }).catchError((error){
        emit(uploadprofileimageerror(error.toString()));
      });
    });
  }




  //start of picker section--

 //start of payment section--

 Future<void> getauthtoken()
 async {
   emit(paymentloading());
   diohelper.postdata(url: apiconstants.getauthtoken,
       data: {
     "api_key":apiconstants.paymentapikey,
       }).then((value) {
         apiconstants.paymentfristtoken = value.data['token'];
         print('the token is :${apiconstants.paymentfristtoken}');
         emit(paymentsucess());
   }).catchError((error){
     emit(paymenterror(error.toString()));
   });
 }
Future getorderid({
  required String name,
  required String email,
  required String phone,
  required String price,
})async
{
  emit(getorderidloading());
  diohelper.postdata(url: apiconstants.getorderid,
      data: {
        "auth_token":  apiconstants.paymentfristtoken,
        "delivery_needed": "false",
        "amount_cents": price,
        "currency": "EGP",
        "items": [],

      }).then((value) {
        apiconstants.paymentorderid=value.data['id'].toString();
        print(apiconstants.paymentorderid);
        getpaymentrequest(name: name, email: email, phone: phone, price: price);
        emit(getorderidsucess());
  }).catchError((error){
    emit(getorderiderror(error.toString()));
  });
}

Future<void> getpaymentrequest({
  required String name,
  required String email,
  required String phone,
  required String price,
})
async {
 emit(getpaymentrequestloading());
 diohelper.postdata(
     url: apiconstants.getpaymentid,
     data: {
       "auth_token": apiconstants.paymentfristtoken,
       "amount_cents": price,
       "expiration": 3600,
       "order_id": apiconstants.paymentorderid,
       "billing_data": {
         "apartment": "NA",
         "email": email,
         "floor": "NA",
         "first_name": name,
         "street": "NA",
         "building": "NA",
         "phone_number": phone,
         "shipping_method": "NA",
         "postal_code": "NA",
         "city": "NA",
         "country": "NA",
         "last_name": "NA",
         "state": "NA"
       },
       "currency": "EGP",
       "integration_id": apiconstants.integrationidkcart,
       "lock_order_when_paid": "false"
     }).then((value) {
       apiconstants.finaltoken=value.data['token'];
       print('final token :${apiconstants.finaltoken}');
       emit(getpaymentrequestsucess());
 }).catchError((error){
   emit(getpaymentrequesterror(error.toString()));
 });
}

Future<void> getrefcode()
async {
emit(getrefcodeloading());
diohelper.postdata(url: apiconstants.getrefcode,
    data: {
  "source": {
    "identifier": "AGGREGATOR",
    "subtype": "AGGREGATOR"
  },
  "payment_token": apiconstants.finaltoken,
}).then((value) {
  apiconstants.refcode=value.data['id'].toString();
  print('sucess get ref code');
  emit(getrefcodesucess());
}).catchError((error){
  emit(getrefcodeerror(error.toString()));
});
}
 //end of payment section--

  bool connection = true;
  void checkconn()async{
    var conn=await Connectivity().checkConnectivity().then((value) {
      print(value.name);
      if(value.name=='none'){
        connection=false;
        emit(connectionfailedstate());
      }
      else{
        connection=true;
      }
    });
  }
}