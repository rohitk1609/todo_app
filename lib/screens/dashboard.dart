import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/models/sharedpreference.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/timeinstance.dart';
import 'package:todo/models/timermodel.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';
import 'package:todo/screens/Home.dart';
import 'package:todo/screens/Profile/profile.dart';
import 'package:todo/screens/reports/reporthome.dart';
import 'package:todo/screens/settings/settings.dart';
import '../BottomNavigation/mynavigator.dart';

class Dashboard extends StatefulWidget {
  UserData userdata;
  List<Workspace> workspaces;
  Dashboard({this.userdata, this.workspaces});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedindex = 0;
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    loadsharedpref();
  }

  loadsharedpref() async {
    try {
      TimeInstance timeInstance =
          TimeInstance.fromJson(await sharedPref.read("timeinstance"));
      print(
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa,             ${timeInstance.time.toString()}');
      DateTime currenttime = DateTime.now();
      String t = (currenttime.difference(timeInstance.time).inHours % 24)
              .toString()
              .padLeft(2, '0') +
          ':' +
          (currenttime.difference(timeInstance.time).inMinutes % 60)
              .toString()
              .padLeft(2, '0') +
          ':' +
          (currenttime.difference(timeInstance.time).inSeconds % 60)
              .toString()
              .padLeft(2, '0');
      Timermodel model = ScopedModel.of(context);
      model.changetask(Task(taskname: timeInstance.taskname));
      model.settime(t);
      model.startstopwatch();
      print('hhhhhhhhhhhhhhhhhhhhhhhh  ${model.time}');
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (selectedindex == 0) {
      return Scaffold(
        backgroundColor: whitebg,
        body: Home(),
        bottomNavigationBar: Mynavigator(
          index: 0,
          onChange: (val) {
            setState(() {
              selectedindex = val;
            });
          },
        ),
      );
    }
    if (selectedindex == 1) {
      return Scaffold(
        backgroundColor: whitebg,
        body: ReportHome(),
        bottomNavigationBar: Mynavigator(
          index: 0,
          onChange: (val) {
            setState(() {
              selectedindex = val;
            });
          },
        ),
      );
    }
    if (selectedindex == 4) {
      return Scaffold(
        body: Profile(
          userdata: widget.userdata,
          workspaces: widget.workspaces,
        ),
        bottomNavigationBar: Mynavigator(
          index: 0,
          onChange: (val) {
            setState(() {
              selectedindex = val;
            });
          },
        ),
      );
    }
    if (selectedindex == 2) {
      return Scaffold(
        backgroundColor: whitebg,
        body: Settings(),
        bottomNavigationBar: Mynavigator(
          index: 0,
          onChange: (val) {
            setState(() {
              selectedindex = val;
            });
          },
        ),
      );
    }
  }
}
