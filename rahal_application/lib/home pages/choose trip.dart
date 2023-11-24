import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rahal_application/shared/styles/colors.dart';

class choosetrip extends StatefulWidget {
  @override
  State<choosetrip> createState() => _choosetripState();
}

class _choosetripState extends State<choosetrip> {
  bool isbuttonpressed=false;
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        AnimatedOpacity(
            opacity:isbuttonpressed?1.0:0.0 ,
            duration:Duration(seconds: 1) ,
            child: Center(child: Text('قريبا',style: TextStyle(fontSize: 70),))),
        GestureDetector(
          onTap: () {
            setState(() {
              if(isbuttonpressed==true)
              {
                isbuttonpressed=false;
              }
            });
          },
          child: AnimatedContainer(
              duration: Duration(seconds: 1),
              height:!isbuttonpressed?MediaQuery.of(context).size.height/1.5:85,
              decoration: BoxDecoration(color: defaultcolor,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(150),bottomRight:Radius.circular(150) )),
              child:
              AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: !isbuttonpressed? 1.0 : 0.0,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  reverse: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.add_circle_outline,size: 200,color: Colors.green[200],),
                      SizedBox(height: 20,),
                      Center(child: Text('اختر برنامج رحلتك بنفسك',style: TextStyle(fontSize: 30,color: Colors.white,),textAlign: TextAlign.center,)),
                      SizedBox(height: 20,),
                      TextButton(onPressed: (){
                        setState(() {
                          isbuttonpressed=true;
                        });
                      },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.black,width: 4),
                                )
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(top: 7,bottom: 7,right:40,left: 40),
                          child: Text('ابدأ الان',style: TextStyle(fontSize: 30,color: Colors.white)),
                        ),),
                      SizedBox(height: 70,),
                    ],
                  ),
                ),
              )

          ),
        ),
      ],
    );
  }
}
