import 'package:flutter/material.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/models/task.dart';

class Mytasks extends StatefulWidget {
  List<Task> mytasks;
  Mytasks({this.mytasks});

  @override
  _MytasksState createState() => _MytasksState();
}

class _MytasksState extends State<Mytasks> with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  Widget taskbox(Task task) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: new ExpansionTile(
          title: Text(
            task.taskname,
            style: TextStyle(color: Colors.black),
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
                              fontWeight: FontWeight.w400),
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
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            "Start: ${task.startdate.day}-${task.startdate.month}-${task.startdate.year}",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            "Deadline: ${task.enddate.day}-${task.enddate.month}-${task.enddate.year}",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w400),
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
  }

  Widget _inprogress(List<Task> tasks) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (c, index) {
          if (tasks[index].status == 'inprogress') {
            return taskbox(tasks[index]);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _upcoming(List<Task> tasks) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (c, index) {
          if (tasks[index].status == 'upcoming') {
            return taskbox(tasks[index]);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _completed(List<Task> tasks) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (c, index) {
          if (tasks[index].status == 'completed') {
            return taskbox(tasks[index]);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondarybackgroundcolor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, right: 20, bottom: 10, left: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            TabBar(
              indicatorColor: Colors.white,
              labelColor: white,
              unselectedLabelColor: Colors.grey[600],
              indicatorPadding: EdgeInsets.only(left: 10),
              tabs: [
                Tab(
                  text: 'InProgress',
                ),
                Tab(
                  text: 'Upcoming',
                ),
                Tab(
                  text: 'Completed',
                ),
              ],
              controller: tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  _inprogress(widget.mytasks),
                  _upcoming(widget.mytasks),
                  _completed(widget.mytasks),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
