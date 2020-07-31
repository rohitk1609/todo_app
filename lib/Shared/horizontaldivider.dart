
import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  double height;
  double width;
  Color color;
  HorizontalDivider({this.color,this.height,this.width});
  
  @override
  Widget build(BuildContext context) {
    
      return Container(
      height:height,
      width: width,
      decoration: BoxDecoration(color:color),
    
    );
    
  }
}