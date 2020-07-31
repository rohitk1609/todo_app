import 'package:todo/models/attachment.dart';
import 'package:todo/models/teammember.dart';

class Project {
  String projectuid;
  String projectname;
  String projectdescription;
  List<String> projectteam;
  List<String> projectaccess;
  List<Attachment> attachments;
  String projectlinks;
  String projectowner;
  DateTime projectdeadline;
  List<String> tasks;
  String status;
  String workspaceuid;

  Project(
      {this.projectuid,
      this.projectname,
      this.projectaccess,
      this.projectdescription,
      this.projectteam,
      this.attachments,
      this.projectlinks,
      this.projectowner,
      this.projectdeadline,
      this.tasks,
      this.status,
      this.workspaceuid});
}
