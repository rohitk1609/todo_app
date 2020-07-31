import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/timermodel.dart';

class DialogTask extends StatefulWidget {
  List<Task> mytasks;
  DialogTask({this.mytasks});
  @override
  _DialogTaskState createState() => _DialogTaskState();
}

class _DialogTaskState extends State<DialogTask> {
  String selectedtask = '';
  int selectedradiotile;
  String selectedtaskuid = '';
  bool start = false;
  setselectedradiotile(val) {
    setState(() {
      selectedradiotile = val;
    });
  }

  Widget tasks(List<Task> mytasks, Timermodel model) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: new ExpansionTile(
          title: Text(
            selectedtask.isEmpty ? 'Select your task' : selectedtask,
            style: TextStyle(color: Colors.black),
          ),
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: mytasks.length,
                itemBuilder: (c, i) {
                  return RadioListTile(
                    groupValue: selectedradiotile,
                    onChanged: (val) {
                      setselectedradiotile(val);
                      print(mytasks[selectedradiotile].taskname);
                      model.changetask(mytasks[selectedradiotile]);
                      setState(() {
                        selectedtask = mytasks[selectedradiotile].taskname;
                        selectedtaskuid = mytasks[selectedradiotile].taskuid;
                      });
                    },
                    value: i,
                    title: Text('${mytasks[i].taskname}'),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text("DONE"),
                  onPressed: () {
                    Navigator.pop(context, mytasks[selectedradiotile]);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child:
            ScopedModelDescendant<Timermodel>(builder: (context, child, model) {
          return tasks(widget.mytasks, model);
        }),
      ),
    );
  }
}
