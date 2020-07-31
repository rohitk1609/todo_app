import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/attachment.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/user.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';
import 'package:todo/screens/project/addproject.dart';
import 'package:todo/screens/task/addtask.dart';
import 'package:http/http.dart' as http;

class ProjectPage extends StatefulWidget {
  Workspace workspace;
  Project project;
  List<UserData> workspaceteam;
  ProjectPage({this.project, this.workspaceteam, this.workspace});
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  bool isdownload = false;
  Widget profile() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.07,
            backgroundColor: Colors.black,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          Text(
            "Rohit kumar",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width * 0.03),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget files(Attachment attachment) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(color: Colors.grey[300], spreadRadius: 1, blurRadius: 4)
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(attachment.filename,
                      style:
                          TextStyle(color: black, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('File size:${attachment.filesize}',
                      style: TextStyle(color: black)),
                ],
              ),
              isdownload
                  ? CircularProgressIndicator(
                      value: progress.toDouble(),
                    )
                  : IconButton(
                      icon: Icon(Icons.file_download),
                      color: Colors.black,
                      onPressed: () async {
                        setState(() {
                          isdownload = true;
                        });
                        downloadurl(
                            attachment.downloadurl, attachment.filename);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  TabController tabController;
  ExpandableController expandableController;
  List<Task> inprogresstasks = [];
  List<Task> upcomingtasks = [];
  List<Task> completedtasks = [];
  List<File> all = [];
  List<Attachment> attachments = [];
  Map<String, String> _paths;
  List<UserData> projectteamdata = [];

  int progress = 0;

  ReceivePort _receivePort = ReceivePort();
  static downloadingcallback(id, status, progress) {
    SendPort sendport = IsolateNameServer.lookupPortByName('downloading');
    sendport.send([id, status, progress]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'downloading');

    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
    });
    FlutterDownloader.registerCallback(downloadingcallback);
    tabController = TabController(length: 3, vsync: this);
    expandableController = ExpandableController();
    getprojectteamdata();
  }

  getprojectteamdata() {
    for (int i = 0; i < widget.project.projectteam.length; i++) {
      var userdata = widget.workspaceteam.forEach((element) {
        if (element.email == widget.project.projectteam[i]) {
          setState(() {
            projectteamdata.add(element);
          });
        }
      });
    }
    print(projectteamdata.length);
  }

  String _extension;
  uploadfile(filename, filepath) async {
    String temp = widget.workspace.workspaceuid + widget.project.projectname;
    _extension = filename.toString().split('.').last;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("$temp/${filename.toString().split('/').last}");
    final StorageUploadTask uploadTask =
        storageReference.putFile(File(filepath));
    StorageMetadata(
      contentType: '/$_extension',
    );
    setState(() {
      _tasks.add(uploadTask);
    });
  }

  bool complete = false;

  uploadtofirebase() {
    _paths.forEach((filename, filepath) {
      uploadfile(filename, filepath);
    });
  }

  Align dropdown(List<Widget> children) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          child: DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.7,
            builder: (BuildContext context, myscrollController) {
              return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 15, right: 15),
                    child: ListView(
                      controller: myscrollController,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height:
                                  MediaQuery.of(context).size.height * 0.006,
                              decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Text(
                            "Project info",
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Divider(
                            color: black,
                            thickness: 3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 15),
                          child: Text(
                            "Project Description",
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 15),
                          child: Text(
                            widget.project.projectdescription,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Text(
                            "Project Attachments",
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          children: children,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.project.attachments.length,
                            itemBuilder: (c, i) {
                              return files(
                                widget.project.attachments[i],
                              );
                            }),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 15, top: 15),
                            child: FlatButton(
                              splashColor: Colors.grey[200],
                              color: black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                  onTap: () async {
                                                    try {
                                                      _paths = null;

                                                      _paths = await FilePicker
                                                          .getMultiFilePath(
                                                              type: FileType
                                                                  .image);

                                                      Navigator.pop(context);
                                                    } on PlatformException catch (e) {
                                                      print(
                                                          'unsupported operatiom ' +
                                                              e.toString());
                                                    }
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    uploadtofirebase();

                                                    //uploadtofirebasedocument();
                                                    print(
                                                        'aaaaaaaaaaaaaaa $attachments');
                                                  },
                                                  child: Text(
                                                    "image",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                              ),
                                              InkWell(
                                                  onTap: () async {
                                                    try {
                                                      List<File> p;
                                                      p = await FilePicker
                                                          .getMultiFile(
                                                              type: FileType
                                                                  .custom,
                                                              allowedExtensions: [
                                                            'pdf'
                                                          ]);

                                                      print(p[0].lengthSync());

                                                      setState(() {
                                                        all.addAll(p);
                                                      });
                                                      Navigator.pop(context);
                                                    } on PlatformException catch (e) {
                                                      print(
                                                          'unsupported operatiom ' +
                                                              e.toString());
                                                    }
                                                  },
                                                  child: Text(
                                                    "pdf",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                              ),
                                              InkWell(
                                                  onTap: () async {
                                                    try {
                                                      List<File> o;
                                                      o = await FilePicker
                                                          .getMultiFile(
                                                              type:
                                                                  FileType.any);

                                                      print(o[0].lengthSync());

                                                      setState(() {
                                                        all.addAll(o);
                                                      });
                                                      Navigator.pop(context);
                                                    } on PlatformException catch (e) {
                                                      print(
                                                          'unsupported operatiom ' +
                                                              e.toString());
                                                    }
                                                  },
                                                  child: Text(
                                                    "Others",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "Add More Attachments",
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 15),
                          child: Text(
                            "Team Members",
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, bottom: 20),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: projectteamdata.length,
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
                                              projectteamdata[i].profilepic),
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
                                                projectteamdata[i]
                                                    .username
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'product manager',
                                                style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.graphic_eq,
                                            color: black,
                                          ),
                                          onPressed: () {},
                                        )
                                      ],
                                    ),
                                  );
                                  Padding(
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
                                              projectteamdata[i].profilepic),
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
                                                projectteamdata[i]
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
                      ],
                    ),
                  ));
            },
          ),
        ),
      );

  Widget display() {
    return Container(
      decoration: BoxDecoration(color: secondarybackgroundcolor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
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
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.add),
                        color: white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Addtask(
                                        projectteamdata: projectteamdata,
                                        projectuid: widget.project.projectuid,
                                      )));
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => addproject(
                                        project: widget.project,
                                        workspaceteamdata: widget.workspaceteam,
                                        workspace: widget.workspace,
                                      )));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
            child: Text(
              widget.project.projectname,
              style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.07),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, bottom: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.55,
                    decoration: BoxDecoration(
                        color: secondarycolor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.select_all,
                          color: white,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Text(
                          "Deadline : Navember 12",
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget taskbox(Task task) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: new ExpansionTile(
          title: Text(
            task.taskname,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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

  Widget _upcoming(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (c, index) {
        if (tasks[index].status == 'upcoming') {
          return taskbox(tasks[index]);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _completed(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (c, index) {
        if (tasks[index].status == 'completed') {
          return taskbox(tasks[index]);
        } else {
          return Container();
        }
      },
    );
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  downloadurl(String url, String filename) async {
    http.Response downloadData = await http.get(url);

    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externaldir = await getExternalStorageDirectory();

      final id = FlutterDownloader.enqueue(
          url: url,
          savedDir: externaldir.path,
          fileName: filename,
          showNotification: true,
          openFileFromNotification: true);
    } else {
      print(" permission denied");
    }
  }

  downloadfile(StorageReference ref) async {
    print('aaa');

    final String url = await ref.getDownloadURL();
    http.Response downloadData = await http.get(url);

    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externaldir = await getExternalStorageDirectory();

      final id = FlutterDownloader.enqueue(
          url: url,
          savedDir: externaldir.path,
          fileName: "${ref.path.split('/').last}",
          showNotification: true,
          openFileFromNotification: true);
    } else {
      print(" permission denied");
    }
  }

  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    _tasks.forEach((element) {
      final Widget tile = Uploadtaks(
        task: element,
        uid: widget.project.projectuid,
        onDownload: () => downloadfile(element.lastSnapshot.ref),
        ondissmissed: () {
          setState(() {
            _tasks.remove(element);
          });
        },
      );
      children.add(tile);
    });
    return StreamBuilder<List<Task>>(
        stream: DatabaseService(projectuid: widget.project.projectuid).tasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            List<Task> tasks = snapshot.data;

            return Scaffold(
              backgroundColor: secondarybackgroundcolor,
              body: SafeArea(
                child: Stack(
                  children: <Widget>[
                    NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext c, bool innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            iconTheme: IconThemeData(color: white),
                            actionsIconTheme:
                                IconThemeData(color: Colors.black),
                            pinned: true,
                            backgroundColor: secondarybackgroundcolor,
                            flexibleSpace: FlexibleSpaceBar(
                                collapseMode: CollapseMode.pin,
                                background: display()),
                            expandedHeight:
                                MediaQuery.of(context).size.height * 0.32,
                            bottom: TabBar(
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
                          ),
                        ];
                      },
                      body: TabBarView(
                        controller: tabController,
                        children: <Widget>[
                          _inprogress(tasks),
                          _upcoming(tasks),
                          _completed(tasks)
                        ],
                      ),
                    ),
                    dropdown(children)
                  ],
                ),
              ),
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
  }
}

class Uploadtaks extends StatefulWidget {
  final String uid;
  final StorageUploadTask task;
  final VoidCallback ondissmissed;
  final VoidCallback onDownload;

  const Uploadtaks(
      {Key key, this.task, this.ondissmissed, this.onDownload, this.uid})
      : super(key: key);

  @override
  _UploadtaksState createState() => _UploadtaksState();
}

class _UploadtaksState extends State<Uploadtaks> {
  String bytestransferred(StorageTaskSnapshot snapshot) {
    String temp = (snapshot.totalByteCount * 0.000001).toStringAsFixed(2);
    String temp2 = (snapshot.bytesTransferred * 0.000001).toStringAsFixed(2);
    return '$temp2/$temp';
  }

  bool complete = false;

  String get status {
    String result;
    if (widget.task.isComplete) {
      if (widget.task.isSuccessful) {
        result = 'Complete';
      } else if (widget.task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${widget.task.lastSnapshot.error}';
      }
    } else if (widget.task.isInProgress) {
      result = 'Uploading';
    } else if (widget.task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  Future<String> geturl(StorageUploadTask task) async {
    String url = await task.lastSnapshot.ref.getDownloadURL();
    return url;
  }

  double _percentage = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: widget.task.events,
      builder:
          (BuildContext context, AsyncSnapshot<StorageTaskEvent> snapshot) {
        Widget subtitle;
        Widget progress;
        if (snapshot.hasData) {
          if ((widget.task.isComplete && widget.task.isSuccessful)) {
            geturl(widget.task).then((value) {
              DatabaseService(projectuid: widget.uid).updateattachments(Attachment(
                  downloadurl: value,
                  filename:
                      '${widget.task.lastSnapshot.ref.path.split('/').last}',
                  ref: widget.task.lastSnapshot.ref,
                  filesize:
                      '${snapshot.data.snapshot.totalByteCount.toString()}'));
            });
          }
          final StorageTaskEvent event = snapshot.data;
          final StorageTaskSnapshot ssnapshot = event.snapshot;
          var percentage =
              ssnapshot.bytesTransferred / ssnapshot.totalByteCount * 100;
          _percentage = percentage / 100;

          progress = LinearProgressIndicator(
            value: _percentage,
          );
          subtitle = Text('$status: ${bytestransferred(ssnapshot)} Mb sent');
        } else {
          subtitle = Text('starting');
        }
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
          child: GestureDetector(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300], spreadRadius: 1, blurRadius: 4)
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${widget.task.lastSnapshot.ref.path.split('/').last}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle,
                        SizedBox(
                          width: 100,
                          child: progress,
                        )
                      ],
                    ),
                    Offstage(
                      offstage: !widget.task.isInProgress,
                      child: IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: () => widget.task.pause(),
                      ),
                    ),
                    Offstage(
                      offstage: !widget.task.isPaused,
                      child: IconButton(
                        icon: Icon(Icons.file_upload),
                        onPressed: () => widget.task.resume(),
                      ),
                    ),
                    Offstage(
                      offstage: widget.task.isComplete,
                      child: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () => widget.task.cancel(),
                      ),
                    ),
                    Offstage(
                      offstage:
                          !(widget.task.isComplete && widget.task.isSuccessful),
                      child: IconButton(
                        icon: const Icon(Icons.file_download),
                        onPressed: widget.onDownload,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /*ListTile(
              title: Text('Upload task #${widget.task.hashCode}'),
              subtitle: subtitle,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Offstage(
                    offstage: !widget.task.isInProgress,
                    child: IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: () => widget.task.pause(),
                    ),
                  ),
                  Offstage(
                    offstage: !widget.task.isPaused,
                    child: IconButton(
                      icon: Icon(Icons.file_upload),
                      onPressed: () => widget.task.resume(),
                    ),
                  ),
                  Offstage(
                    offstage: widget.task.isComplete,
                    child: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () => widget.task.cancel(),
                    ),
                  ),
                  Offstage(
                    offstage: !(widget.task.isComplete && widget.task.isSuccessful),
                    child: IconButton(
                      icon: const Icon(Icons.file_download),
                      onPressed: widget.onDownload,
                    ),
                  ),
                ],
              ),
            ),*/
          ),
        );
      },
    );
  }
}
