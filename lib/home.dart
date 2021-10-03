import 'dart:math';
import 'dart:ui';
import 'package:adamstracker/data.dart';
import 'package:adamstracker/main.dart' as main;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Assets
import 'package:adamstracker/widgets/ftext.dart';
import 'package:flutter_svg/parser.dart';
import 'package:get/get.dart';
import 'globals.dart' as gl;

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    gl.width = MediaQuery.of(context).size.width;
    gl.height = MediaQuery.of(context).size.height;
    gl.statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      backgroundColor: gl.pC,
      body: Container(
        width: gl.width,
        height: gl.height,
        child: ScrollConfiguration(
          behavior: gl.MyBehavior(),
          child: ListView.builder(
            itemCount: gl.items.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    // ANCHOR TOP MENU
                    Container(
                      width: gl.width,
                      height: gl.height * 0.07,
                      color: gl.pC,
                      child: Row(
                        children: [
                          Container(
                            width: gl.width * 0.2,
                            height: gl.height * 0.07,
                            child: Center(
                              child: Container(
                                width: gl.height * 0.04,
                                height: gl.height * 0.04,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(gl.height),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          main.model.user!.photoUrl.toString()),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: gl.width * 0.6,
                            height: gl.height * 0.07,
                            child: Center(
                              child: ftext("Tracker", 28.0, Colors.white,
                                  FontWeight.w800),
                            ),
                          ),
                          Container(
                            width: gl.width * 0.2,
                            height: gl.height * 0.07,
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.logout,
                                  size: 25.0,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  main.model.deleteDB();
                                  main.model.googleSignIn.signOut();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else if (index == gl.items.length - 1) {
                return Column(
                  children: [
                    Container(height: gl.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ftext("With ", 18.0, Colors.white, FontWeight.w500),
                        ftext("♥", 18.0, Colors.white, FontWeight.w700),
                        ftext(" by ", 18.0, Colors.white, FontWeight.w500),
                        ftext("@adamthecro ", 18.0, Colors.white,
                            FontWeight.w700),
                      ],
                    ),
                    Container(height: gl.height * 0.03),
                  ],
                );
              } else {
                return Container(
                  margin: EdgeInsets.only(
                      top: gl.height * 0.02,
                      left: gl.width * 0.05,
                      right: gl.width * 0.05),
                  width: gl.width * 0.9,
                  height: gl.height * 0.185,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(gl.height * 0.015),
                    color: gl.dC,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: gl.height * 0.05,
                        child: Center(
                          child: ftext(gl.items[index]["title"], 22.0,
                              Colors.white, FontWeight.w800),
                        ),
                      ),
                      Container(
                        width: gl.width * 0.9,
                        height: gl.height * 0.12,
                        child: Center(
                          child: ScrollConfiguration(
                            behavior: gl.MyBehavior(),
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: gl.items[index]["variants"].length,
                              itemBuilder: (context, index2) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    right: gl.width * 0.01,
                                    left: gl.width * 0.02,
                                  ),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: gl.height * 0.12,
                                    minWidth: gl.height * 0.12,
                                    color: gl.tC,
                                    splashColor: gl.dC,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: gl.height * 0.08,
                                          child: SvgPicture.asset(
                                            "assets/icons/${gl.items[index]["variants"][index2]["pict"]}.svg",
                                            height: gl.height * 0.07,
                                            width: gl.height * 0.07,
                                            color: Colors.white,
                                          ),
                                        ),
                                        ftext(
                                          gl.items[index]["variants"][index2]
                                              ["title"],
                                          18.0,
                                          Colors.white,
                                          FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Data(
                                            gl.items[index]["variants"][index2]
                                                ["id"],
                                            '${gl.items[index]["title"]} - ${gl.items[index]["variants"][index2]["title"]}',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
