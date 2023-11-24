import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rahal_application/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';


//fonts section
var defaultarabicfont = 'Tajawal-ar';
var defaultenglishfont = 'kanit-en';
//--end of fonts section--
//login and register section
//default login and register form text field:
Widget defaultformfield({
  required String labeltxt,
  required double borderRediusSize,
  Icon? icon,
  IconButton? suffixicon,
  String? prefixtext,
  int? maxlength,
  String? Function(String?)? validation ,
  void Function(String)? onchange,
  TextEditingController? control,
  TextInputType? keyboardtype,
  bool ispassword=false,
  }) => TextFormField(
  decoration: InputDecoration(
      counterText: '',
      labelText: labeltxt,
      prefixIcon:icon,
      prefixText: prefixtext,
      prefixStyle:TextStyle(fontSize: 20),
      suffixIcon: suffixicon,

  ),
  validator: validation,
  maxLength: maxlength,
  controller: control,
  keyboardType: keyboardtype,
  obscureText: ispassword,
  style: TextStyle(fontSize: 20),
  onChanged: onchange,
);
//default login button:
Widget defaultbutton({
 required String text,
 required void Function()?  function,
 bool condition = true,
  })=>ConditionalBuilder(
   condition:condition,
   builder:(context) => Container(
     height: 50,
     width: double.infinity,
     child: MaterialButton(onPressed: function,
       child: Text(text ,style: TextStyle(color: Colors.white,fontSize: 20),),
       color: defaultcolor,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(20.0),
       ),


     ),
   ),
   fallback: (context) => Center(child: CircularProgressIndicator(),),
  );
void navigateTo(BuildContext context,Widget place) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => place),
    );
  });


}
//--end of login and register section--


Widget defaultdialogbox({
  required BuildContext context,
  String? title_text,
  double? titlefontsize,
  double? contentfontsize,
  required Widget content,
  required List<Widget>? actions,

}) => AlertDialog(

  elevation: 0,
  titleTextStyle: TextStyle(fontSize: titlefontsize ?? 15,color: Colors.white,fontFamily: defaultarabicfont,),
  contentTextStyle: TextStyle(fontSize:contentfontsize ?? 25,color: Colors.black,fontFamily: defaultarabicfont,),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  title: title_text!=null? Container(
    padding: EdgeInsets.all(7),
    alignment: Alignment.center,
    width: double.infinity,
    decoration: BoxDecoration(color: defaultcolor,borderRadius:
    BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15)),),
    child: Text(title_text),
  ):null,
  content:  content,
  scrollable: true,
  actions: actions,
);


Widget defaultcircle({
  required String textfield,
  required Color fieldcolor,
  Color? textcolor,
})
{
  return Container(
    width: 32.0, // Adjust the size of the avatar
    height: 32.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: fieldcolor,
      // Set the background color of the avatar
    ),
    child: Column(
      mainAxisAlignment:MainAxisAlignment.center,
      children: [
        SizedBox(height: 7,),
        Container(

          child: Text(
            textfield,
            style: TextStyle(
              fontSize: 18, // Adjust the font size of the number
              color: textcolor ?? Colors.white, // Set the color of the number
            ),
          ),
        ),
      ],
    ),
  );
}


Widget defaultprofilesettings({
  required bool visible,
  required List<Widget> underwidgets,
  required String text,
  required void Function() ontap,
  IconData? begicon,
  bool isactive=true,
  bool disable=false,
})
{
  return Padding(
    padding: const EdgeInsets.all(0),
    child: Container(
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          MaterialButton(
            elevation: 0,
            focusElevation: 0,
            disabledElevation: 0,
            highlightElevation: 0,
            splashColor: Colors.transparent,
            highlightColor:!disable? Colors.grey[300]:Colors.grey,
            animationDuration: Duration.zero,
            padding: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color:!disable? Colors.white:Colors.grey,
            onPressed: !disable? ontap:(){},
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(begicon),
                Text(text,style: TextStyle(fontSize: 20)),
                Spacer(),
                Icon(
                  isactive?
                  underwidgets.isEmpty
                      ? null
                      : !visible
                      ? CupertinoIcons.chevron_down
                      : CupertinoIcons.chevron_up
                  :null,
                )

              ],
            ),
          ),
          Visibility(
            visible: !isactive?false:visible,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: underwidgets,
              ),
            ),),
        ],
      ),
    ),
  );
}


Widget defaultprofilebuttons({
  required String text,
  required IconData icon,
  required void Function() function,
})
{
  return MaterialButton(
    color: Colors.grey[350],
    elevation: 0,
    focusElevation: 0,
    disabledElevation: 0,
    highlightElevation: 0,
    splashColor: Colors.transparent,
    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)) ,
    highlightColor: Colors.grey[400],
    animationDuration: Duration.zero,
    padding: EdgeInsets.all(10),
    onPressed: function,
    child: Row(
      textDirection: TextDirection.rtl,
      children: [
        Icon(icon),
        SizedBox(width: 7,),
        Text(text,style: TextStyle(fontSize: 15)),
      ],
    ),
  );
}

Widget defaultmapscreen({
  String? title,
  String? addressonpointer,
  required LatLng position,
})
{
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey[100]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          title!=null?
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Text(title,style: TextStyle(fontSize: 16),textDirection: TextDirection.rtl,),
          ):Container(),
          Divider(
            thickness: 0.3,
            color: Colors.black,
            height: 0,
          ),
          Container(
            width: double.infinity,
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: position, zoom: 15),
              markers: {Marker(markerId: MarkerId("targetMarker"), position: position,infoWindow:addressonpointer!=null? InfoWindow(title: addressonpointer):InfoWindow.noText)},
              onMapCreated: (GoogleMapController controller) {},
            ),
          ),
        ],
      ),
    ),
  );
}



Widget defaultfilterbutton({
  required bool visible,
  required List<Widget> underwidgets,
  required String text,
  required void Function() ontap,
  bool isactive=true,
})
{
  return Padding(
    padding: const EdgeInsets.all(0),
    child: Container(
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          MaterialButton(
            elevation: 0,
            focusElevation: 0,
            disabledElevation: 0,
            highlightElevation: 0,
            splashColor: Colors.transparent,
            highlightColor: Colors.white,
            animationDuration: Duration.zero,
            padding: EdgeInsets.all(10),
            color: Colors.white,
            onPressed:ontap,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(text,style: TextStyle(fontSize: 15)),
                Spacer(),
                Icon(
                  isactive?
                  underwidgets.isEmpty
                      ? null
                      : !visible
                      ? CupertinoIcons.chevron_down
                      : CupertinoIcons.chevron_up
                      :null,
                )

              ],
            ),
          ),
          Visibility(
            visible: !isactive?false:visible,
            child: Column(
              children: underwidgets,
            ),),
        ],
      ),
    ),
  );
}


Widget defaultfilteractions(
{
  required String title,
  bool pressed = false,
  Function()? onpressed,
  Function()? oncancel,
})
{
  return GestureDetector(
    onTap: onpressed,
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: defaultcolor,width: 2),
          color:!pressed? Colors.white:Colors.indigoAccent[100],
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisSize: MainAxisSize.min,
          children: [
            pressed?GestureDetector(onTap:oncancel ,child: Icon(CupertinoIcons.xmark,size: 20),):Container(),
            Text(title,style: TextStyle(fontSize:15 ,color: !pressed?Colors.black:Colors.white)),
          ],
        ),
      ),
    ),
  );
}