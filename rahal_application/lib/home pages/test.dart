import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter/material.dart';



import 'package:flutter/material.dart';

import '../shared/components/components.dart';


class test extends StatefulWidget {
  @override
  State<test> createState() => _testState();
  String s = '';
}

class _testState extends State<test> {


  @override
  Widget build(BuildContext context) {
   String x= widget.s;
   List <dynamic> assetPaths = [
     'assets/images/trips types/1.jpg',
     'assets/images/trips types/2.jpg',
     'assets/images/trips types/3.jpg',
     'assets/images/trips types/4.jpg',
     'assets/images/trips types/5.jpg',
     'assets/images/trips types/6.jpg',
     'assets/images/trips types/7.jpg',
     'assets/images/trips types/8.jpg',
   ];
   int selectedImageIndex = -1;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body:
      CarouselSlider(
      items: assetPaths.asMap().entries.map((entry) {
        int index = entry.key;
        String assetPath = entry.value;
        bool isSelected = index == selectedImageIndex;

        return Container(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImageIndex = index; // Update the selected index
                    });
                  },
                  child: Card(
                    // ... (rest of your Card widget code)
                    child: Container(
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              if (isSelected) // Show overlay if image is selected
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Semi-transparent black color
                  ),
                ),
              // ... (rest of your code)
            ],
          ),
        );
      }).toList(),
      options: CarouselOptions(
        // Your existing options
        // ...
      ),
    )
    ,
      ),
    );
  }
}