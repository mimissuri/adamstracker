import 'package:flutter/material.dart';
import 'package:adamstracker/widgets/ftext.dart';

class MyAppBar extends StatelessWidget {
  MyAppBar({
    required this.title,
    required this.color,
    required this.ws,
    required this.hs,
    required this.fs,
  });

  final String title;
  final Color color;
  final double ws;
  final double hs;
  final double fs;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(
        top: (height * 0.03),
      ),
      width: width * ws,
      height: height * hs,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular((height / width) * 3),
      ),
      child: Center(
        child: ftext(title, fs, Colors.white, FontWeight.w700),
      ),
    );
  }
}
