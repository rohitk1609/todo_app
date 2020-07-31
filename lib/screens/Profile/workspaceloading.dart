import 'package:flutter/material.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/teammember.dart';

import '../../wrapper.dart';

class Workspaceloading extends StatefulWidget {
  String email;
  List<String> team;
  String workspacename;

  Workspaceloading({this.team, this.workspacename, this.email});
  @override
  _WorkspaceloadingState createState() => _WorkspaceloadingState();
}

class _WorkspaceloadingState extends State<Workspaceloading> {
  bool created = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    createworkspace();
  }

  Future createworkspace() async {
    await DatabaseService(email: widget.email)
        .UpdateWorkspaceDetails(
            widget.workspacename, [], widget.team, [], [widget.email])
        .then((value) {
      if (value == true) {
        print("HHHHHHHHHHHHHHH");
        setState(() {
          created = true;
        });

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => wrapper()),
            (route) => false);
      } else {
        setState(() {
          created = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.workspacename);
    print(widget.team);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              created
                  ? Text(
                      "Created",
                      style: TextStyle(color: Colors.black),
                    )
                  : Text(
                      "Creating workspace",
                      style: TextStyle(color: Colors.black),
                    ),
              SizedBox(
                height: 10,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
