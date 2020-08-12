import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/user.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';
import 'package:todo/screens/task/assigntask.dart';

class Addtask extends StatefulWidget {
  List<UserData> projectteamdata;

  String projectuid;
  Addtask({this.projectteamdata, this.projectuid});
  @override
  _AddtaskState createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  String taskname = '';
  List<File> files = [];
  bool loading = false;
  DateTime enddate = DateTime.now();
  DateTime startdate = DateTime.now();
  List<String> assignedlist = [];
  int dlength = 0;
  List<String> attachmentdownloadurls = [];
  TextEditingController _descriptioncontroller = TextEditingController();
  String description = '';
  Future<Null> _enddate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: enddate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != enddate)
      setState(() {
        enddate = picked;
      });
  }

  Future<Null> _startdate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: startdate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startdate)
      setState(() {
        startdate = picked;
      });
  }

  Future<List<String>> upload(List<File> files) async {
    String temp = widget.projectuid;
    for (int i = 0; i < files.length; i++) {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child("$temp/$taskname/${files[i].path.split('/').last}");
      final StorageUploadTask uploadTask = storageReference.putFile(files[i]);
      final StorageTaskSnapshot downloadurl = (await uploadTask.onComplete);
      final String url = (await downloadurl.ref.getDownloadURL());
      setState(() {
        attachmentdownloadurls.add(url);
      });
    }
    return attachmentdownloadurls;
  }

  Widget _taskname() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey[200], spreadRadius: 2, blurRadius: 4)
            ]),
        child: TextFormField(
          keyboardType: TextInputType.text,
          maxLines: 1,
          inputFormatters: [LengthLimitingTextInputFormatter(100)],
          onChanged: (val) {
            setState(() {
              taskname = val;
            });
          },
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.height * 0.015,
          ),
          decoration: InputDecoration(
            fillColor: Colors.black,
            border: InputBorder.none,
            hintText: 'Task Name',
            hintStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height * 0.015,
                fontFamily: 'OpenSans'),
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
                  builder: (context) => Assignteam(
                        projectteamdata: widget.projectteamdata,
                        taskteam: assignedlist,
                      )));
          if (t != null) {
            setState(() {
              assignedlist = t;
            });
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[200], spreadRadius: 2, blurRadius: 4),
              ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${assignedlist.length.toString()} team members",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
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
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey[200], spreadRadius: 1, blurRadius: 4)
            ]),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
            minHeight: MediaQuery.of(context).size.height * 0.15,
          ),
          child: TextFormField(
            controller: _descriptioncontroller,
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
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: MediaQuery.of(context).size.height * 0.015,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: Colors.yellow,
              border: InputBorder.none,
              hintText: 'Description',
              hintStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                  fontFamily: 'OpenSans'),
            ),
          ),
        ),
      ),
    );
  }

  Widget attach() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: InkWell(
        onTap: () async {
          try {
            List<File> i;
            i = await FilePicker.getMultiFile(type: FileType.image);

            print(i[0].lengthSync());

            setState(() {
              files.addAll(i);
            });
          } on PlatformException catch (e) {
            print('unsupported operatiom ' + e.toString());
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[200], spreadRadius: 2, blurRadius: 4),
              ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  " ${files.length.toString()} Attach file",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
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
    final user = Provider.of<User>(context);
    print(widget.projectuid);
    return Scaffold(
      backgroundColor: Colors.white,
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
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () {},
                          ),
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2,
                      color: Colors.grey[200],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 15, bottom: 10),
                      child: Text(
                        "Task Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.02),
                      ),
                    ),
                    _taskname(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 20, bottom: 10),
                          child: Text(
                            "Start Date",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 20, bottom: 10),
                          child: Text(
                            "End Date",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: InkWell(
                            onTap: () {
                              _startdate(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200],
                                        spreadRadius: 1,
                                        blurRadius: 2)
                                  ]),
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "${startdate.toLocal()}".split(' ')[0],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: InkWell(
                            onTap: () {
                              _enddate(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200],
                                        spreadRadius: 1,
                                        blurRadius: 2)
                                  ]),
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "${enddate.toLocal()}".split(' ')[0],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 20, bottom: 10),
                      child: Text(
                        "Task Description",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.02),
                      ),
                    ),
                    _description(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${dlength.toString()}/100',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 20, bottom: 10),
                      child: Text(
                        "Assigned to",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.02),
                      ),
                    ),
                    team(),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 20, bottom: 10),
                      child: Text(
                        "Attachments",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.02),
                      ),
                    ),
                    attach(),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: FloatingActionButton.extended(
                          onPressed: () {
                            setState(() {
                              loading = true;
                            });

                            upload(files).then((value) {
                              DatabaseService(projectuid: widget.projectuid)
                                  .UpdateTaskDetails(
                                taskname,
                                description,
                                startdate,
                                enddate,
                                assignedlist,
                                attachmentdownloadurls,
                                user.email,
                              )
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
                              print(value);
                            });
                          },
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          label: Text(
                            "CREATE TASK",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.4),
                          )),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
