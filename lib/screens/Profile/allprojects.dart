import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';
import 'package:todo/screens/project/addproject.dart';
import 'package:todo/screens/project/project.dart';

class AllProjects extends StatefulWidget {
  Workspace workspace;
  List<Project> projects;
  List<UserData> workspaceteamdata;
  AllProjects({this.projects, this.workspaceteamdata, this.workspace});
  @override
  _AllProjectsState createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  TextEditingController _searchcontroller = TextEditingController();
  String search = '';
  Widget _search() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whitebg,
        ),
        child: TextFormField(
          controller: _searchcontroller,
          keyboardType: TextInputType.text,
          maxLines: 1,
          inputFormatters: [LengthLimitingTextInputFormatter(100)],
          onChanged: (val) {
            setState(() {
              search = val;
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
            hintText: 'Search Projects ',
            hintStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => addproject(
                                workspace: widget.workspace,
                                workspaceteamdata: widget.workspaceteamdata,
                                project: Project(),
                              ),
                            ));
                      },
                    )
                  ],
                ),
                _search(),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.projects.length,
                        itemBuilder: (c, i) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjectPage(
                                      project: widget.projects[i],
                                      workspaceteam: widget.workspaceteamdata,
                                      workspace: widget.workspace,
                                    ),
                                  ));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                            backgroundColor: whitebg,
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            child: Text(
                                              widget.projects[i].projectname[0]
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                widget.projects[i].projectname,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.025,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Tasks : ${widget.projects[i].tasks.length.toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
