import 'package:flutter/material.dart';
import 'package:todo/Shared/colors.dart';

class Mynavigator extends StatefulWidget {
  final int index;
  final Function(int) onChange;
  Mynavigator({this.index, @required this.onChange});
  @override
  _MynavigatorState createState() => _MynavigatorState();
}

class _MynavigatorState extends State<Mynavigator> {
  int selectedindex;

  @override
  void initState() {
    super.initState();
    selectedindex = widget.index;
  }

  Widget button(IconData icon, Color color, int index, Function function) {
    return IconButton(
      splashColor: Colors.grey[500],
      onPressed: () {
        widget.onChange(index);
        setState(() {
          selectedindex = index;
        });
      },
      icon: Icon(
        icon,
        color: selectedindex == index ? white : color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        color: whitebg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          button(Icons.home, Colors.grey[600], 0, () {}),
          button(Icons.scatter_plot, Colors.grey[600], 1, () {}),
          button(Icons.search, Colors.grey[600], 2, () {}),
          button(Icons.settings, Colors.grey[600], 3, () {}),
          button(Icons.perm_identity, Colors.grey[600], 4, () {})
        ],
      ),
    );
  }
}
