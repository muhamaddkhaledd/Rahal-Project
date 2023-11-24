import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rahal_application/home.dart';
import 'package:rahal_application/login%20and%20register%20homepage.dart';
import 'package:rahal_application/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class boardingmodel
{
  final String Image;
  final String title;
  boardingmodel({
    required this.Image,
    required this.title
});
}


class onboardingscreen extends StatefulWidget {
  @override
  State<onboardingscreen> createState() => _onboardingscreenState();
}

class _onboardingscreenState extends State<onboardingscreen> {
  var boardcontroler = PageController();

List<boardingmodel> boarding =
[
  boardingmodel(Image: 'assets/images/onboarding pic1.png', title:'اسهل طريقه للتنقل والرحلات' ),
  boardingmodel(Image: 'assets/images/onboarding pic2.png', title:'اختار وجهتك انت واصدقائك' ),
  boardingmodel(Image: 'assets/images/onboarding pic3.png', title:'مواعيد رحلات منضبطه' ),
];
bool islast=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(onPressed: (){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => login_register_home(),
            ), (route) => false);
            cachehelper.saveshareddata(key: 'onboarding',value:  false).then((value) {print('done onboarding');} );
          }, child: Text('تخطي',style: TextStyle(fontSize: 20),)),
        ),
      ],elevation: 0),

      body:Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardcontroler,
                onPageChanged: (value)
                {
                  if(value== boarding.length-1)
                  {
                    setState(() {
                      islast=true;
                    });
                  }
                  else
                  {
                    islast=false;
                  }
                },
                physics: BouncingScrollPhysics(),
                itemBuilder:(context, index) => buildboard(boarding[index]),
                itemCount: 3,
              ),
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                SmoothPageIndicator(controller: boardcontroler, count: boarding.length,
                effect: ExpandingDotsEffect(

                ),),
                Spacer(),
                FloatingActionButton(onPressed: (){
                  if(islast)
                  {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) => login_register_home(),
                    ), (route) => false);
                    cachehelper.saveshareddata(key: 'onboarding',value: false).then((value) {print('done onboarding');} );
                  }

                    boardcontroler.nextPage(duration: Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);

                },child: Icon(CupertinoIcons.arrow_right),)
              ],
            ),
          ],
        ),
      ),

    );
  }
}
Widget buildboard(boardingmodel model) =>Column(
  children: [
    Expanded(
        child:
        Image(image: AssetImage('${model.Image}'))),
    Text('${model.title}',style: TextStyle(fontSize: 30),),

  ],
) ;