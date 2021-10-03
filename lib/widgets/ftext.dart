import 'package:flutter/material.dart';

class ftext extends StatelessWidget {
  String _text;
  double _size;
  Color _color;
  FontWeight _weight;
  TextAlign _align;

  ftext(this._text, this._size, this._color, this._weight,
      [this._align = TextAlign.left]);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Text(
      _text,
      textAlign: _align,
      style: TextStyle(
        fontSize: width * _size / 500,
        color: _color,
        fontWeight: _weight,
      ),
    );
  }
}
