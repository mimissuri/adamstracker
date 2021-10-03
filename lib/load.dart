import 'dart:developer';
import 'dart:ui';
import 'package:adamstracker/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:adamstracker/model.dart';
import 'package:adamstracker/widgets/ftext.dart';

// Globals
import 'globals.dart' as gl;

class Load extends StatefulWidget {
  WModel model;
  Load(this.model);
  @override
  LoadState createState() {
    model.init();
    return LoadState();
  }
}

class LoadState extends State<Load> {
  @override
  Widget build(BuildContext context) {
    gl.width = MediaQuery.of(context).size.width;
    gl.height = MediaQuery.of(context).size.height;
    gl.statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: gl.pC,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ftext("hmmmm...", 20.0, Colors.white, FontWeight.bold),
          ), /*
          GestureDetector(
            onTap: () {
              Get.off(Home());
            },
            child: ftext("HERE", 30.0, Colors.white, FontWeight.bold),
          )*/
        ],
      ),
    );
  }
}
