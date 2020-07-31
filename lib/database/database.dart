//import 'dart:html';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/attachment.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/teammember.dart';
import 'package:todo/models/user.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';

class DatabaseService {
  final String uid;
  final String email;
  final String workspaceuid;
  final String projectuid;
  DatabaseService({this.uid, this.email, this.workspaceuid, this.projectuid});

  //...............................................................USER

  final CollectionReference UsersCollection =
      Firestore.instance.collection('Users');

  Future<bool> UpdateUserDetails(
    String uid,
    String username,
    String email,
    String profilepic,
    String team,
    String category,
  ) async {
    try {
      await UsersCollection.document(email).setData({
        'uid': uid,
        'username': username,
        'profilepic': profilepic,
        'email': email,
        'team': team,
        'category': category
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    bool temp;
    await UsersCollection.where('username', isEqualTo: username)
        .getDocuments()
        .then((value) {
      bool result = value.documents.isEmpty;
      temp = result;
    });

    return temp;
  }

  User _userFromSnapShot(DocumentSnapshot snapshot) {
    return User(
      uid: snapshot.data["uid"],
      email: snapshot.data["email"],
      profilepic: snapshot.data["profilepic"],
    );
  }

  UserData _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return UserData(
      username: snapshot.data["username"],
      uid: snapshot.data["uid"],
      email: snapshot.data["email"],
      profilepic: snapshot.data['profilepic'],
      team: snapshot.data['team'],
      category: snapshot.data['category'],
    );
  }

  Stream<UserData> get userData {
    return UsersCollection.document(email)
        .snapshots()
        .map(_userDataFromSnapShot);
  }

  Stream<User> get user {
    return UsersCollection.document(email).snapshots().map(_userFromSnapShot);
  }

  Future<UserData> getuserdata(String e) async {
    UserData userdata;
    await UsersCollection.document(e).get().then((value) {
      userdata = UserData(
        uid: value.data['uid'] == null ? '' : value.data['uid'],
        username: value.data['username'] == null ? '' : value.data['username'],
        category: value.data['category'] == null ? '' : value.data['category'],
        team: value.data['team'] == null ? '' : value.data['team'],
        profilepic:
            value.data['profilepic'] == null ? '' : value.data['profilepic'],
        email: value.data['email'] == null ? '' : value.data['email'],
      );
    });
    print("................................");
    print(userdata);
    return userdata;
  }

  //..............................................................................//Workspace

  final CollectionReference WorkspaceCollection =
      Firestore.instance.collection('Workspaces');

  Future<bool> UpdateWorkspaceDetails(
    String workspacename,
    List<String> projects,
    List<String> team,
    List<String> tasks,
    List<String> access,
  ) async {
    try {
      String temp = email + workspacename;
      print(".....................");
      print(team);
      await WorkspaceCollection.document(temp).setData({
        'workspaceuid': temp,
        'workspacename': workspacename,
        'owner': email,
        'projects': projects,
        'team': team,
        'tasks': tasks,
        'access': access
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  List<Workspace> _workspaceDataFromSnapShot(QuerySnapshot querysnapshot) {
    print(querysnapshot);
    return querysnapshot.documents.map((snapshot) {
      print('aa');
      print(snapshot.data['workspacename']);
      if (snapshot.data.isNotEmpty)
        return Workspace(
          workspaceuid: snapshot.data['workspaceuid'],
          workspacename: snapshot.data['workspacename'],
          owner: snapshot.data['owner'],
          team: List.from(snapshot.data['team']),
          access: List.from(snapshot.data['access']),
          projects: List.from(snapshot.data['projects']),
          tasks: List.from(snapshot.data['tasks']),
        );
    }).toList();
  }

  Stream<List<Workspace>> get workspaces {
    return WorkspaceCollection.where('owner', isEqualTo: email)
        .snapshots()
        .map(_workspaceDataFromSnapShot);
  }

  Workspace _currentworkspacefromsnapshot(DocumentSnapshot snapshot) {
    return Workspace(
      workspaceuid: snapshot.data['workspaceuid'],
      workspacename: snapshot.data['workspacename'],
      owner: snapshot.data['owner'],
      team: List.from(snapshot.data['team']),
      access: List.from(snapshot.data['access']),
      projects: List.from(snapshot.data['projects']),
      tasks: List.from(snapshot.data['tasks']),
    );
  }

  Stream<Workspace> get currentworkspace {
    return WorkspaceCollection.document(workspaceuid)
        .snapshots()
        .map(_currentworkspacefromsnapshot);
  }

  //................................................................Project

  final CollectionReference ProjectCollection =
      Firestore.instance.collection('Projects');

  Future<bool> UpdateProjectDetails(
    String projectname,
    String projectdescription,
    DateTime projectdeadline,
    List<String> projectteam,
    List<String> projectaccess,
    String projectowner,
    String projectlinks,
    String status,
    List<Attachment> attachments,
    List<String> projecttasks,
  ) async {
    try {
      print(".....................");
      String temp = workspaceuid + projectname;
      await ProjectCollection.document(temp).setData({
        'projectuid': temp,
        'projectname': projectname,
        'projectdescription': projectdescription,
        'projectowner': projectowner,
        'projectdeadline': projectdeadline,
        'projectteam': projectteam,
        'projectaccess': projectaccess,
        'status': status,
        'projectlinks': projectlinks,
        'projecttasks': projecttasks,
        'attachments': attachments.map((e) => e.toJson()).toList(),
        'workspaceuid': workspaceuid,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateattachments(
    Attachment attachments,
  ) async {
    try {
      await ProjectCollection.document(projectuid).updateData({
        'attachments': FieldValue.arrayUnion([attachments.toJson()]),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  List<Project> _projectDataFromSnapShot(QuerySnapshot querysnapshot) {
    return querysnapshot.documents.map((snapshot) {
      print(snapshot.data['projectaccess']);
      print('aaa ${snapshot.data['attachments']}');

      return Project(
        workspaceuid: snapshot.data['workspaceuid'],
        projectuid: snapshot.data['projectuid'],
        projectname: snapshot.data['projectname'],
        projectdescription: snapshot.data['projectdescription'] == null
            ? ''
            : snapshot.data['projectdescription'],
        projectowner: snapshot.data['projectowner'],
        projectteam: List.from(snapshot.data['projectteam']) == null
            ? []
            : List.from(snapshot.data['projectteam']),
        projectaccess: List.from(snapshot.data['projectaccess']) == null
            ? []
            : List.from(snapshot.data['projectaccess']),
        status: snapshot.data['status'] == null ? '' : snapshot.data['status'],
        projectlinks: snapshot.data['projectlinks'] == null
            ? ''
            : snapshot.data['projectlinks'],
        tasks: List.from(snapshot.data['projecttasks']),
        attachments: snapshot.data['attachments'].map<Attachment>((e) {
          return Attachment.fromJson(e);
        }).toList(),
      );
    }).toList();
  }

  Stream<List<Project>> get projects {
    return ProjectCollection.where('workspaceuid', isEqualTo: workspaceuid)
        .snapshots()
        .map(_projectDataFromSnapShot);
  }

  Stream<List<Project>> get myprojects {
    return ProjectCollection.where('projectowner', isEqualTo: email)
        .snapshots()
        .map(_projectDataFromSnapShot);
  }

  final CollectionReference TimeCollection =
      Firestore.instance.collection('Currenttimer');

  //.................................................task/

  final CollectionReference TaskCollection =
      Firestore.instance.collection('Tasks');

  Future<bool> UpdateTaskDetails(
    String taskname,
    String taskdescription,
    DateTime startdate,
    DateTime enddate,
    List<String> assignedto,
    List<String> attachments,
    String createdby,
  ) async {
    try {
      print(projectuid);

      String temp = projectuid + taskname;

      await TaskCollection.document(temp).setData({
        'taskuid': temp,
        'taskname': taskname,
        'taskdescription': taskdescription,
        'startdate': startdate.toUtc().millisecondsSinceEpoch,
        'enddate': enddate.toUtc().millisecondsSinceEpoch,
        'assignedto': assignedto,
        'attachments': attachments,
        'project': projectuid,
        'createdby': createdby,
        'iscompleted': false
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  List<Task> _taskDataFromSnapShot(QuerySnapshot querysnapshot) {
    print(querysnapshot);
    return querysnapshot.documents.map((snapshot) {
      print(snapshot.data['startdate']);
      String status = '';
      DateTime startdate = DateTime.fromMillisecondsSinceEpoch(
          snapshot.data['startdate'],
          isUtc: true);
      DateTime enddate = DateTime.fromMillisecondsSinceEpoch(
          snapshot.data['enddate'],
          isUtc: true);
      if (startdate.isBefore(DateTime.now()) &&
          enddate.isAfter(DateTime.now())) {
        status = 'inprogress';
      }
      if (startdate.isAfter(DateTime.now())) {
        status = 'upcoming';
      }
      if (enddate.isBefore(DateTime.now())) {
        status = 'completed';
      }
      return Task(
          taskuid: snapshot.data['taskuid'],
          taskname: snapshot.data['taskname'],
          taskdescription: snapshot.data['taskdescription'],
          assignedto: List.from(snapshot.data['assignedto']),
          attachments: List.from(snapshot.data['attachments']),
          project: snapshot.data['project'],
          createby: snapshot.data['createdby'],
          startdate: DateTime.fromMillisecondsSinceEpoch(
              snapshot.data['startdate'],
              isUtc: true),
          enddate: DateTime.fromMillisecondsSinceEpoch(snapshot.data['enddate'],
              isUtc: true),
          iscompleted: snapshot.data['iscompleted'],
          status: status);
    }).toList();
  }

  Stream<List<Task>> get tasks {
    return TaskCollection.where('project', isEqualTo: projectuid)
        .snapshots()
        .map(_taskDataFromSnapShot);
  }

  Stream<List<Task>> get mytasks {
    return TaskCollection.where('assignedto', arrayContains: email)
        .snapshots()
        .map(_taskDataFromSnapShot);
  }
}
