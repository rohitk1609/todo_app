import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/models/task.dart';
import 'package:todo/screens/mytasks.dart';

class Timerpage extends StatefulWidget {
  List<Task> mytasks;
  Timerpage({this.mytasks});
  @override
  _TimerpageState createState() => _TimerpageState();
}

class _TimerpageState extends State<Timerpage> {
  TextEditingController searchcontroller = TextEditingController();

  String selectedtask = '';
  int selectedradiotile;
  String selectedtaskuid = '';
  bool start = false;

  setselectedradiotile(val) {
    setState(() {
      selectedradiotile = val;
    });
  }

  Widget tasks(List<Task> mytasks) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: new ExpansionTile(
          title: Text(
            selectedtask.isEmpty ? 'Select your task' : selectedtask,
            style: TextStyle(color: Colors.black),
          ),
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: mytasks.length,
                itemBuilder: (c, i) {
                  return RadioListTile(
                    groupValue: selectedradiotile,
                    onChanged: (val) {
                      setselectedradiotile(val);
                      print(mytasks[selectedradiotile].taskname);
                      setState(() {
                        selectedtask = mytasks[selectedradiotile].taskname;
                        selectedtaskuid = mytasks[selectedradiotile].taskuid;
                      });
                    },
                    value: i,
                    title: Text('${mytasks[i].taskname}'),
                  );
                })
          ],
        ),
      ),
    );
  }

  String time = "00:00:00";
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);

  void starttimer() {
    Timer(dur, keeprunning);
  }

  void keeprunning() {
    if (mounted) {
      setState(() {
        time = swatch.elapsed.inHours.toString().padLeft(2, "0") +
            ":" +
            (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      });
    }

    if (swatch.isRunning) {
      starttimer();
    }
  }

  void startstopwatch() {
    swatch.start();
    starttimer();
    setState(() {
      start = !start;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    startstopwatch();
    super.initState();
  }

  Future<bool> clearaction() {
    return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Discard the time entry?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("ok"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: clearaction,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200], spreadRadius: 1, blurRadius: 5)
                ]),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                          onPressed: clearaction,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (selectedtask.isNotEmpty) {
                              Navigator.pop(context, time);
                            }
                          },
                          child: Text(
                            "DONE",
                            style: TextStyle(
                                letterSpacing: 3,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                tasks(widget.mytasks),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
