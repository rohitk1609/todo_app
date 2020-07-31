import 'package:flutter/material.dart';
import 'package:todo/models/slider.dart';

class CategoryMenu extends StatefulWidget {
  final int index;
  CategoryMenu({this.index});
  @override
  _CategoryMenuState createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.4,
      child: Text(sliderlist[widget.index].title,style: TextStyle(color: Colors.black),),
    );
  }
}