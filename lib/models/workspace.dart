import 'package:todo/models/teammember.dart';

class Workspace {
  String workspaceuid;
  String workspacename;
  String owner;
  List<String> projects;
  List<String> tasks;
  List<String> team;
  List<String> access;
  Workspace(
      {this.workspaceuid,
      this.workspacename,
      this.projects,
      this.tasks,
      this.team,
      this.owner,
      this.access});

  Map<String, dynamic> toJson() => {
        'workspaceuid': workspaceuid,
      };

  Workspace.fromJson(Map<String, dynamic> json)
      : workspaceuid = json['workspaceuid'];
}
