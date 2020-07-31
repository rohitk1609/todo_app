import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/Shared/colors.dart';

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        border: isActive
            ? Border.all(
                color: secondarycolor,
                width: 2.0,
              )
            : Border.all(
                color: Colors.transparent,
                width: 1,
              ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class GetStarted extends StatelessWidget {
  bool isActive;
  GetStarted(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: isActive ? MediaQuery.of(context).size.height * 0.07 : 0,
      width: isActive ? MediaQuery.of(context).size.width : 0,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Center(
          child: Text(
        "Get Started",
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
