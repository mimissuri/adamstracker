library wardus.globals;

import 'package:flutter/material.dart';

double width = 0, height = 0, statusHeight = 0;

const Color pC = Color(0xFF0A0B0D);
const Color sC = Color(0xFF0B0B0C);
const Color tC = Color(0xFF242C37);
const Color dC = Color(0xFF12151c);
const Color rC = Color(0xFFE93D3D);

double doing = 0;

List<Map> items = [
  {"firstone": "first"},
  {
    "title": "Chest",
    "variants": [
      {
        "title": "Upper",
        "pict": "benchup",
        "id": 0,
      },
      {
        "title": "Mid",
        "pict": "bench",
        "id": 1,
      },
      {
        "title": "Lower",
        "pict": "benchdown",
        "id": 2,
      },
    ]
  },
  {
    "title": "Triceps",
    "variants": [
      {
        "title": "Rope",
        "pict": "rope",
        "id": 3,
      },
      {
        "title": "Close-Grip",
        "pict": "bench",
        "id": 4,
      },
      {
        "title": "Extension",
        "pict": "overhead",
        "id": 5,
      },
    ]
  },
  {
    "title": "Back",
    "variants": [
      {
        "title": "Lats",
        "pict": "back1",
        "id": 6,
      },
      {
        "title": "Row",
        "pict": "back2",
        "id": 7,
      },
      {
        "title": "Extension",
        "pict": "back3",
        "id": 8,
      },
      {
        "title": "Trapezoid",
        "pict": "back4",
        "id": 9,
      },
    ]
  },
  {
    "title": "Biceps",
    "variants": [
      {
        "title": "Vertical",
        "pict": "dumbbell rotated",
        "id": 10,
      },
      {
        "title": "Horizontal",
        "pict": "dumbbell",
        "id": 11,
      },
      {
        "title": "Preacher",
        "pict": "preacher",
        "id": 12,
      },
    ]
  },
  {
    "title": "Legs",
    "variants": [
      {
        "title": "Press",
        "pict": "press",
        "id": 13,
      },
      {
        "title": "Curl",
        "pict": "legcurl",
        "id": 14,
      },
      {
        "title": "Extension",
        "pict": "extension",
        "id": 15,
      },
      {
        "title": "Calves",
        "pict": "calves",
        "id": 16,
      },
    ]
  },
  {
    "title": "Shoulders",
    "variants": [
      {
        "title": "Front",
        "pict": "dumbbell",
        "id": 17,
      },
      {
        "title": "Lateral",
        "pict": "overhead",
        "id": 18,
      },
      {
        "title": "Military",
        "pict": "military",
        "id": 19,
      },
    ]
  },
  {"lastone": "last"},
];

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
