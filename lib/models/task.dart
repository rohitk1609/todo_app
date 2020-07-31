import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String taskname;
  String taskdescription;
  String taskuid;
  String project;
  List<String> attachments;
  List<String> assignedto;
  String createby;
  DateTime startdate;
  DateTime enddate;
  bool iscompleted;
  String status;

  Task(
      {this.taskname,
      this.taskdescription,
      this.project,
      this.assignedto,
      this.attachments,
      this.createby,
      this.taskuid,
      this.startdate,
      this.enddate,
      this.status,
      this.iscompleted});
}
