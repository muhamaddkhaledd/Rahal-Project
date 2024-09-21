import 'dart:io';
import 'dart:developer';
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
import '../models/booked trips model.dart';
import '../models/listtripsmodel.dart';
import '../models/trips model.dart';
import '../network/dbdata.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
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


  listtripsmodel? model;
  List<listtripsmodel> datass=[];
  DocumentSnapshot?  documentSnapshot;
  bool showmore=true;
  bool isactive=true;
  void gettripsdatafirebase({
    int? limit,
    List<String>? locations,
    String? meetingplace,
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

      if (meetingplace != null && meetingplace != ''&& meetingplace!='كل المحافظات') {
        query = query.where('meetingplace', isEqualTo: meetingplace);
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
          datass.add(listtripsmodel.fromjson(data));
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
        if (meetingplace != null && meetingplace != ''&& meetingplace!='كل المحافظات') {
          query = query.where('meetingplace', isEqualTo: meetingplace);
        }
         query = query.orderBy(orderkey, descending: descending);
         query.startAfterDocument(documentSnapshot!).get().then((value) {
           if (value.docs.isEmpty) {
             emit(gettripsdatafirebasesucess());
           }
        //json code here
        value.docs.forEach((element) {
         final data = element.data() as Map<String, dynamic>;
          datass.add(listtripsmodel.fromjson(data));
          documentSnapshot = value.docs.last;
          print('the doc is :${documentSnapshot!.data()}');
           FirebaseFirestore.instance
              .collection('trips')
              .where('location',whereIn: locations!.isNotEmpty?locations:null)
              .where('meetingplace', isEqualTo:meetingplace!=null&&meetingplace!='كل المحافظات'? meetingplace:null)
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
  bool phoneExists = false;
  Future<void>checkphoneexist(String phone)async{
    await FirebaseFirestore
        .instance
        .collection('users')
        .where('phone',isEqualTo: phone)
        .get().then((value) {
          if(value.docs!=null && value.docs.isNotEmpty){
            phoneExists=true;
            print('exist');
          }
          else{
            phoneExists=false;
            print('not exist');
          }
    });
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
      navigateTo(context, login_register_home());
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
          .orderBy('date',descending: true)
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
    // CollectionReference collectionReference = FirebaseFirestore.instance.collection('users').doc(uid).collection('favourites');
    // QuerySnapshot querySnapshot = await collectionReference.get();
    // int count = querySnapshot.docs.length;
    // print(count);
    await FirebaseFirestore.instance.
    collection('users')
    .doc(uid)
    .collection('favourites')
    .doc(model.id)
    .set({
      'id':'${model.id}',
      'date':FieldValue.serverTimestamp()
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
      emit(getofferscreenerror(error.toString()));
    });
  }

  List<dynamic> placesimages=[];
  Future<void> getplacesimages() async
  {
    emit(getplacesimagesloading());
    await FirebaseFirestore.instance
        .collection('home')
        .doc('places')
        .get().then((value) {
      placesimages=value.data()!['placesimages'];
      emit(getplacesimagessucess());
    }).catchError((error){
      emit(getplacesimageserror(error.toString()));
    });
  }

  List<listtripsmodel> tripsdatatypes=[];
  DocumentSnapshot?  documentSnapshot2;
  bool showmore1=true;
  bool isactive1=true;
  void gettriptypefirebase({
    int? limit,
    List<String>? locations,
    List<String>? governments,
    required String triptype,
    String? meetingplace,
    required String orderkey,
    required bool descending,
  })async
  {
    if (documentSnapshot2==null) {
      emit(gettriptypefirebaseloading());
      Query query = FirebaseFirestore.instance.collection('trips');
      if (locations != null && locations.isNotEmpty) {
        query = query.where('location', whereIn: locations);
      }
      if (meetingplace != null && meetingplace != ''&& meetingplace!='كل المحافظات') {
        query = query.where('meetingplace', isEqualTo: meetingplace);
      }
      if (triptype != null && triptype != '') {
        query = query.where('triptype', isEqualTo: triptype);
      }

      //query = query.where('price',isGreaterThanOrEqualTo: 0,isLessThanOrEqualTo: 50,);
      query = query.orderBy(orderkey, descending: descending);
      query.limit(limit!).get().then((value) {
        if (value.docs.isEmpty) {
          showmore1=false;
          emit(gettripsdatafirebasesucess());
        }
        //json code here
        value.docs.forEach((element) {
          final data = element.data() as Map<String, dynamic>;
          tripsdatatypes.add(listtripsmodel.fromjson(data));
          documentSnapshot2 = value.docs.last;
          print('the doc is :${documentSnapshot2!.data()}');
          if(tripsdatatypes.length<limit){
            showmore1=false;
          }
          else{
            showmore1=true;
          }
          emit(gettriptypefirebasesucess());
        });
      }).catchError((error) {
        emit(gettriptypefirebaseerror(error.toString()));
      });
    }

    else {
      emit(loadmoretriptypefirebaseloading());
      Query query = FirebaseFirestore.instance.collection('trips').limit(limit!);

      if (locations != null && locations.isNotEmpty) {
        query = query.where('location', whereIn: locations);
      }
      if (meetingplace != null && meetingplace != ''&& meetingplace!='كل المحافظات') {
        query = query.where('meetingplace', isEqualTo: meetingplace);
      }
      if (triptype != null && triptype != '') {
        query = query.where('triptype', isEqualTo: triptype);
      }

      query = query.orderBy(orderkey, descending: descending);
      query.startAfterDocument(documentSnapshot2!).get().then((value) {
        if (value.docs.isEmpty) {
          emit(gettriptypefirebasesucess());
        }
        //json code here
        value.docs.forEach((element) {
          final data = element.data() as Map<String, dynamic>;
          tripsdatatypes.add(listtripsmodel.fromjson(data));
          documentSnapshot2 = value.docs.last;
          print('the doc is :${documentSnapshot2!.data()}');
          FirebaseFirestore.instance
              .collection('trips')
              .where('location',whereIn: locations!.isNotEmpty?locations:null)
              .where('meetingplace', isEqualTo:meetingplace!=null&&meetingplace!='كل المحافظات'? meetingplace:null)
              .where('triptype', isEqualTo:triptype!=null? triptype:null)
              .orderBy(orderkey,descending: descending)
              .startAfterDocument(documentSnapshot2!)
              .get()
              .then((value) {
            print(value);
            if(value.docs.isEmpty){
              print('empty');
              showmore1=false;
              emit(loadmoretriptypefirebasesucess());
              emit(gettripsdatafirebasesucess());
            }
          });
          emit(gettriptypefirebasesucess());

        });
      })
          .catchError((error) {
        emit(gettriptypefirebaseerror(error.toString()));
      });
    }

  }


  //the start of the filter elements
  List<dynamic> placeslist=[];
  void getlistdata()async
  {
    emit(getlistdataloading());
    await FirebaseFirestore.instance
        .collection('home')
        .doc('places')
        .get().then((value) {
      print(value['placeslist']);
      placeses=value['placeslist'];
      emit(getlistdatasucess());
    }).catchError((error){
      emit(getlistdataerror(error.toString()));
    });
  }


  void getgovernmentsdata()async
  {
    emit(getgovernmentsdataloading());
    await FirebaseFirestore.instance
        .collection('home')
        .doc('governments')
        .get().then((value) {
      print(value['governmentslist']);
      egyptGovernments = value['governmentslist'];
      emit(getgovernmentsdatasucess());
    }).catchError((error){
      emit(getgovernmentsdataerror(error.toString()));
    });
  }

  void gettriptypedata()async
  {
    emit(gettriptypedataloading());
    await FirebaseFirestore.instance
        .collection('home')
        .doc('triptypes')
        .get().then((value) {
      print(value['triptype']);
      triptypes=value['triptype'];
      emit(gettriptypedatasucess());
    }).catchError((error){
      emit(gettriptypedataerror(error.toString()));
    });
  }

  String? canceltripreqid;
  Future<void> canceltriprequest(bookedtripmodel model)async{
    emit(canceltriprequestloading());
    String docId = FirebaseFirestore.instance.collection('users').doc().id;
    Map <String,dynamic> data=model.tomap();
    data['tripbookeddata']=model.tripbookeddata;
    data['canceltripid']=docId;
    data['timetripcanceled']=Timestamp.now();
    data['cancelrequestaccept']=false;
    model.canceltriprequest=true;
   await FirebaseFirestore.instance
        .collection('canceltripsrequests')
        .doc(docId)
        .set(data)
        .then((value) async{
      await updatecanceltriprequest(model,docId);

    });
  }

  Future<void>updatecanceltriprequest(bookedtripmodel bookmodel,String canceltripid)async{
   await FirebaseFirestore.instance
        .collection('users')
        .doc('${constusers.id}')
        .collection('bookedtrips')
        .doc('${bookmodel.bookingid}')
        .update({'canceltriprequest':true,'canceltripid':'$canceltripid'}).then((value){
      canceltripreqid=canceltripid;
      emit(canceltriprequestsucess());
      print('doneeeeee');
    });
  }


  Future<void> deletecanceltriprequest(bookedtripmodel model)async{
    emit(deletecanceltriprequestloading());
    model.canceltriprequest=false;
    print('trip cancel id :${model.canceltripid}');
    await FirebaseFirestore.instance
        .collection('canceltripsrequests')
        .doc('${model.canceltripid}')
        .delete().then((value) async{
      await deleteupdatecanceltriprequest(model);
    });
  }

  Future<void>deleteupdatecanceltriprequest(bookedtripmodel bookmodel)async{
   await FirebaseFirestore.instance
        .collection('users')
        .doc('${constusers.id}')
        .collection('bookedtrips')
        .doc('${bookmodel.bookingid}')
        .update({'canceltriprequest':false,'canceltripid':null}).then((value){
      emit(deletecanceltriprequestsucess());
      print('doneeeeee2');
    });
  }

  
  
  List<bookedtripmodel> bookedtripsdata =[];
  DocumentSnapshot?  documentSnapshot3;
  bool showmore3=true;
  bool isactive3=true;
  Future<void> getbookedtripsdata({
    required int limit,
    required bool descending,
  })
  async{
    String orderkey = 'timebooked';
    if(uid!='') {
      if (documentSnapshot3 == null) {
        emit(getbookedtripsdataloading());
        Query query = await FirebaseFirestore.instance.collection('users').doc(
            uid).collection('bookedtrips');


        query = query.orderBy(orderkey, descending: descending);
        query.limit(limit!).get().then((value) {
          if (value.docs.isEmpty) {
            showmore3 = false;
            emit(getbookedtripsdatasucess());
          }
          //json code here
          value.docs.forEach((element) {
            final data = element.data() as Map<String, dynamic>;
            bookedtripsdata.add(bookedtripmodel.fromjson(data));
            documentSnapshot3 = value.docs.last;
            print('the doc is :${documentSnapshot3!.data()}');
            if (bookedtripsdata.length < limit) {
              showmore3 = false;
            }
            else {
              showmore3 = true;
            }
            emit(getbookedtripsdatasucess());
          });
        }).catchError((error) {
          emit(getbookedtripsdataerror(error.toString()));
        });
      }
      else {
        emit(loadmorebookedtripsdataloading());
        Query query = await FirebaseFirestore.instance.collection('users').doc(
            uid).collection('bookedtrips').limit(limit!);

        query = query.orderBy(orderkey, descending: descending);
        query.startAfterDocument(documentSnapshot3!).get().then((value) {
          if (value.docs.isEmpty) {
            emit(getbookedtripsdatasucess());
          }
          //json code here
          value.docs.forEach((element) async {
            final data = element.data() as Map<String, dynamic>;
            bookedtripsdata.add(bookedtripmodel.fromjson(data));
            documentSnapshot3 = value.docs.last;
            print('the doc is :${documentSnapshot3!.data()}');
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('bookedtrips')
                .orderBy(orderkey, descending: descending)
                .startAfterDocument(documentSnapshot3!)
                .get()
                .then((value) {
              print(value);
              if (value.docs.isEmpty) {
                print('empty');
                showmore3 = false;
                emit(getbookedtripsdatasucess());
              }
            });
            emit(loadmoredatafirebasesucess());
            emit(getbookedtripsdatasucess());
          });
        })
            .catchError((error) {
          emit(getbookedtripsdataerror(error.toString()));
        });
      }
    }
  }


  // List<bookedtripmodel> bookedtripsdatas =[];
  // Future<void> getbookeddata()async{
  //   emit(getbookedtripsdataloading());
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .collection('bookedtrips')
  //       .get().then((value){
  //         value.docs.forEach((element) {
  //           final data = element.data() as Map<String, dynamic>;
  //           bookedtripsdatas.add(bookedtripmodel.fromjson(data));
  //           emit(getbookedtripsdatasucess());
  //         });
  //   });
  // }



  //--the end of the filter elements


  Future<void>sendcomplaint({
     String? username,
     String? email,
     String? complainttitle,
     String? complaintmessage,
     String? userid,
})async{
    emit(sendcomplaintloading());
    await FirebaseFirestore.instance
        .collection('userscomplaints')
        .add({
      'complainttime':Timestamp.now(),
      'username':username,
      'email':email,
      'complainttitle':complainttitle,
      'complaintmessage':complaintmessage,
      'messagebyuserid':userid
    }).then((value) {
      emit(sendcomplaintsucess());
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
      print(profileimage);
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


  Future<void> sendbookeddata(bookedtripmodel bookmodel,int seatsbooking)async{
    String docId = await FirebaseFirestore.instance.collection('users').doc('${constusers.id}').collection('bookedtrips').doc().id;
    bookmodel.bookingid=docId;
    await FirebaseFirestore.instance
        .collection('users')
        .doc('${constusers.id}')
        .collection('bookedtrips')
        .doc(docId)
        .set(bookmodel.tomap())
        .then((value) {
      sendbookingdatatoadmin(bookmodel,seatsbooking);
    });
  }
  Future<void> sendbookingdatatoadmin(bookedtripmodel bookmodel,int seatsbooking)async{
    FirebaseFirestore.instance
        .collection('tripsbooking')
        .doc(bookmodel.bookingid)
        .set(bookmodel.tomap()).then((value) {
      changeseatsvalue(bookmodel,seatsbooking);
    });

  }

  Future<void>changeseatsvalue(bookedtripmodel bookmodel,int seatsbooking)async {
    await FirebaseFirestore.instance
    .collection('trips')
    .doc('${bookmodel.tripbookedid}')
    .get().then((value) async{
      int seats = value.data()?['seats'];
      print('hello the ${seats}');
      if(seats>=(seatsbooking+1)) {
        seats = seats-(1+seatsbooking);
        await FirebaseFirestore.instance
            .collection('trips')
            .doc('${bookmodel.tripbookedid}')
            .update({'seats': seats}).then((value) {

        });
      }
      else{
        await FirebaseFirestore.instance
            .collection('tripsbookingerrors')
            .add(bookmodel.tomap());
      }
    });
  }


  bool check = false;
  Future<void> checkdocumentexistence(String fieldName) async {
    emit(checkdocumentexistenceloading());
    await FirebaseFirestore.instance
        .collection('users')
        .doc('${constusers.id}')
        .collection('bookedtrips')
        .where('tripbookedid' ,isEqualTo:fieldName )
        .limit(1).get().then((value) {
      if(value.docs.isNotEmpty){
        check=true;
      }
      else{
        check=false;
      }
      emit(checkdocumentexistencesucess());
    });

  }


  //bool tripavilableseats=true;
  Future<bool>checktripavailablility(String tripid,int seatsbook)async{
    emit(checktripavailablilityloading());
    bool? check;
    await FirebaseFirestore.instance
        .collection('trips')
        .doc('$tripid')
        .get().then((value) {
          if(value['seats']<(seatsbook+1)){
            check =  false;
            emit(checktripavailablilitysucess());
          }
          else{
            check = true;
            emit(checktripavailablilitysucess());
          }
    });
    emit(checktripavailablilitysucess());
    return check??false;
  }


  Future<void>getcontactinfo()async{
     FirebaseFirestore.instance
        .collection('home')
        .doc('contact')
        .get().then((value){
          contactemails=value['email'];
          contactphonenumbers=value['phonenumbers'];
          print(contactemails);
          print(contactphonenumbers);
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
  required int price,
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
        print('order id : ${apiconstants.paymentorderid}');
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
  required int price,
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
         "last_name": "c",
         "state": "NA"
       },
       "currency": "EGP",
       "integration_id": apiconstants.integrationidkcart,
       "lock_order_when_paid": "false"
     }).then((value) {
       apiconstants.finaltoken=value.data['token'];
       log(apiconstants.finaltoken);

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
  bool? paymentsuccess;
  Future<bool> getqueryparms(String url)async{
    var apiUrl = Uri.parse(url);
    var response = await http.get(apiUrl);
    String? queryParams = apiUrl.queryParameters['success'];
    print('params of success is :$queryParams');
    if(queryParams=='true'){
      return true;
    }
    else {
      return false;
    }
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