import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/teammember.dart';
import 'package:todo/models/user.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';
import 'package:todo/screens/Profile/addteam.dart';
import 'package:todo/screens/project/preview/image.dart';
import 'package:todo/screens/project/preview/other.dart';
import 'package:todo/screens/project/preview/pdf.dart';

class addproject extends StatefulWidget {
  Project project;
  Workspace workspace;
  List<UserData> workspaceteamdata;
  addproject({this.workspace, this.workspaceteamdata, this.project});
  @override
  _addprojectState createState() => _addprojectState();
}

class _addprojectState extends State<addproject> {
  String projectname = '';
  String description = '';
  int dlength = 0;
  String projectlink = '';
  List<String> projectteammembers = [];

  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  DateTime projectdeadline = DateTime.now();
  String extention;
  String filepath;
  List<File> imagefiles = [];
  List<File> otherfiles = [];
  List<File> pdffiles = [];
  List<String> attachmentdownloadurls = [];
  List<File> all = [];
  bool valid = false;
  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      projectname =
          widget.project.projectname == null ? '' : widget.project.projectname;
      description = widget.project.projectdescription == null
          ? ''
          : widget.project.projectdescription;
      projectdeadline = widget.project.projectdeadline == null
          ? DateTime.now()
          : widget.project.projectdeadline;

      projectteammembers =
          widget.project.projectteam == null ? [] : widget.project.projectteam;
      projectlink = widget.project.projectlinks == null
          ? ''
          : widget.project.projectlinks;
    });
    projectteammembers.remove(widget.project.projectowner);
    setState(() {
      projectteammembers = projectteammembers;
    });

    super.initState();
  }

  bool loading = false;
  Future<Null> _projectdeadline(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: projectdeadline,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != projectdeadline)
      setState(() {
        projectdeadline = picked;
      });
  }

  Future<List<String>> upload(List<File> files) async {
    String temp = widget.workspace.workspaceuid + projectname;
    for (int i = 0; i < files.length; i++) {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child("$temp/${files[i].path.split('/').last}");
      final StorageUploadTask uploadTask = storageReference.putFile(files[i]);
      final StorageTaskSnapshot downloadurl = (await uploadTask.onComplete);
      final String url = (await downloadurl.ref.getDownloadURL());
      setState(() {
        attachmentdownloadurls.add(url);
      });
    }
    return attachmentdownloadurls;
  }

  Widget _projectname() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: secondarycolor,
        ),
        child: TextFormField(
          readOnly: true,
          initialValue: projectname,
          keyboardType: TextInputType.text,
          maxLines: 1,
          inputFormatters: [LengthLimitingTextInputFormatter(100)],
          onChanged: (val) {
            setState(() {
              projectname = val;
            });
          },
          textAlign: TextAlign.left,
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.height * 0.015,
          ),
          decoration: InputDecoration(
            fillColor: white,
            border: InputBorder.none,
            hintText: 'project Name',
            hintStyle: TextStyle(
                color: white,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height * 0.015,
                fontFamily: 'OpenSans'),
          ),
        ),
      ),
    );
  }

  Widget _projectlink() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: secondarycolor,
        ),
        child: TextFormField(
          initialValue: projectlink,
          keyboardType: TextInputType.text,
          maxLines: 1,
          inputFormatters: [LengthLimitingTextInputFormatter(100)],
          onChanged: (val) {
            setState(() {
              projectlink = val;
            });
          },
          textAlign: TextAlign.left,
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.height * 0.015,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'project link',
            hintStyle: TextStyle(
                color: white,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height * 0.015,
                fontFamily: 'OpenSans'),
          ),
        ),
      ),
    );
  }

  Widget attach() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () async {
                              try {
                                List<File> i;
                                i = await FilePicker.getMultiFile(
                                    type: FileType.image);

                                print(i[0].lengthSync());

                                setState(() {
                                  all.addAll(i);
                                });
                                Navigator.pop(context);
                              } on PlatformException catch (e) {
                                print('unsupported operatiom ' + e.toString());
                              }
                            },
                            child: Text(
                              "image",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        InkWell(
                            onTap: () async {
                              try {
                                List<File> p;
                                p = await FilePicker.getMultiFile(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf']);

                                print(p[0].lengthSync());

                                setState(() {
                                  all.addAll(p);
                                });
                                Navigator.pop(context);
                              } on PlatformException catch (e) {
                                print('unsupported operatiom ' + e.toString());
                              }
                            },
                            child: Text(
                              "pdf",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        InkWell(
                            onTap: () async {
                              try {
                                List<File> o;
                                o = await FilePicker.getMultiFile(
                                    type: FileType.any);

                                print(o[0].lengthSync());

                                setState(() {
                                  all.addAll(o);
                                });
                                Navigator.pop(context);
                              } on PlatformException catch (e) {
                                print('unsupported operatiom ' + e.toString());
                              }
                            },
                            child: Text(
                              "Others",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ))
                      ],
                    ),
                  ),
                );
              });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            color: secondarycolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${all.length.toString()} Attach file",
                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget team() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: InkWell(
        onTap: () async {
          //print("llllllllllllll");
          //print(teammembers);
          dynamic t = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Addteam(
                        workspace: widget.workspace,
                        workspaceteamdata: widget.workspaceteamdata,
                        projectteam: projectteammembers,
                      )));
          if (t != null) {
            setState(() {
              projectteammembers = t;
            });
          }
          print('aaaaaaaaaaa');
          print(projectteammembers);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            color: secondarycolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${projectteammembers.length.toString()} team members",
                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: secondarycolor,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
            minHeight: MediaQuery.of(context).size.height * 0.15,
          ),
          child: TextFormField(
            initialValue: description,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 20,
            inputFormatters: [LengthLimitingTextInputFormatter(100)],
            onChanged: (val) {
              setState(() {
                description = val;
                dlength = val.length;
              });
            },
            textAlign: TextAlign.left,
            style: TextStyle(
              color: white,
              fontWeight: FontWeight.normal,
              fontSize: MediaQuery.of(context).size.height * 0.015,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: Colors.yellow,
              border: InputBorder.none,
              hintText: 'Description',
              hintStyle: TextStyle(
                  color: white,
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                  fontFamily: 'OpenSans'),
            ),
          ),
        ),
      ),
    );
  }

  Widget attachbox(
      String number, IconData icon, Color color, Function function) {
    return InkWell(
      onTap: function,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'View Your Attachments',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  int selectedteam = 0;

  Widget date() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: InkWell(
        onTap: () {
          _projectdeadline(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: secondarycolor,
            borderRadius: BorderRadius.circular(10),
          ),
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "${projectdeadline.toLocal()}".split(' ')[0],
                  style: TextStyle(color: white, fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.calendar_today,
                  color: white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  callback(List<File> files) {
    setState(() {
      this.all = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: secondarybackgroundcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "creating and uploading to database",
                      style: TextStyle(color: white),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 15),
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
                            IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: white,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              image: AssetImage('assets/images/people.jpg'))),
                      child: Column(
                        children: <Widget>[],
                      ),
                    ),
                    _projectname(),
                    _description(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${dlength.toString()}/100',
                            style: TextStyle(color: white),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.timer_off,
                            color: white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Project Deadline",
                              style: TextStyle(
                                  color: white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.022,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    date(),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.people,
                            color: white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Add Team",
                              style: TextStyle(
                                  color: white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.022,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    team(),
                    /* Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 20.0, right: 20, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.attach_file,
                            color: white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Attach",
                              style: TextStyle(
                                  color: white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.022,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),*/
                    //attach(),
                    /* Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 20, left: 20, right: 20),
                      child: attachbox(imagefiles.length.toString(),
                          Icons.image, secondarycolor, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Imagepreview(
                                files: all,
                                callback: callback,
                              ),
                            ));
                      }),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 10, top: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.link,
                            color: white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Project link",
                              style: TextStyle(
                                  color: white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.022,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    _projectlink(),
                    valid
                        ? Center(
                            child: Text(
                              'enter project name',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton.extended(
                              onPressed: () {
                                if (projectname.isNotEmpty) {
                                  setState(() {
                                    loading = true;
                                    projectteammembers.add(user.email);
                                  });

                                  DatabaseService(
                                    workspaceuid: widget.workspace.workspaceuid,
                                  )
                                      .UpdateProjectDetails(
                                          projectname,
                                          description,
                                          projectdeadline,
                                          projectteammembers,
                                          [],
                                          user.email,
                                          projectlink,
                                          'inprogress',
                                          [],
                                          [])
                                      .then((v) {
                                    if (v == true) {
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  });
                                } else {
                                  setState(() {
                                    valid = true;
                                  });
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              icon: Icon(Icons.add),
                              backgroundColor: secondarycolor,
                              label: loading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      "Create Project",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
