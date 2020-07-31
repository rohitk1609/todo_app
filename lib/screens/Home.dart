import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/Shared/horizontaldivider.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/sharedpreference.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/timeinstance.dart';
import 'package:todo/models/timermodel.dart';
import 'package:todo/models/user.dart';
import 'package:todo/screens/mytasks.dart';
import 'package:todo/screens/timer.dart';
import 'package:todo/screens/dialogtask.dart';
import 'package:todo/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CalendarController _calendarController;
  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();
  }

  Widget projectcontainer(Project project) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 10),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.17,
          width: MediaQuery.of(context).size.width * 0.65,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: secondarycolor),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  project.projectname,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${project.tasks.length.toString()} tasks',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    _calendarController.dispose();

    super.dispose();
  }

  Widget taskbox(Task task) {
    if (task.status == 'inprogress') {
      return Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: new ExpansionTile(
            title: Row(
              children: <Widget>[
                Text(
                  task.taskname,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    task.taskdescription.isEmpty
                        ? Container()
                        : Text(
                            task.taskdescription,
                            maxLines: 10,
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Assigned To :",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: task.assignedto.length,
                          itemBuilder: (c, i) {
                            return Text(task.assignedto[i],
                                style: TextStyle(color: Colors.black));
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Created by:",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(task.createby, style: TextStyle(color: Colors.black)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: secondarycolor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              "Start: ${task.startdate.day}-${task.startdate.month}-${task.startdate.year}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: secondarycolor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              "Deadline: ${task.enddate.day}-${task.enddate.month}-${task.enddate.year}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _inprogress(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (c, index) {
        if (tasks[index].status == 'inprogress') {
          return taskbox(tasks[index]);
        } else {
          return Container();
        }
      },
    );
  }

  Task selectedtask;
  SharedPref sharedPref = SharedPref();
  int selectedradiotile;
  String tasktime = '00:00:00';
  String elapsedtime = '';
  bool start = false;
  setselectedradiotile(val) {
    print(val);
    selectedradiotile = val;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<List<Task>>(
        stream: DatabaseService(email: user.email).mytasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("in home ${snapshot.data}");
            List<Task> mytasks = snapshot.data;
            return StreamBuilder<List<Project>>(
                stream: DatabaseService(email: user.email).myprojects,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Project> myprojects = snapshot.data;
                    return Scaffold(
                      backgroundColor: secondarybackgroundcolor,
                      body: SafeArea(child: ScopedModelDescendant<Timermodel>(
                          builder: (context, child, model) {
                        return Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Today",
                                                style: TextStyle(
                                                    color: white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005,
                                              ),
                                              Text(
                                                '${DateTime.parse(DateTime.now().toString()).day.toString()}-${DateTime.parse(DateTime.now().toString()).month.toString()}-${DateTime.parse(DateTime.now().toString()).year.toString()}',
                                                style: TextStyle(
                                                  color: white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.exit_to_app,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              AuthService().signoutwithGoogle();
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: secondarycolor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Time Tracker",
                                            style: TextStyle(
                                                color: white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          ),
                                          Center(
                                            child: IconButton(
                                                icon: model.isrunning
                                                    ? Icon(
                                                        Icons.stop,
                                                        color: white,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .play_circle_filled,
                                                        color: white,
                                                      ),
                                                iconSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.08,
                                                onPressed: () {
                                                  if (model.task != null) {
                                                    print('in big if');
                                                    model.runningstate();
                                                    if (model.isrunning) {
                                                      print(
                                                          ".........................................");
                                                      sharedPref.save(
                                                          'timeinstance',
                                                          TimeInstance(
                                                              taskname: model
                                                                  .task
                                                                  .taskname,
                                                              taskuid: model
                                                                  .task.taskuid,
                                                              time: DateTime
                                                                  .now()));

                                                      model.startstopwatch();

                                                      Scaffold.of(context)
                                                          .showSnackBar(SnackBar(
                                                              content: new Text(
                                                                  "Timer is Running!"),
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500)));
                                                    } else {
                                                      print(
                                                          '/..................../ in stop');

                                                      elapsedtime = model.time;
                                                      selectedtask = model.task;
                                                      selectedradiotile = null;
                                                      sharedPref.remove(
                                                          'timeinstance');
                                                      print(elapsedtime);
                                                      print(selectedtask
                                                          .taskname);
                                                      model.resettask();
                                                      model.stopstopwatch();
                                                    }
                                                  } else {
                                                    Scaffold.of(context)
                                                        .showSnackBar(SnackBar(
                                                            content: new Text(
                                                                "Select task to start"),
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500)));
                                                  }
                                                }),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0, bottom: 20),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              color: backgroundcolor,
                                              child: Center(
                                                child: Text(
                                                  model.time == null
                                                      ? "00:00:00"
                                                      : model.time,
                                                  style: TextStyle(
                                                      color: white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.025),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ExpansionTile(
                                            title: Text(
                                              model.task == null
                                                  ? 'Select your task'
                                                  : model.task.taskname,
                                              style: TextStyle(color: white),
                                            ),
                                            children: <Widget>[
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: mytasks.length,
                                                  itemBuilder: (c, i) {
                                                    return RadioListTile(
                                                      activeColor: white,
                                                      groupValue:
                                                          selectedradiotile,
                                                      onChanged: (val) {
                                                        setselectedradiotile(
                                                            val);
                                                        model.changetask(
                                                            mytasks[val]);
                                                      },
                                                      value: i,
                                                      title: Text(
                                                        '${mytasks[i].taskname}',
                                                        style: TextStyle(
                                                            color: white),
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20,
                                        top: 20,
                                        bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Your inprogress Tasks",
                                          style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Mytasks(
                                                          mytasks: mytasks,
                                                        )));
                                          },
                                          child: Text(
                                            "All tasks",
                                            style: TextStyle(
                                                color: secondarycolor,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  mytasks.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child: Center(
                                              child: Text(
                                                "No tasks assigned to you Create your own task and project under default workspace",
                                                style: TextStyle(
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          child: ListView.builder(
                                              itemCount: mytasks.length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (c, i) {
                                                return taskbox(mytasks[i]);
                                              }),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20,
                                        top: 20,
                                        bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Projects Your Working on",
                                          style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            "All projects",
                                            style: TextStyle(
                                                color: secondarycolor,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  myprojects.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey[200],
                                                      spreadRadius: 1,
                                                      blurRadius: 5)
                                                ]),
                                            padding: EdgeInsets.all(10),
                                            child: Center(
                                              child: Text(
                                                "No projects assigned to you Create your own task and project under default workspace",
                                                style: TextStyle(
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: myprojects.length,
                                              itemBuilder: (context, index) {
                                                return projectcontainer(
                                                    myprojects[index]);
                                              }),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        );
                      })),
                    );
                  } else {
                    return Scaffold(
                      backgroundColor: secondarybackgroundcolor,
                      body: Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                
                });
          } else {
            return Scaffold(
              backgroundColor: secondarybackgroundcolor,
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }
}
