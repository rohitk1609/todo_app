import 'package:flutter/material.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';
import 'package:todo/screens/Profile/projectslist.dart';
import 'package:todo/screens/project/addproject.dart';
import 'package:todo/screens/project/project.dart';

class WorkspacePage extends StatefulWidget {
  Workspace workspace;
  WorkspacePage({this.workspace});
  @override
  _WorkspacePageState createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<UserData> workspaceteamdata = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getworkspaceteam();
    print(workspaceteamdata);
  }

  Future getworkspaceteam() async {
    for (int i = 0; i < widget.workspace.team.length; i++) {
      await DatabaseService()
          .getuserdata(widget.workspace.team[i])
          .then((value) {
        workspaceteamdata.add(value);
      });
    }
  }

  Widget display() {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.07,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15,
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.workspace.workspacename,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: MediaQuery.of(context).size.height * 0.035),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                Row(
                  children: <Widget>[
                    Text(
                      "${widget.workspace.projects.length.toString()} Projects | ${widget.workspace.tasks.length.toString()} Tasks | ${widget.workspace.team.length.toString()} Teams",
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Created By ",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.05,
                        backgroundColor: Colors.black,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _projectbox(Project project) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectPage(
                project: project,
                workspaceteam: workspaceteamdata,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.18,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "97%",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        project.projectname,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        project.projectteam.length.toString(),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitebg,
      body: StreamBuilder<List<Project>>(
          stream: DatabaseService(workspaceuid: widget.workspace.workspaceuid)
              .projects,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Project> projects = snapshot.data;
              return SafeArea(
                  child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: white,
                                  ),
                                  onPressed: () {},
                                ),
                                SizedBox(
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: white,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      addproject(
                                                        workspace:
                                                            widget.workspace,
                                                        workspaceteamdata:
                                                            workspaceteamdata,
                                                      )));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.settings,
                                          color: white,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                          ),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.workspace.workspacename,
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.w900,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.035),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "${widget.workspace.projects.length.toString()} Projects | ${widget.workspace.tasks.length.toString()} Tasks | ${widget.workspace.team.length.toString()} Teams",
                                      style: TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15,
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Created By ",
                                        style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        backgroundColor: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: secondarycolor),
                            child: Center(
                              child: Text(
                                "Projects",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: projects.length,
                            itemBuilder: (c, i) {
                              return _projectbox(projects[i]);
                            })
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.1,
                        minChildSize: 0.1,
                        maxChildSize: 0.5,
                        builder: (BuildContext context, myscrollController) {
                          return Container(
                              decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                              ),
                              child: ListView(
                                controller: myscrollController,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 5),
                                    child: Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.006,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[600],
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Workspace Info",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.notifications,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {},
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: Divider(
                                      color: Colors.white,
                                      height: 5,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20, top: 20),
                                    child: Text(
                                      "Workspace Team",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20, top: 20),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: workspaceteamdata.length,
                                          itemBuilder: (c, i) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                child: Row(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      radius:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              workspaceteamdata[
                                                                      i]
                                                                  .profilepic),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: VerticalDivider(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            workspaceteamdata[i]
                                                                .username,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            workspaceteamdata[i]
                                                                .category,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          })),
                                ],
                              ));
                        },
                      ),
                    ),
                  ),
                ],
              ));
            } else {
              return SafeArea(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}
