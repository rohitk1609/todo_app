import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/authenticatehome.dart';
import 'package:todo/database/database.dart';
import 'package:todo/details/details.dart';
import 'package:todo/details/username.dart';
import 'package:todo/models/sharedpreference.dart';
import 'package:todo/models/user.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';
import 'package:todo/screens/dashboard.dart';
import 'package:todo/screens/newdashboard.dart';

class wrapper extends StatefulWidget {
  @override
  _wrapperState createState() => _wrapperState();
}

class _wrapperState extends State<wrapper> {
  SharedPref sharedPref = SharedPref();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user != null) {
      return StreamBuilder<UserData>(
          stream: DatabaseService(email: user.email).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userdata = snapshot.data;
              return StreamBuilder<List<Workspace>>(
                  stream: DatabaseService(email: user.email).workspaces,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("assss");
                      List<Workspace> workspaces = snapshot.data;

                      return Dashboard(
                        userdata: userdata,
                        workspaces: workspaces,
                      );
                    } else {
                      return Dashboard(
                        userdata: userdata,
                        workspaces: [],
                      );
                    }
                  });
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                color: Colors.white,
              );
            } else {
              return Username();
              //print(result);

            }
          });
    } else if (user == null) {
      return AuthenticateHome();
    }
  }
}
