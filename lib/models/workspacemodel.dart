import 'package:scoped_model/scoped_model.dart';
import 'package:todo/models/workspace.dart';

class Workpsacemodel extends Model {
  Workspace workspace = Workspace();
  Workspace get currentworkspace => workspace;

  void changeworkspace(Workspace w) {
    this.workspace = w;
    notifyListeners();
  }
}
