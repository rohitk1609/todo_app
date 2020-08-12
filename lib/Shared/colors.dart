import 'package:flutter/material.dart';

Color primarycolor = Color.fromRGBO(47, 134, 246, 100);
Color whitebg = Color.fromRGBO(247, 247, 247, 100);
Color white = Colors.white;
Color black = Colors.black;
Color secondarycolor = Color.fromRGBO(114, 114, 114, 100);
Color red = Color.fromRGBO(213, 0, 0, 100);
Color green = Color.fromRGBO(0, 213, 79, 100);
Color blackbg = Color.fromRGBO(17, 17, 17, 100);
Color shadow = Color.fromRGBO(138, 136, 136, 50);

Widget text(
  String text,
  double factor,
  FontWeight fontWeight,
  Color color,
  int maxlines,
  TextOverflow overflow,
  BuildContext context,
) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: MediaQuery.of(context).size.height * factor,
    ),
    maxLines: maxlines,
    overflow: overflow,
  );
}
