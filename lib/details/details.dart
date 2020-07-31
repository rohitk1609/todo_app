import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/Shared/horizontaldivider.dart';
import 'package:todo/database/database.dart';
import 'package:todo/details/categorymenu.dart';
import 'package:todo/details/slidedots.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/sharedpreference.dart';
import 'package:todo/models/team.dart';
import 'package:todo/models/user.dart';
import 'package:todo/models/workspace.dart';
import 'package:todo/models/workspacemodel.dart';
import 'package:todo/wrapper.dart';

class Details extends StatefulWidget {
  String username;
  Details({this.username});
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<Team> teamlist;
  List<Category> categorylist;
  @override
  void initState() {
    super.initState();
    teamlist = Team.getTag();
    categorylist = Category.getTag();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  bool isteamselected = false;
  String selectedteam;

  bool iscategoryselected = false;
  String selectedcategory;
  String projectname = '';
  bool loading = false;
  List<String> workspaceteam = [];
  String email = '';

  String workspacename = '';
  TextEditingController _workspacecontroller = TextEditingController();
  TextEditingController _projectcontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();

  Widget teambox(String title, String stitle) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        color: title == stitle ? secondarycolor : backgroundcolor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
          child: Text(
        title,
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  Widget _email() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[900],
      ),
      child: TextFormField(
        controller: _emailcontroller,
        keyboardType: TextInputType.text,
        maxLines: 1,
        onChanged: (val) {
          setState(() {
            email = val;
          });
        },
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15),
        decoration: InputDecoration(
          fillColor: Colors.white,
          focusColor: Colors.yellow,
          border: InputBorder.none,
          hintText: 'Enter the user email',
          hintStyle: TextStyle(
              color: secondarycolor,
              fontWeight: FontWeight.w300,
              fontFamily: 'OpenSans'),
        ),
      ),
    );
  }

  Widget _workspacename() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundcolor,
      ),
      child: TextFormField(
        controller: _workspacecontroller,
        keyboardType: TextInputType.text,
        maxLines: 1,
        inputFormatters: [LengthLimitingTextInputFormatter(100)],
        onChanged: (val) {
          setState(() {
            workspacename = val;
          });
        },
        textAlign: TextAlign.left,
        style: TextStyle(
          color: white,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          fillColor: secondarycolor,
          focusColor: Colors.yellow,
          border: InputBorder.none,
          hintText: 'Workspace Name',
          hintStyle: TextStyle(
              color: secondarycolor,
              fontWeight: FontWeight.w300,
              fontFamily: 'OpenSans'),
        ),
      ),
    );
  }

  Widget _projectname() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundcolor,
      ),
      child: TextFormField(
        controller: _projectcontroller,
        keyboardType: TextInputType.text,
        maxLines: 1,
        inputFormatters: [LengthLimitingTextInputFormatter(80)],
        onChanged: (val) {
          setState(() {
            projectname = val;
          });
        },
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          fillColor: Colors.white,
          focusColor: Colors.yellow,
          border: InputBorder.none,
          hintText: 'Project Name',
          hintStyle: TextStyle(
              color: secondarycolor,
              fontWeight: FontWeight.w300,
              fontFamily: 'OpenSans'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return ScopedModelDescendant<Workpsacemodel>(
      builder: (context, child, model) {
        return Scaffold(
          backgroundColor: secondarybackgroundcolor,
          bottomNavigationBar: _currentPage == 3
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RaisedButton(
                        color: Colors.black,
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          //usercreate

                          DatabaseService(email: user.email)
                              .UpdateUserDetails(user.uid, widget.username,
                                  user.email, user.profilepic, '', '')
                              .then((value) {
                            if (value) {
                              workspaceteam.add(user.email);
                              DatabaseService(email: user.email)
                                  .UpdateWorkspaceDetails(
                                      workspacename,
                                      [projectname],
                                      workspaceteam,
                                      [],
                                      [user.email])
                                  .then((value) {
                                if (value) {
                                  SharedPref sharedPref = SharedPref();
                                  sharedPref.save(
                                      '${user.email}currentworkspace',
                                      Workspace(
                                          workspaceuid:
                                              user.email + workspacename));
                                  DatabaseService(
                                          uid: user.email,
                                          workspaceuid:
                                              user.email + workspacename)
                                      .UpdateProjectDetails(
                                          projectname,
                                          '',
                                          DateTime.now(),
                                          [],
                                          [],
                                          user.email,
                                          '',
                                          '',
                                          [],
                                          [])
                                      .then((value) {
                                    if (value) {
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => wrapper()),
                                          (route) => false);
                                    }
                                  });
                                }
                              });
                            }
                          });
                        },
                        child: loading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                "Get started",
                                style: TextStyle(color: Colors.white),
                              ),
                      )),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: 'next',
                        onPressed: () {
                          if (_currentPage == 0) {
                            if (workspacename.isNotEmpty) {
                              _pageController.animateToPage(1,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.easeIn);
                            }
                          }
                          if (_currentPage == 1) {
                            print(projectname);
                            if (projectname.isNotEmpty) {
                              _pageController.animateToPage(2,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.easeIn);
                            }
                          }
                          if (_currentPage == 2) {
                            _pageController.animateToPage(3,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                          }
                        },
                        child: Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        ),
                        backgroundColor: black,
                      ),
                    ],
                  ),
                ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 10, left: 10, bottom: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _currentPage == 0
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: white,
                              ),
                              onPressed: () {
                                _pageController.previousPage(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeIn);
                              },
                            ),
                    ],
                  ),
                  Expanded(
                    child: PageView(
                      allowImplicitScrolling: true,
                      pageSnapping: false,
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'What is the name of your company or Workspace?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: white,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _workspacename()
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'What Project Are You Worksing on?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: white,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _projectname(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15.0, top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        '${projectname.length}/80',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Invite Team to your Workspace',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: white,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'You can invite upto 4 people using their email address. Later You can invite and Manage all Your Members in workspace Page',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: white,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.013,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _email(),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: FlatButton(
                                        color: Colors.black,
                                        onPressed: () async {
                                          if (workspaceteam.length < 5) {
                                            if (email.isNotEmpty) {
                                              setState(() {
                                                workspaceteam.add(email);
                                                print(email);
                                                email = '';
                                              });
                                              _emailcontroller.clear();
                                            }
                                          }
                                        },
                                        child: Text(
                                          "Add Team member",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: workspaceteam.length,
                                    itemBuilder: (c, i) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                              color: secondarycolor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                workspaceteam[i],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.clear,
                                                    color: Colors.white),
                                                onPressed: () {
                                                  setState(() {
                                                    workspaceteam.remove(
                                                        workspaceteam[i]);
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Text("aaa"),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < 4; i++)
                        if (i == _currentPage)
                          SlideDots(true)
                        else
                          SlideDots(false)
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
