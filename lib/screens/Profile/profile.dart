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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter state) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: whitebg,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Wrap(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Center(
                                        child: Container(
                                          height: 10,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          decoration: BoxDecoration(
                                              color: whitebg,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: widget.workspaces.length,
                                        itemBuilder: (c, i) {
                                          return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: RadioListTile(
                                                activeColor: white,
                                                groupValue: selectedradiotile,
                                                onChanged: (val) {
                                                  state(() {
                                                    selectedradiotile = val;
                                                  });
                                                  sharedPref.remove(
                                                      '${widget.userdata.email}currentworkspace');
                                                  sharedPref.save(
                                                      '${widget.userdata.email}currentworkspace',
                                                      widget.workspaces[val]);

                                                  loadcurrentworkspace();
                                                  Navigator.pop(context);
                                                },
                                                value: i,
                                                title: Text(
                                                  '${widget.workspaces[i].workspacename}',
                                                  style:
                                                      TextStyle(color: white),
                                                ),
                                              ));
                                        }),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: FlatButton(
                                            color: secondarycolor,
                                            onPressed: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddWorkspace(),
                                                  ));
                                            },
                                            child: Text(
                                              "Add Workspace",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                      widget.workspaces[selectedradiotile].workspacename,
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.02),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.all_inclusive,
                  color: black,
                ),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            backgroundColor: Colors.grey[800],
            radius: MediaQuery.of(context).size.width * 0.1,
            child: Icon(
              Icons.adjust,
              color: white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.userdata.username,
            style: TextStyle(
                color: black,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.02),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'CEO',
            style: TextStyle(
                color: black,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height * 0.02),
          ),
        ],
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
      padding: const EdgeInsets.only(bottom: 10.0),
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
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[200], spreadRadius: 1, blurRadius: 5)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      project.projectname,
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.height * 0.018),
                    ),
                    CircleAvatar(
                      backgroundColor: green,
                      radius: MediaQuery.of(context).size.width * 0.02,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: blackbg,
                          radius: MediaQuery.of(context).size.width * 0.03,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        CircleAvatar(
                          backgroundColor: blackbg,
                          radius: MediaQuery.of(context).size.width * 0.03,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '+5 others',
                          style: TextStyle(
                              color: secondarycolor,
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: secondarycolor,
                          size: MediaQuery.of(context).size.height * 0.02,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Nov, 29 2020',
                          style: TextStyle(
                              color: secondarycolor,
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: project.projectdescription.isNotEmpty,
                  child: Text(
                    project.projectdescription,
                    maxLines: 2,
                    style: TextStyle(
                        color: secondarycolor,
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.height * 0.014),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _team() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.13,
      width: MediaQuery.of(context).size.width / 4 - 10,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: green,
            radius: MediaQuery.of(context).size.width * 0.07,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Rohit',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: black, fontWeight: FontWeight.w500),
          ),
          Text(
            'Product',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style:
                TextStyle(color: secondarycolor, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return selectedradiotile == null ||
            widget.userdata == null ||
            widget.workspaces == null
        ? Scaffold(
            backgroundColor: whitebg,
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
              if (snapshot.hasData) {
                List<Project> projects = snapshot.data;
                return SafeArea(
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        profileBox(widget.userdata),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Projects",
                                  style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.018),
                                ),
                                Text(
                                  'all projects',
                                  style: TextStyle(
                                      color: primarycolor,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.018),
                                ),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: projects.length,
                                itemBuilder: (c, i) {
                                  return projectBox(projects[i]);
                                })),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Team",
                                style: TextStyle(
                                    color: black,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.018),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20,
                              top: 10,
                            ),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              children: <Widget>[
                                _team(),
                                _team(),
                                _team(),
                                _team(),
                                _team(),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[200],
                                      spreadRadius: 1,
                                      blurRadius: 5)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: primarycolor,
                                    radius: MediaQuery.of(context).size.width *
                                        0.08,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        text(
                                            'Invite',
                                            0.02,
                                            FontWeight.bold,
                                            black,
                                            1,
                                            TextOverflow.ellipsis,
                                            context),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Invite Members to your team and jave fun,tonight is the column o f as sjbas naso',
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: secondarycolor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            });
  }
}
