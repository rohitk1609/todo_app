import 'package:flutter/material.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';

class MyProfile extends StatefulWidget {
  UserData userdata;
  List<Workspace> workspaces;
  MyProfile({this.userdata, this.workspaces});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
