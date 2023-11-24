abstract class appstates {}

class initialstate extends appstates {}

class sqlreadstate extends appstates {}

class sqlinsertstate extends appstates {}



class loginloading extends appstates {}

class loginsucess extends appstates {
  final String? uid;
  loginsucess(this.uid);
}

class loginerror extends appstates {
  late final String error;
  loginerror(this.error);
}


class registerloading extends appstates {}

class registersucess extends appstates {}

class registererror extends appstates {
  late final String error;
  registererror(this.error);
}

class usercreatedatasucess extends appstates {}

class usercreatedataerror extends appstates {
  late final String error;
  usercreatedataerror(this.error);
}


class getdatafirebaseloading extends appstates {}

class getdatafirebasesucess extends appstates {}

class getdatafirebaseerror extends appstates {
  late final String error;
  getdatafirebaseerror(this.error);
}


class gettripsdatafirebaseloading extends appstates {}

class gettripsdatafirebasesucess extends appstates {}

class gettripsdatafirebaseerror extends appstates {
  late final String error;
  gettripsdatafirebaseerror(this.error);
}


class edituserdatafirebaseloading extends appstates {}

class edituserdatafirebasesucess extends appstates {}

class edituserdatafirebaseerror extends appstates {
  late final String error;
  edituserdatafirebaseerror(this.error);
}

class userlogoutloading extends appstates {}

class userlogoutsucess extends appstates {}

class userlogouterror extends appstates {
  late final String error;
  userlogouterror(this.error);
}


class paymentloading extends appstates {}

class paymentsucess extends appstates {}

class paymenterror extends appstates {
  late final String error;
  paymenterror(this.error);
}


class getorderidloading extends appstates {}

class getorderidsucess extends appstates {}

class getorderiderror extends appstates {
  late final String error;
  getorderiderror(this.error);
}

class getpaymentrequestloading extends appstates {}

class getpaymentrequestsucess extends appstates {}

class getpaymentrequesterror extends appstates {
  late final String error;
  getpaymentrequesterror(this.error);
}

class getrefcodeloading extends appstates {}

class getrefcodesucess extends appstates {}

class getrefcodeerror extends appstates {
  late final String error;
  getrefcodeerror(this.error);
}


class coupouncheckloading extends appstates {}

class coupounchecksucess extends appstates {}

class coupouncheckerror extends appstates {
  late final String error;
  coupouncheckerror(this.error);
}


class getfavouritesloading extends appstates {}

class getfavouritessucess extends appstates {}

class getfavouriteserror extends appstates {
  late final String error;
  getfavouriteserror(this.error);
}



class loadmoredatafirebaseloading extends appstates {}

class loadmoredatafirebasesucess extends appstates {}

class loadmoredatafirebaseerror extends appstates {
  late final String error;
  loadmoredatafirebaseerror(this.error);
}


class connectionsucessstate extends appstates {}

class connectionfailedstate extends appstates {}



class gettripdataloading extends appstates {}

class gettripdatasucess extends appstates {}

class gettripdataerror extends appstates {
  late final String error;
  gettripdataerror(this.error);
}


class getfeaturedloading extends appstates {}

class getfeaturedsucess extends appstates {}

class getfeaturederror extends appstates {
  late final String error;
  getfeaturederror(this.error);
}

class getfeatureddataloading extends appstates {}

class getfeatureddatasucess extends appstates {}

class getfeatureddataerror extends appstates {
  late final String error;
  getfeatureddataerror(this.error);
}


class getprofileimageloading extends appstates {}

class getprofileimagesucess extends appstates {}

class getprofileimageerror extends appstates {
  getprofileimageerror();
}


class uploadprofileimageloading extends appstates {}

class uploadprofileimagesucess extends appstates {}

class uploadprofileimageerror extends appstates {
  late final String error;
  uploadprofileimageerror(this.error);
}


class savetripsloading extends appstates {}

class savetripssucess extends appstates {}

class savetripserror extends appstates {
  late final String error;
  savetripserror(this.error);
}


class isfromfavouratesloading extends appstates {}

class isfromfavouratesssucess extends appstates {}

class isfromfavourateserror extends appstates {
  late final String error;
  isfromfavourateserror(this.error);
}

class removesavetripsloading extends appstates {}

class removesavetripssucess extends appstates {}

class removesavetripserror extends appstates {
  late final String error;
  removesavetripserror(this.error);
}



class getofferscreenloading extends appstates {}

class getofferscreensucess extends appstates {}

class getofferscreenerror extends appstates {
  late final String error;
  getofferscreenerror(this.error);
}