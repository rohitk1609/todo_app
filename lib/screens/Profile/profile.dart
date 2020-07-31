import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/Shared/horizontaldivider.dart';
import 'package:todo/Shared/slidepage.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/sharedpreference.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';
import 'package:todo/models/workspacemodel.dart';
import 'package:todo/screens/Profile/addworkspace.dart';
import 'package:todo/screens/Profile/allprojects.dart';
import 'package:todo/screens/Profile/bottomsheet.dart';
import 'package:todo/screens/Profile/invitepeople.dart';
import 'package:todo/screens/Profile/workspace.dart';
import 'package:todo/screens/project/addproject.dart';
import 'package:todo/screens/project/project.dart';
import 'package:todo/services/auth.dart';

class Profile extends StatefulWidget {
  UserData userdata;
  List<Workspace> workspaces;
  Profile({this.userdata, this.workspaces});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget workspacebox(Workspace workspace) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WorkspacePage(
                      workspace: workspace,
                    )));
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10.0, bottom: 10, left: 20, right: 20),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.26,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.grey[900], borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              workspace.workspacename,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.03),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Created by Rohit kumar",
                              style: TextStyle(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w400,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.015),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                workspace.projects.length.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Projects',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        HorizontalDivider(
                          height: 40,
                          width: 0.5,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                workspace.tasks.length.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Tasks',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        HorizontalDivider(
                          height: 40,
                          width: 0.5,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                workspace.team.length.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Teams',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ExpandableController expandableController;
  SharedPref sharedPref = SharedPref();
  String currentworkpaceuid = '';
  List<List<Project>> projects = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expandableController = ExpandableController();
    loadcurrentworkspace();
  }

  loadcurrentworkspace() async {
    List<UserData> temp = [];
    Workspace cw = Workspace.fromJson(
        await sharedPref.read("${widget.userdata.email}currentworkspace"));
    print(cw.workspaceuid);
    widget.workspaces.forEach((element) {
      if (element.workspaceuid == cw.workspaceuid) {
        setState(() {
          selectedradiotile = widget.workspaces.indexOf(element);
        });
      }
    });
    print('aaaaaaaaaa $selectedradiotile');
    for (int i = 0; i < widget.workspaces[selectedradiotile].team.length; i++) {
      await DatabaseService()
          .getuserdata(widget.workspaces[selectedradiotile].team[i])
          .then((value) {
        if (!workspaceteamdata.contains(value)) {
          temp.add(value);
        }
      });
    }

    setState(() {
      workspaceteamdata = temp;
    });
  }

  List<UserData> workspaceteamdata = [];
  Future getworkspaceteam() async {
    for (int i = 0; i < widget.workspaces[selectedradiotile].team.length; i++) {
      await DatabaseService()
          .getuserdata(widget.workspaces[selectedradiotile].team[i])
          .then((value) {
        if (!workspaceteamdata.contains(value)) {
          workspaceteamdata.add(value);
        }
      });
    }
  }

  Widget profileBox(UserData user) {
    return Container(
      decoration: BoxDecoration(
        color: secondarycolor,
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: secondarycolor,
                  radius: MediaQuery.of(context).size.width * 0.1,
                  child: Icon(
                    Icons.adjust,
                    color: white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: <Widget>[
                Text(
                  user.username,
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget workspace(Workspace workspace) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    workspace.workspacename,
                    style: TextStyle(color: white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      color: secondarycolor,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkspacePage(
                                    workspace: workspace,
                                  )));
                    },
                  ),
                ],
              ),
            ),
            workspace.projects.isEmpty
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: Center(
                      child: Text(
                        "0 Projects , Tap to Add a Project",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                : SizedBox(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future bottomsheet(List<Workspace> workspaces, BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Bottomsheet(
            workspaces: workspaces,
          );
        });
  }

  int selectedradiotile;
  setselectedradiotile(val) {
    print(val);
    selectedradiotile = val;
  }

  Widget projectBox(Project project) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectPage(
                  project: project,
                  workspaceteam: workspaceteamdata,
                  workspace: widget.workspaces[selectedradiotile],
                ),
              ));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        child: Icon(
                          Icons.accessibility_new,
                          color: white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              project.projectname,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.018),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'A/b testing for lab Design , proper texting via sms and otp requires attention',
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[200],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: secondarycolor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  project.tasks.length.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Tasks",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: secondarycolor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  project.projectteam.length.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Team",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "90%",
                        maxLines: 1,
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.02),
                      ),
                      Divider(
                        color: white,
                        thickness: 10,
                      )
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
    print(widget.userdata.email);
    return ScopedModelDescendant<Workpsacemodel>(
      builder: (co, child, model) {
        return selectedradiotile == null
            ? Scaffold(
                backgroundColor: secondarybackgroundcolor,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : StreamBuilder<List<Project>>(
                stream: DatabaseService(
                        workspaceuid:
                            widget.workspaces[selectedradiotile].workspaceuid)
                    .projects,
                builder: (context, snapshot) {
                  List<Project> projects = snapshot.data;
                  return Scaffold(
                    backgroundColor: secondarybackgroundcolor,
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              decoration: BoxDecoration(color: secondarycolor),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context,
                                                  StateSetter state) {
                                                return Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            secondarybackgroundcolor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    child: Wrap(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          child: Center(
                                                            child: Container(
                                                              height: 10,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      backgroundcolor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                            ),
                                                          ),
                                                        ),
                                                        ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: widget
                                                                .workspaces
                                                                .length,
                                                            itemBuilder:
                                                                (c, i) {
                                                              return Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          10.0),
                                                                  child:
                                                                      RadioListTile(
                                                                    activeColor:
                                                                        white,
                                                                    groupValue:
                                                                        selectedradiotile,
                                                                    onChanged:
                                                                        (val) {
                                                                      state(() {
                                                                        selectedradiotile =
                                                                            val;
                                                                      });
                                                                      sharedPref
                                                                          .remove(
                                                                              '${widget.userdata.email}currentworkspace');
                                                                      sharedPref.save(
                                                                          '${widget.userdata.email}currentworkspace',
                                                                          widget
                                                                              .workspaces[val]);

                                                                      loadcurrentworkspace();
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    value: i,
                                                                    title: Text(
                                                                      '${widget.workspaces[i].workspacename}',
                                                                      style: TextStyle(
                                                                          color:
                                                                              white),
                                                                    ),
                                                                  ));
                                                            }),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: FlatButton(
                                                                color:
                                                                    secondarycolor,
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                AddWorkspace(),
                                                                      ));
                                                                },
                                                                child: Text(
                                                                  "Add Workspace",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ));
                                              },
                                            );
                                          });
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          widget.workspaces[selectedradiotile]
                                              .workspacename,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  )
                                ],
                              ),
                            ),
                            profileBox(widget.userdata),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: secondarycolor),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Projects',
                                        style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                                  workspace: widget.workspaces[
                                                      selectedradiotile],
                                                  workspaceteamdata:
                                                      workspaceteamdata,
                                                  project: Project(),
                                                ),
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.32,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: projects.length,
                                      itemBuilder: (c, i) {
                                        return projectBox(projects[i]);

                                        /*InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProjectPage(
                                                    project: projects[i],
                                                    workspaceteam:
                                                        workspaceteamdata,
                                                    workspace: widget.workspaces[
                                                        selectedradiotile],
                                                  ),
                                                ));
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(bottom: 10.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(5)),
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15.0, right: 15),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            radius: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                            child: Text(
                                                              projects[i]
                                                                  .projectname[0]
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                  color: white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.03),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                projects[i]
                                                                    .projectname,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .height *
                                                                        0.02,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                'Tasks : ${projects[i].tasks.length.toString()}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        );*/
                                      })),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: secondarycolor),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: Center(
                                  child: Text(
                                    'Workspace team',
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20,
                                  top: 10,
                                ),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: workspaceteamdata.length,
                                    itemBuilder: (c, i) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              backgroundImage: NetworkImage(
                                                  workspaceteamdata[i]
                                                      .profilepic),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    workspaceteamdata[i]
                                                        .username
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'product manager',
                                                    style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.graphic_eq,
                                                color: white,
                                              ),
                                              onPressed: () {},
                                            )
                                          ],
                                        ),
                                      );
                                    })),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.085,
                                decoration: BoxDecoration(
                                    color: secondarycolor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.all_inclusive,
                                        color: white,
                                      ),
                                      onPressed: () {},
                                    ),
                                    Text(
                                      'Invite',
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
      },
    );
  }
}
