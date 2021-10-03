import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:adamstracker/main.dart' as main;

// Assets
import 'package:adamstracker/home.dart';
import 'package:adamstracker/widgets/ftext.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Globals
import 'globals.dart' as gl;

class Start extends StatefulWidget {
  StartState createState() => StartState();
}

class StartState extends State<Start> {
  @override
  void initState() {
    super.initState();
  }

  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    gl.width = MediaQuery.of(context).size.width;
    gl.height = MediaQuery.of(context).size.height;
    gl.statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: gl.pC,
      body: Column(
        children: [
          // ANCHOR TOP MARGIN
          Container(
            height: gl.statusHeight,
            width: gl.width,
          ),
          Container(
            margin: EdgeInsets.only(
              top: (gl.height * 0.02),
            ),
            child: Center(
              child: ftext("Tracker", 40.0, Colors.white, FontWeight.w700),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: (gl.height * 0.05),
            ),
            height: gl.height * 0.6,
            width: gl.width * 0.8,
            child: Center(
              child: PageView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: gl.width * 0.8,
                    color: Colors.red,
                  ),
                  Container(
                    width: gl.width * 0.8,
                    color: Colors.blue,
                  ),
                  Container(
                    width: gl.width * 0.8,
                    color: Colors.green,
                  ),
                  Container(
                    width: gl.width * 0.8,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: gl.height * 0.01),
            child: SmoothPageIndicator(
              controller: controller,
              count: 4,
              effect: WormEffect(
                spacing: gl.width * 0.05,
                dotWidth: gl.width * 0.03,
                dotHeight: gl.width * 0.03,
                dotColor: Colors.white,
                activeDotColor: gl.rC,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              main.model.googleSignIn.signIn();
            },
            child: Container(
              margin: EdgeInsets.only(
                top: (gl.height * 0.1),
              ),
              width: gl.width * 0.8,
              height: gl.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular((gl.height / gl.width) * 3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/google_logo.png'),
                    height: gl.height * 0.04,
                  ),
                  Container(
                    width: gl.width * 0.04,
                  ),
                  ftext("Continuar con Google", 20.0, Colors.black,
                      FontWeight.w700),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
